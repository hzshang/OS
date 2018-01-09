PREFIX=i386-pc-elf-

CC := $(PREFIX)gcc
LD := $(PREFIX)ld
OBJCOPY :=$(PREFIX)objcopy
OBJDUMP := $(PREFIX)objdump
RM := rm -f
INCLUDE_PATH := include
CFLAG := -I $(INCLUDE_PATH) -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Os -nostdinc
BOOT_LD_SCRIPT := boot/boot.ld.S
BOOT_LDFLAG := -T $(BOOT_LD_SCRIPT)

BOOTMAIN := bin/bootmain.o
BOOTASM := bin/bootasm.o
BOOTLOADER :=bin/bootloader

$(BOOTLOADER): $(BOOTMAIN) $(BOOTASM) $(BOOT_LD_SCRIPT)
	$(LD) $(BOOT_LDFLAG) -g -o bin/bootloader.o $(BOOTMAIN) $(BOOTASM)
	$(OBJDUMP) -S bin/bootloader.o > bin/bootloader.asm
	$(OBJCOPY) -S -O binary -j .text bin/bootloader.o $(BOOTLOADER)

$(BOOTMAIN): boot/bootmain.c include/elf.h include/x86.h
	$(CC) $(CFLAG) -fno-pic -nostdinc boot/bootmain.c -c -o $(BOOTMAIN)

$(BOOTASM): boot/bootasm.S include/asm.h
	$(CC) $(CFLAG) -fno-pic -nostdinc boot/bootasm.S -c -o $(BOOTASM)

clean:
	$(RM) bin/*
