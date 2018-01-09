PREFIX=i386-pc-elf-

CC := $(PREFIX)gcc
LD := $(PREFIX)ld
OBJCOPY :=$(PREFIX)objcopy
OBJDUMP := $(PREFIX)objdump
STRIP :=$(PREFIX)strip

RM := rm -f
INCLUDE_PATH := include
CFLAG := -I $(INCLUDE_PATH) -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Os -nostdinc -fno-pic
BOOT_LD_SCRIPT := boot/boot.ld.S
BOOT_LDFLAG := -T $(BOOT_LD_SCRIPT)

BOOTMAIN := bin/bootmain.o
BOOTASM := bin/bootasm.o
BOOTLOADER := bin/bootloader
KERNEL := bin/kernel
BOOTLOADER_ELF :=bin/bootloader.debug

all: $(BOOTLOADER) $(KERNEL)
	@tools/buildImg.sh
	@echo "make done"

gdb:
	qemu-system-i386 -S -s bin/os.img

$(BOOTLOADER): $(BOOTMAIN) $(BOOTASM) $(BOOT_LD_SCRIPT)
	$(LD) $(BOOT_LDFLAG) -o $(BOOTLOADER_ELF)  $(BOOTMAIN) $(BOOTASM)
	$(OBJCOPY) -S -O binary -j .text $(BOOTLOADER_ELF) $(BOOTLOADER)

$(BOOTMAIN): boot/bootmain.c
	$(CC) $(CFLAG)   boot/bootmain.c -c -o $(BOOTMAIN)

$(BOOTASM): boot/bootasm.S
	$(CC) $(CFLAG)   boot/bootasm.S -c -o $(BOOTASM)

$(KERNEL): kernel/init.c
	$(CC) kernel/init.c -g -o $(KERNEL)
	$(OBJCOPY) --only-keep-debug $(KERNEL) bin/kernel.debug
	$(OBJCOPY) --strip-debug $(KERNEL)
clean:
	$(RM) bin/*
