PREFIX=i386-pc-elf-

CC := $(PREFIX)gcc
LD := $(PREFIX)ld
AR := $(PREFIX)ar
OBJCOPY :=$(PREFIX)objcopy
OBJDUMP := $(PREFIX)objdump
STRIP :=$(PREFIX)strip

RM := rm -f
INCLUDE_PATH := include
CFLAG := -I $(INCLUDE_PATH) -Wall -ggdb -m32 -gstabs -fno-stack-protector -Os -nostdinc -fno-pic -c

BOOT_LD_SCRIPT := tools/boot.ld.S
KERN_LD_SCRIPT := tools/kernel.ld.S

BOOTMAIN := bin/bootmain.o
BOOTASM := bin/bootasm.o
BOOTLOADER := bin/bootloader
KERNEL := bin/kernel
BOOTLOADER_ELF :=bin/bootloader.debug
LIBC :=bin/libc.so
OS_IMG :=bin/os.img

all:$(OS_IMG)
	@echo "make done"

$(OS_IMG): $(LIBC) $(BOOTLOADER) $(KERNEL)
	@tools/buildImg.sh

gdb:
	qemu-system-i386 -S -s bin/os.img

$(BOOTLOADER): $(BOOTMAIN) $(BOOTASM) $(BOOT_LD_SCRIPT)
	$(LD) -T $(BOOT_LD_SCRIPT) -o $(BOOTLOADER_ELF)  $(BOOTMAIN) $(BOOTASM)
	$(OBJCOPY) -S -O binary -j .text $(BOOTLOADER_ELF) $(BOOTLOADER)

$(BOOTMAIN): boot/bootmain.c
	$(CC) $(CFLAG) boot/bootmain.c -o $(BOOTMAIN)

$(BOOTASM): boot/bootasm.S
	$(CC) $(CFLAG) boot/bootasm.S -o $(BOOTASM)

KERNEL_CC_FLAG :=-I $(INCLUDE_PATH) -c -ggdb -static
$(KERNEL): kernel/init/init.c $(KERN_LD_SCRIPT)
	$(CC) $(KERNEL_CC_FLAG) kernel/init/init.c -o kernel/init/init.o
	$(LD) -T $(KERN_LD_SCRIPT) kernel/init/init.o $(LIBC) -o $(KERNEL)
	$(RM) kernel/init/init.o
	#TODO stripe debug info
	#$(OBJCOPY) --only-keep-debug $(KERNEL) $(KERNEL).debug
	#$(OBJCOPY) --strip-debug $(KERNEL)
	#$(OBJCOPY) --add-gnu-debuglink=$(KERNEL).debug $(KERNEL)

LIBC_FLAG := -I $(INCLUDE_PATH) -Wall -ggdb -m32 -c -fno-builtin

$(LIBC): libs/*
	$(CC) $(LIBC_FLAG) libs/libcc.c -o libs/libcc.o
	$(CC) $(LIBC_FLAG) libs/screen.c -o libs/screen.o
	$(CC) $(LIBC_FLAG) libs/stdio.c -o libs/stdio.o
	$(CC) $(LIBC_FLAG) libs/string.c -o libs/string.o
	$(CC) $(LIBC_FLAG) libs/kprintf.c -o libs/kprintf.o
	$(AR) rcs $(LIBC) libs/*.o
	#$(OBJCOPY) --only-keep-debug $(LIBC) $(LIBC).debug
	#$(OBJCOPY) --strip-debug $(LIBC)
	#$(OBJCOPY) --add-gnu-debuglink=$(LIBC).debug $(LIBC)
	$(RM) libs/*.o

qemu: $(OS_IMG)
	qemu-system-i386 $(OS_IMG)
	

clean:
	$(RM) bin/*
