#ifndef _ASM_M32R_BUGS_H
#define _ASM_M32R_BUGS_H

/* $Id: bugs.h,v 1.1.1.1 2007/06/26 07:59:43 albert Exp $ */

/*
 * This is included by init/main.c to check for architecture-dependent bugs.
 *
 * Needs:
 *     void check_bugs(void);
 */
#include <asm/processor.h>

static void __init check_bugs(void)
{
	extern unsigned long loops_per_jiffy;

	current_cpu_data.loops_per_jiffy = loops_per_jiffy;
}

#endif  /* _ASM_M32R_BUGS_H */
