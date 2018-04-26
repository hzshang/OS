
include ../.env
LIBC :=libc.so
INCLUDE_PATH :=../include


CFLAGS :=-I $(INCLUDE_PATH) -Wall -ggdb -c -fno-builtin
SRC_FILES := $(wildcard *.c)
OBJ_FILES := $(patsubst %.c,%.o,$(SRC_FILES))

all:$(LIBC)
	$(CP) $^ ../bin/
	@echo "libc compile success"

$(LIBC):$(OBJ_FILES)
	$(AR) rcs $@ $^

%.o: %.c
	$(CC) $(CFLAGS) $^ -o $@

clean:
	$(RM) $(OBJ_FILES) $(LIBC)
