include ../.env


INCLUDE_PATH :=../include
CFLAGS := -I $(INCLUDE_PATH) -Wall -ggdb -gstabs -fno-stack-protector -Os -nostdinc -fno-pic -c

SRC_BOOTMAIN :=bootmain.c
SRC_BOOTASM :=bootasm.S
BOOT_LD_SCRIPT :=boot.ld.S
BOOTLOADER :=../bin/bootloader
BOOTLOADER_ELF :=bootloader.elf

OBJ_BOOTASM :=$(SRC_BOOTMAIN:.c=.o)
OBJ_BOOTMAIN :=$(SRC_BOOTASM:.S=.o)

all: $(BOOTLOADER)
	@echo "bootloader compile success"

$(BOOTLOADER): $(BOOTLOADER_ELF)
	$(OBJCOPY) -S -O binary -j .text $< $@

$(BOOTLOADER_ELF): $(OBJ_BOOTMAIN) $(OBJ_BOOTASM) $(BOOT_LD_SCRIPT)
	$(LD) -T $(word 3,$^) -o $@  $(word 1,$^) $(word 2,$^)

$(OBJ_BOOTMAIN): $(SRC_BOOTMAIN)
	$(CC) $(CFLAGS) $^ -o $@

$(OBJ_BOOTASM): $(SRC_BOOTASM)
	$(CC) $(CFLAGS) $^ -o $@

clean:
	$(RM) $(BOOTLOADER) $(OBJ_BOOTASM) $(OBJ_BOOTMAIN) $(BOOTLOADER_ELF)
