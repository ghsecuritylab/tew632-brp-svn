/* RSH extension for IP connection tracking, Version 1.0
 * (C) 2002 by Ian (Larry) Latter <Ian.Latter@mq.edu.au>
 * based on HW's ip_conntrack_irc.c	
 *
 * (C) 2004,2005 by David Stes <stes@pandora.be>
 * Modification for Legato NetWorker range [7937-9936] instead of [0:1023]
 *
 * (C) 2005 by David Stes <stes@pandora.be>
 * Upgrade to 2.6.13 API
 *
 * ip_conntrack_rsh.c,v 1.0 2002/07/17 14:49:26
 *
 *      This program is free software; you can redistribute it and/or
 *      modify it under the terms of the GNU General Public License
 *      as published by the Free Software Foundation; either version
 *      2 of the License, or (at your option) any later version.
 **
 *	Module load syntax:
 * 	insmod ip_conntrack_rsh.o range=1023,ports=port1,port2,...port<MAX_PORTS>
 *	
 * 	please give the ports of all RSH servers You wish to connect to.
 *	If You don't specify ports, the default will be port 514
 **
 *      Note to all:
 *        RSH blows ... you should use SSH (openssh.org) to replace it,
 *        unfortunately I babysit some sysadmins that won't migrate
 *	  their legacy crap, in our second tier.
 */


/*
 *  Some docco ripped from the net to teach me all there is to know about
 *  RSH, in 16.5 seconds (ie, all of the non-netfilter docco used to write
 *  this module).
 *
 *  I have no idea what "unix rshd man pages" these guys have .. but that
 *  is some pretty detailed docco!
 **
 *
 *  4. Of the rsh protocol.
 *  -----------------------
 * 
 *   The rshd listens on TCP port #514. The following info is from the unix
 *   rshd man pages :
 * 
 *   "Service Request Protocol
 * 
 *    When the rshd daemon receives a service request, it initiates the
 *    following protocol:
 * 
 *     1. The rshd daemon checks the source port number for the request.
 *        If the port number is not in the range 0 through 1023, the rshd daemon
 *        terminates the connection.
 * 
 *     2. The rshd daemon reads characters from the socket up to a null byte.
 *        The string read is interpreted as an ASCII number (base 10). If this
 *        number is nonzero, the rshd daemon interprets it as the port number
 *        of a secondary stream to be used as standard error. A second connection
 *        is created to the specified port on the client host. The source port
 *        on the local host is in the range 0 through 1023.
 * 
 *     3. The rshd daemon uses the source address of the initial connection
 *        request to determine the name of the client host. If the name cannot
 *        be determined, the rshd daemon uses the dotted decimal representation
 *        of the client host's address.
 * 
 *     4. The rshd daemon retrieves the following information from the initial
 *        socket:
 * 
 *         * A null-terminated string of at most 16 bytes interpreted as
 *           the user name of the user on the client host.
 * 
 *         * A null-terminated string of at most 16 bytes interpreted as
 *           the user name to be used on the local server host.
 * 
 *         * Another null-terminated string interpreted as a command line
 *           to be passed to a shell on the local server host.
 * 
 *     5. The rshd daemon attempts to validate the user using the following steps:
 * 
 *         a. The rshd daemon looks up the local user name in the /etc/passwd
 *            file and tries to switch to the home directory (using the chdir
 *            subroutine). If either the lookup or the directory change fails,
 *            the rshd daemon terminates the connection.
 * 
 *         b. If the local user ID is a nonzero value, the rshd daemon searches
 *            the /etc/hosts.equiv file to see if the name of the client
 *            workstation is listed. If the client workstation is listed as an
 *            equivalent host, the rshd daemon validates the user.
 * 
 *         c. If the $HOME/.rhosts file exists, the rshd daemon tries to
 *            authenticate the user by checking the .rhosts file.
 * 
 *         d. If either the $HOME/.rhosts authentication fails or the
 *            client host is not an equivalent host, the rshd daemon
 *            terminates the connection.
 * 
 *     6. Once rshd validates the user, the rshd daemon returns a null byte
 *        on the initial connection and passes the command line to the user's
 *        local login shell. The shell then inherits the network connections
 *        established by the rshd daemon."
 * 
 */


#include <linux/module.h>
#include <linux/netfilter.h>
#include <linux/ip.h>
#include <net/checksum.h>
#include <net/tcp.h>

#include <linux/netfilter_ipv4/ip_tables.h>
#include <linux/netfilter_ipv4/ip_conntrack_helper.h>
#include <linux/netfilter_ipv4/ip_conntrack_rsh.h>

#define MAX_PORTS 8
static int range; /* defaults to = 1023 */
static unsigned short rangemask; /* defaults to = 0xfc00 */
static int ports[MAX_PORTS];
static int ports_n_c = 0;

MODULE_AUTHOR("Ian (Larry) Latter <Ian.Latter@mq.edu.au>");
MODULE_DESCRIPTION("RSH connection tracking module");
MODULE_LICENSE("GPL");
#ifdef MODULE_PARM
module_param(range, int, 0400);
MODULE_PARM_DESC(range, "max port of reserved range (default is 1023)");
module_param_array(ports, int, &ports_n_c, 0400);
MODULE_PARM_DESC(ports, "port numbers of RSH servers");
#endif

static DEFINE_SPINLOCK(rsh_buffer_lock);
static char rsh_buffer[65535];

unsigned int (*ip_nat_rsh_hook)(struct sk_buff **pskb,
				enum ip_conntrack_info ctinfo,
				unsigned int matchoff,
				struct ip_conntrack_expect *exp);

#define PRINTK(format, args...) printk(KERN_DEBUG "ip_conntrack_rsh: " \
					format, ## args)

#if 0
#define DEBUGP(format, args...) printk(KERN_DEBUG "ip_conntrack_rsh: " \
					format, ## args)
#else
#define DEBUGP(format, args...)
#endif


/* FIXME: This should be in userspace.  Later. */
static int help(struct sk_buff **pskb,
		struct ip_conntrack *ct, enum ip_conntrack_info ctinfo)
{
	struct tcphdr _tcph, *th;
	char *data, *rb_ptr;
	int ret = NF_ACCEPT;
	int dir = CTINFO2DIR(ctinfo);
        struct ip_conntrack_expect *exp;
	unsigned int dataoff, datalen;
	u_int16_t port;
	int maxoctet = 4;

	/*  note that "maxoctet" is used to maintain sanity (8 was the
 	 *  original array size used in rshd/glibc) -- is there a
	 *  vulnerability in rshd.c in the looped port *= 10?
 	 */

	DEBUGP("entered\n");

	/* bail if packet is not from RSH client */
	if (dir == IP_CT_DIR_REPLY) {
		return NF_ACCEPT; 
	}

	/* Until there's been traffic both ways, don't look in packets. */
	if (ctinfo != IP_CT_ESTABLISHED
	    && ctinfo != IP_CT_ESTABLISHED + IP_CT_IS_REPLY) {
		DEBUGP("Conntrackinfo = %u\n", ctinfo);
		return NF_ACCEPT;
	}

	/* Not a full tcp header? */
	th = skb_header_pointer(*pskb, (*pskb)->nh.iph->ihl*4,
				sizeof(_tcph), &_tcph);
	if (!th) {
		DEBUGP("rsh: skb_header_pointer null\n");
		return NF_ACCEPT;
	}

	/* No data? */
	dataoff = (*pskb)->nh.iph->ihl*4 + th->doff*4;
	if (dataoff >= (*pskb)->len) {
		return NF_ACCEPT;
	}
	datalen = (*pskb)->len - dataoff;
	spin_lock_bh(&rsh_buffer_lock);
	rb_ptr = skb_header_pointer(*pskb, dataoff, datalen, rsh_buffer);
	BUG_ON(rb_ptr == NULL);
	data = rb_ptr;

	DEBUGP("rsh: find rsh stderr port datalen %u\n",datalen);

	maxoctet = 5;
	port = 0;
	for ( ; *data != 0 && maxoctet != 0; data++, maxoctet--) {
		if (*data < 0) {
			ret = 1; goto out;
		}
		if (*data == 0) {
			break;
		}
		if (*data < 48 || *data > 57) {
			DEBUGP("these aren't the packets you're looking for ..\n");
			ret = NF_ACCEPT; goto out;
		}
	        port = port * 10 + ( *data - 48 );
	}

	/* dont relate sessions that try to expose the client */
	if (port == 0) {
           DEBUGP("skipping, port is 0!\n");
	   ret = NF_ACCEPT;goto out;
	}

	DEBUGP("found port %u\n", port);
	if (port > range) {
		DEBUGP("skipping, expected port size is greater than range!\n");
		return NF_ACCEPT;
	}

	exp = ip_conntrack_expect_alloc(ct);
	if (!exp) {
		ret = NF_DROP;
		goto out;
	}

	/*  new(,related) connection is;
	 *          reply + dst (uint)port + src port (0:1023)
	 */

	/* Watch out, Radioactive-Man! */
	exp->tuple.src.ip = ct->tuplehash[!dir].tuple.src.ip;
	exp->tuple.dst.ip = ct->tuplehash[!dir].tuple.dst.ip;
	exp->tuple.src.u.tcp.port = 0;
	exp->tuple.dst.u.tcp.port = htons(port);
	exp->tuple.dst.protonum = IPPROTO_TCP;

	exp->mask.src.ip = 0xffffffff;
	exp->mask.dst.ip = 0xffffffff;

	exp->mask.src.u.tcp.port = htons(rangemask);
	exp->mask.dst.u.tcp.port = htons(0xffff);
	exp->mask.dst.protonum = 0xff;

	exp->expectfn = NULL;
	exp->master = ct;

	DEBUGP("expect related ip   %u.%u.%u.%u:%u-%u.%u.%u.%u:%u\n",
		NIPQUAD(exp->tuple.src.ip),
		ntohs(exp->tuple.src.u.tcp.port),
		NIPQUAD(exp->tuple.dst.ip),
		ntohs(exp->tuple.dst.u.tcp.port));

	DEBUGP("expect related mask %u.%u.%u.%u:%u-%u.%u.%u.%u:%u\n",
		NIPQUAD(exp->mask.src.ip),
		ntohs(exp->mask.src.u.tcp.port),
		NIPQUAD(exp->mask.dst.ip),
		ntohs(exp->mask.dst.u.tcp.port));

	if (ip_nat_rsh_hook)
		ret = ip_nat_rsh_hook(pskb, ctinfo, rb_ptr - data, exp);
	else if (ip_conntrack_expect_related(exp) != 0) {
		ret = NF_DROP;
	}

	ip_conntrack_expect_put(exp);

out:
	spin_unlock_bh(&rsh_buffer_lock);
	return ret;
}

static struct ip_conntrack_helper rsh_helpers[MAX_PORTS];
static char rsh_names[MAX_PORTS][10];

static void fini(void);

static int __init init(void)
{
	int port, ret;
	char *tmpname;

	/* If no port given, default to standard RSH port */
	if (ports[0] == 0)
		ports[0] = RSH_PORT;

	/* the check on reserved port <1023 doesn't work with Legato */
        /* for Legato NetWorker, the check should be that port <= 9936 */ 

        if (range == 0) 
		range = 1023;

	/* Legato uses range [ 7937 : 9936 ] -> 7937 by default */

        rangemask = 0xffff ^ range; /* defaults to = 0xfc00 */

	for (port = 0; (port < MAX_PORTS) && ports[port]; port++) {
		memset(&rsh_helpers[port], 0, sizeof(struct ip_conntrack_helper));

		tmpname = &rsh_names[port][0];
		if (ports[port] == RSH_PORT)
			sprintf(tmpname, "rsh");
		else
			sprintf(tmpname, "rsh-%d", ports[port]);
		rsh_helpers[port].name = tmpname;

		rsh_helpers[port].me = THIS_MODULE;
		rsh_helpers[port].max_expected = 1;
		rsh_helpers[port].timeout = 5; /* stes bug timeout=0 */

		rsh_helpers[port].tuple.dst.protonum = IPPROTO_TCP;
		rsh_helpers[port].mask.dst.protonum = 0xff;

		/* RSH must come from ports 0:1023 to ports[port] (514) */
		rsh_helpers[port].tuple.src.u.tcp.port = htons(ports[port]);
		rsh_helpers[port].mask.src.u.tcp.port = htons(rangemask);
		rsh_helpers[port].mask.dst.u.tcp.port = htons(rangemask);

		rsh_helpers[port].help = help;

		PRINTK("registering helper for port #%d: %d/TCP\n", port, ports[port]);
		PRINTK("helper match ip   %u.%u.%u.%u:%u-%u.%u.%u.%u:%u\n",
			NIPQUAD(rsh_helpers[port].tuple.src.ip),
			ntohs(rsh_helpers[port].tuple.src.u.tcp.port),
			NIPQUAD(rsh_helpers[port].tuple.dst.ip),
			ntohs(rsh_helpers[port].tuple.dst.u.tcp.port));
		PRINTK("helper match mask %u.%u.%u.%u:%u-%u.%u.%u.%u:%u\n",
			NIPQUAD(rsh_helpers[port].mask.src.ip),
			ntohs(rsh_helpers[port].mask.src.u.tcp.port),
			NIPQUAD(rsh_helpers[port].mask.dst.ip),
			ntohs(rsh_helpers[port].mask.dst.u.tcp.port));

		ret = ip_conntrack_helper_register(&rsh_helpers[port]);

		if (ret) {
			printk("ERROR registering port %d\n",
				ports[port]);
			fini();
			return -EBUSY;
		}
		ports_n_c++;
	}
	return 0;
}

/* This function is intentionally _NOT_ defined as __exit, because 
 * it is needed by the init function */
static void fini(void)
{
	int port;
	for (port = 0; (port < MAX_PORTS) && ports[port]; port++) {
		DEBUGP("unregistering port %d\n", ports[port]);
		ip_conntrack_helper_unregister(&rsh_helpers[port]);
	}
}

module_init(init);
module_exit(fini);
