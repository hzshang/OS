#include <stdio.h>
#include <pmm.h>
#include <trap.h>
#include <x86.h>
#include <picirq.h>
#include <clock.h>
void cga_init(){
	for(int i=0;i<80;i++){
		kprintf("\n");
	}
	set_cursor(0,0);
}

void intr_enable(){
    sti();
}
void intr_disable(){
    cli();
}

void kern_init(){
    extern char edata[],end[];
    memset(edata,0,end-edata);

	cga_init();
    pmm_init();
    pic_init(); // if not, os will stuck by int 13
    clock_init();
    
    intr_init();

	kprintf("welcome to my os\n");
    intr_enable();

    asm("int $0x80");
    while(1);
}

