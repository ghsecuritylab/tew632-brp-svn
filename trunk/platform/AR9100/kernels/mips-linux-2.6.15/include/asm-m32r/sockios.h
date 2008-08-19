#ifndef _ASM_M32R_SOCKIOS_H
#define _ASM_M32R_SOCKIOS_H

/* $Id: sockios.h,v 1.1.1.1 2007/06/26 07:59:43 albert Exp $ */

/* Socket-level I/O control calls. */
#define FIOSETOWN 	0x8901
#define SIOCSPGRP	0x8902
#define FIOGETOWN	0x8903
#define SIOCGPGRP	0x8904
#define SIOCATMARK	0x8905
#define SIOCGSTAMP	0x8906		/* Get stamp */

#endif  /* _ASM_M32R_SOCKIOS_H */
