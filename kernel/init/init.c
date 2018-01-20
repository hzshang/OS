#include <kprintf.h>

void cga_init(){
	for(int i=0;i<80;i++){
		kprintf("\n");
	}
	set_cursor(0,0);
}

void kern_init(){
	cga_init();
	kprintf("welcome to my os\n");
	while(1){
		kprintf("hello,world\n");
		kprintf("welcome to my os\n");
	}
}
