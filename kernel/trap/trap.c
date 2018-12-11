#include <trap.h>
#include <types.h>
#include <x86.h>
#include <mmu.h>
#include <memlayout.h>
#include <stdio.h>
#include <clock.h>
#define TICK_NUM 100
static struct gatedesc idt[256] = {{0}};
static struct pseudodesc idt_pd = {
    sizeof(idt) - 1, (uintptr_t)idt
};

void intr_init(){
    extern uintptr_t __vectors[];
    for(int i=0;i<sizeof(idt)/sizeof(struct gatedesc);i++){
        SETGATE(idt[i],0,GD_KTEXT, __vectors[i], DPL_KERNEL);
    }
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
    lidt(&idt_pd);
}

void trap(struct trapframe *tf){
    switch(tf->tf_trapno){
        case IRQ_OFFSET + IRQ_TIMER:
            ticks++;
            if(ticks%TICK_NUM == 0){
                kprintf("%d ticks\n",TICK_NUM);
            }
            break;
        default:
            kprintf("unknown intr number: %d\n",tf->tf_trapno);
            break;
    }
}

