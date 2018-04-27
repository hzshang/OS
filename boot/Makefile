include ../.env


INCLUDE_PATH :=../include
CFLAGS := -I $(INCLUDE_PATH) -Wall -ggdb -fdebug-prefix-map=..=$(readlink -f ..) -gstabs -fno-stack-protector -Os -nostdinc -fno-pic -c

SRC_BOOTMAIN :=bootmain.c
SRC_BOOTASM :=bootasm.S
BUILD_DIR :=../bin/
BOOT_LD_SCRIPT :=boot.ld.S
BOOTLOADER :=$(BUILD_DIR)/bootloader

BOOTLOADER_ELF :=$(BOOTLOADER:.=.elf)
OBJ_BOOTASM :=$(SRC_BOOTMAIN:.c=.o)
OBJ_BOOTMAIN :=$(SRC_BOOTASM:.S=.o)

all: $(BOOTLOADER)
	@echo "bootloader compile success"

$(BOOTLOADER): $(OBJ_BOOTMAIN) $(OBJ_BOOTASM) $(BOOT_LD_SCRIPT)
	$(LD) -T $(word 3,$^) -o $(BOOTLOADER_ELF)  $(word 1,$^) $(word 2,$^)
	$(OBJCOPY) -S -O binary -j .text $(BOOTLOADER_ELF) $@

$(OBJ_BOOTMAIN): $(SRC_BOOTMAIN)
	$(CC) $(CFLAGS) $^ -o $@

$(OBJ_BOOTASM): $(SRC_BOOTASM)
	$(CC) $(CFLAGS) $^ -o $@

clean:
	$(RM) $(BOOTLOADER) $(OBJ_BOOTASM) $(OBJ_BOOTMAIN) $(BOOTLOADER_ELF)
