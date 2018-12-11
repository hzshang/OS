include ../.env

kernel :=kernel.elf
INCLUDE_PATH :=-I ../include -Imm -Itrap -Iinit -Idriver
ld_script :=kernel.ld.S
libc :=../libs/libc.so


object = init/init.o \
		 driver/picirq.o driver/clock.o\
		 mm/pmm.o\
		 trap/vector.o trap/trap.o trap/trapenter.o

CFLAGS :=$(INCLUDE_PATH) -c -ggdb -static -Wall

all: $(kernel)
	@echo "kernel compile success"

$(kernel): $(object) $(ld_script) 
	$(LD) -T $(ld_script) $^ $(libc) -o $(kernel)

trap/vector.o: trap/vectors.S
	$(CC) $(CFLAGS) -c $^ -o $@

trap/trapenter.o: trap/trapenter.S
	$(CC) $(CFLAGS) -c $^ -o $@

clean:
	$(RM) $(kernel)
	$(RM) */*.o
