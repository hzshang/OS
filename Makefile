include .env

INCLUDE_PATH :=include
TARGET :=bin/

KERN_LD_SCRIPT :=tools/kernel.ld.S


kernel :=kernel/kernel.elf
libc :=libs/libc.so
bootloader :=boot/bootloader
img :=bin/os.img

all:$(img)
	@echo "make done"

gdb:$(img)
	$(QEMU) -curses -S -s $(img)

qemu: $(img)
	$(QEMU) -curses $(img)

$(img):$(bootloader) $(kernel)
	@tools/buildImg.sh $@ $^

$(kernel): |$(libc)
	$(MAKE) -C kernel

$(bootloader):
	+$(MAKE) -C boot

$(libc):
	+$(MAKE) -C libs

clean:
	+$(MAKE) clean -C libs
	+$(MAKE) clean -C boot
	+$(MAKE) clean -C kernel
	$(RM) bin/*
