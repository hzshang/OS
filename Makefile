include .env

INCLUDE_PATH :=include
TARGET :=bin/

KERN_LD_SCRIPT :=tools/kernel.ld.S


KERNEL :=$(TARGET)/kernel
OS_IMG :=$(TARGET)/os.img
LIBC :=$(TARGET)/libc.so
BOOTLOADER :=$(TARGET)/bootloader

all:$(OS_IMG)
	@echo "make done"

gdb:$(OS_IMG)
	qemu-system-i386 -S -s $(OS_IMG)

qemu: $(OS_IMG)
	qemu-system-i386 $(OS_IMG)

$(OS_IMG): $(BOOTLOADER) $(KERNEL)
	@tools/buildImg.sh $@ $^

$(KERNEL):
	+$(MAKE) -C kernel

$(LIBC):
	+$(MAKE) -C libs

$(BOOTLOADER):
	+$(MAKE) -C boot

clean:
	+$(MAKE) clean -C libs
	+$(MAKE) clean -C boot
	+$(MAKE) clean -C kernel
	$(RM) bin/*
