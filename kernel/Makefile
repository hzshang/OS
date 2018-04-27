include ../.env
#TODO
KERNEL :=../bin/kernel
INCLUDE_PATH :=../include
KERN_LD_SCRIPT :=kernel.ld.S
LIBC :=../bin/libc.so

CFLAGS :=-I $(INCLUDE_PATH) -c -ggdb -static -Wall

all: $(KERNEL)
	@echo "kernel compile success"

$(KERNEL): init/init.c $(KERN_LD_SCRIPT) $(LIBC)
	$(CC) $(CFLAGS) init/init.c -o init/init.o
	$(LD) -T $(KERN_LD_SCRIPT) init/init.o $(LIBC) -o $(KERNEL)

$(LIBC):
	+$(MAKE) -C ../libs

clean:
	$(RM) $(KERNEL)