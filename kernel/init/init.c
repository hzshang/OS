#include <kprintf.h>

void kern_init(){
	kprintf(KPL_DUMP,"hello,world!");
	while(1);
}
