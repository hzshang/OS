include ../.env

kernel :=kernel.elf
INCLUDE_PATH :=../include
ld_script :=kernel.ld.S
libc :=../libs/libc.so


object = init/init.o
CFLAGS :=-I $(INCLUDE_PATH) -c -ggdb -static -Wall

all: $(kernel)
	@echo "kernel compile success"

$(kernel): $(object) $(ld_script) 
	$(LD) -T $(ld_script) $< $(libc) -o $(kernel)

clean:
	$(RM) $(kernel)