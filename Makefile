PREFIX=i386-pc-elf-

CC := $(PREFIX)gcc
RM := rm -f
INCLUDE_PATH := include
CFLAG := -I $(INCLUDE_PATH)


all:
	$(CC) $(CFLAG) boot/bootasm.S -c -o bin/bootasm.o
	$(CC) $(CFLAG) boot/bootmain.c -c -o bin/bootmain.o
clean:
	$(RM) bin/*.o bin/*.img
