/*
 * JFFS2 -- Journalling Flash File System, Version 2.
 *
 * Copyright (C) 2001-2003 Red Hat, Inc.
 *
 * Created by David Woodhouse <dwmw2@infradead.org>
 *
 * For licensing information, see the file 'LICENCE' in this directory.
 *
 * $Id: ioctl.c,v 1.1.1.1 2007/06/26 07:59:14 albert Exp $
 *
 */

#include <linux/fs.h>

int jffs2_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
		unsigned long arg)
{
	/* Later, this will provide for lsattr.jffs2 and chattr.jffs2, which
	   will include compression support etc. */
	return -ENOTTY;
}

