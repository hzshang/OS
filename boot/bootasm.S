



.globl _start
_start:
.code16
        cli
        cld
        xorw    %ax,%ax             # Set %ax to zero
        movw    %ax,%ds             # -> Data Segment
        movw    %ax,%es             # -> Extra Segment
        movw    %ax,%ss             # -> Stack Segment
        