#ifndef __INCLUDE_KPRINTF_H
#define __INCLUDE_KPRINTF_H
#include <stdargs.h>
#include <screen.h>
/* change number to char
 * valid base: 2, 8, 10
 **/
enum KP_LEVEL {KPL_DUMP, KPL_PANIC};

void kprintf(const char *fmt, ...);

#endif
