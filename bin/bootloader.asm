
bin/bootloader.o:     file format elf32-i386


Disassembly of section .text:

00007c00 <_start>:
    7c00:	fa                   	cli    
    7c01:	fc                   	cld    
    7c02:	31 c0                	xor    %eax,%eax
    7c04:	8e d8                	mov    %eax,%ds
    7c06:	8e c0                	mov    %eax,%es
    7c08:	8e d0                	mov    %eax,%ss

00007c0a <seta20.1>:
    7c0a:	e4 64                	in     $0x64,%al
    7c0c:	a8 02                	test   $0x2,%al
    7c0e:	75 fa                	jne    7c0a <seta20.1>
    7c10:	b0 d1                	mov    $0xd1,%al
    7c12:	e6 64                	out    %al,$0x64

00007c14 <seta20.2>:
    7c14:	e4 64                	in     $0x64,%al
    7c16:	a8 02                	test   $0x2,%al
    7c18:	75 fa                	jne    7c14 <seta20.2>
    7c1a:	b0 df                	mov    $0xdf,%al
    7c1c:	e6 60                	out    %al,$0x60
    7c1e:	0f 01 16             	lgdtl  (%esi)
    7c21:	98                   	cwtl   
    7c22:	7d 0f                	jge    7c33 <protcseg+0x1>
    7c24:	20 c0                	and    %al,%al
    7c26:	66 83 c8 01          	or     $0x1,%ax
    7c2a:	0f 22 c0             	mov    %eax,%cr0
    7c2d:	ea                   	.byte 0xea
    7c2e:	32 7c 08 00          	xor    0x0(%eax,%ecx,1),%bh

00007c32 <protcseg>:
    7c32:	66 b8 10 00          	mov    $0x10,%ax
    7c36:	8e d8                	mov    %eax,%ds
    7c38:	8e c0                	mov    %eax,%es
    7c3a:	8e e0                	mov    %eax,%fs
    7c3c:	8e e8                	mov    %eax,%gs
    7c3e:	8e d0                	mov    %eax,%ss
    7c40:	bd 00 00 00 00       	mov    $0x0,%ebp
    7c45:	bc 00 7c 00 00       	mov    $0x7c00,%esp
    7c4a:	e8 9c 00 00 00       	call   7ceb <bootmain>

00007c4f <loop>:
    7c4f:	eb fe                	jmp    7c4f <loop>

00007c51 <readseg>:

    // read a sector
    insl(0x1F0, dst, SECTSIZE);
}

void readseg(uintptr_t va,uint32_t count,uint32_t offset){
    7c51:	55                   	push   %ebp
    7c52:	89 e5                	mov    %esp,%ebp
    7c54:	57                   	push   %edi
    7c55:	56                   	push   %esi
    7c56:	53                   	push   %ebx
    7c57:	53                   	push   %ebx
    uintptr_t end_va = va + count;
    7c58:	8d 3c 10             	lea    (%eax,%edx,1),%edi
    7c5b:	89 7d f0             	mov    %edi,-0x10(%ebp)

    // round down to sector boundary
    va -= offset % SECTSIZE;
    7c5e:	89 ca                	mov    %ecx,%edx
    7c60:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
    7c66:	29 d0                	sub    %edx,%eax
    7c68:	89 c3                	mov    %eax,%ebx

    // translate from bytes to sectors; kernel starts at sector 1
    uint32_t secno = (offset / SECTSIZE);
    7c6a:	c1 e9 09             	shr    $0x9,%ecx
    7c6d:	89 ce                	mov    %ecx,%esi

    // If this is too slow, we could read lots of sectors at a time.
    // We'd write more to memory than asked, but it doesn't matter --
    // we load in increasing order.
    for (; va < end_va; va += SECTSIZE, secno ++) {
    7c6f:	3b 5d f0             	cmp    -0x10(%ebp),%ebx
    7c72:	73 71                	jae    7ce5 <readseg+0x94>
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
    7c74:	ba f7 01 00 00       	mov    $0x1f7,%edx
    7c79:	ec                   	in     (%dx),%al
    while ((inb(0x1F7) & 0xC0) != 0x40)
    7c7a:	83 e0 c0             	and    $0xffffffc0,%eax
    7c7d:	3c 40                	cmp    $0x40,%al
    7c7f:	75 f3                	jne    7c74 <readseg+0x23>
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
    7c81:	ba f2 01 00 00       	mov    $0x1f2,%edx
    7c86:	b0 01                	mov    $0x1,%al
    7c88:	ee                   	out    %al,(%dx)
    7c89:	ba f3 01 00 00       	mov    $0x1f3,%edx
    7c8e:	89 f0                	mov    %esi,%eax
    7c90:	ee                   	out    %al,(%dx)
    outb(0x1F4, (secno >> 8) & 0xFF);
    7c91:	89 f0                	mov    %esi,%eax
    7c93:	c1 e8 08             	shr    $0x8,%eax
    7c96:	ba f4 01 00 00       	mov    $0x1f4,%edx
    7c9b:	ee                   	out    %al,(%dx)
    outb(0x1F5, (secno >> 16) & 0xFF);
    7c9c:	89 f0                	mov    %esi,%eax
    7c9e:	c1 e8 10             	shr    $0x10,%eax
    7ca1:	ba f5 01 00 00       	mov    $0x1f5,%edx
    7ca6:	ee                   	out    %al,(%dx)
    outb(0x1F6, ((secno >> 24) & 0xF) | 0xE0);
    7ca7:	89 f0                	mov    %esi,%eax
    7ca9:	c1 e8 18             	shr    $0x18,%eax
    7cac:	83 e0 0f             	and    $0xf,%eax
    7caf:	83 c8 e0             	or     $0xffffffe0,%eax
    7cb2:	ba f6 01 00 00       	mov    $0x1f6,%edx
    7cb7:	ee                   	out    %al,(%dx)
    7cb8:	b0 20                	mov    $0x20,%al
    7cba:	ba f7 01 00 00       	mov    $0x1f7,%edx
    7cbf:	ee                   	out    %al,(%dx)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
    7cc0:	ba f7 01 00 00       	mov    $0x1f7,%edx
    7cc5:	ec                   	in     (%dx),%al
    while ((inb(0x1F7) & 0xC0) != 0x40)
    7cc6:	83 e0 c0             	and    $0xffffffc0,%eax
    7cc9:	3c 40                	cmp    $0x40,%al
    7ccb:	75 f3                	jne    7cc0 <readseg+0x6f>
    asm volatile (
    7ccd:	89 df                	mov    %ebx,%edi
    7ccf:	b9 00 02 00 00       	mov    $0x200,%ecx
    7cd4:	ba f0 01 00 00       	mov    $0x1f0,%edx
    7cd9:	fc                   	cld    
    7cda:	f2 6d                	repnz insl (%dx),%es:(%edi)
    for (; va < end_va; va += SECTSIZE, secno ++) {
    7cdc:	81 c3 00 02 00 00    	add    $0x200,%ebx
    7ce2:	46                   	inc    %esi
    7ce3:	eb 8a                	jmp    7c6f <readseg+0x1e>
        readsect((void *)va, secno);
    }
}
    7ce5:	58                   	pop    %eax
    7ce6:	5b                   	pop    %ebx
    7ce7:	5e                   	pop    %esi
    7ce8:	5f                   	pop    %edi
    7ce9:	5d                   	pop    %ebp
    7cea:	c3                   	ret    

00007ceb <bootmain>:
void bootmain(void) {
    7ceb:	55                   	push   %ebp
    7cec:	89 e5                	mov    %esp,%ebp
    7cee:	57                   	push   %edi
    7cef:	56                   	push   %esi
    7cf0:	53                   	push   %ebx
    7cf1:	83 ec 1c             	sub    $0x1c,%esp

static inline uint32_t get_lba(int n){
	uint32_t lba;
	for (int i = 0; i < 4; i++) {
		((uint8_t *)&lba)[i] = mbr[454 + 16 * (n - 1) + i];
    7cf4:	a1 00 81 00 00       	mov    0x8100,%eax
    7cf9:	8a 90 d6 01 00 00    	mov    0x1d6(%eax),%dl
    7cff:	88 55 e4             	mov    %dl,-0x1c(%ebp)
    7d02:	8a 90 d7 01 00 00    	mov    0x1d7(%eax),%dl
    7d08:	88 55 e5             	mov    %dl,-0x1b(%ebp)
    7d0b:	8a 90 d8 01 00 00    	mov    0x1d8(%eax),%dl
    7d11:	88 55 e6             	mov    %dl,-0x1a(%ebp)
    7d14:	8a 80 d9 01 00 00    	mov    0x1d9(%eax),%al
    7d1a:	88 45 e7             	mov    %al,-0x19(%ebp)
	uint32_t base=get_lba(2)*SECTSIZE;//the offset of kernel in the disk
    7d1d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
    7d20:	c1 e7 09             	shl    $0x9,%edi
    readseg((uintptr_t)elf, SECTSIZE * 8, base);
    7d23:	89 f9                	mov    %edi,%ecx
    7d25:	ba 00 10 00 00       	mov    $0x1000,%edx
    7d2a:	b8 00 00 01 00       	mov    $0x10000,%eax
    7d2f:	e8 1d ff ff ff       	call   7c51 <readseg>
    if (elf->e_magic != ELF_MAGIC) {
    7d34:	81 3d 00 00 01 00 7f 	cmpl   $0x464c457f,0x10000
    7d3b:	45 4c 46 
    7d3e:	75 3c                	jne    7d7c <bootmain+0x91>
    ph = (struct proghdr *)((uintptr_t)elf + elf->e_phoff);
    7d40:	a1 1c 00 01 00       	mov    0x1001c,%eax
    7d45:	8d 98 00 00 01 00    	lea    0x10000(%eax),%ebx
    eph = ph + elf->e_phnum;
    7d4b:	0f b7 35 2c 00 01 00 	movzwl 0x1002c,%esi
    7d52:	c1 e6 05             	shl    $0x5,%esi
    7d55:	01 de                	add    %ebx,%esi
    for (; ph < eph; ph ++) {
    7d57:	39 f3                	cmp    %esi,%ebx
    7d59:	73 15                	jae    7d70 <bootmain+0x85>
        readseg(va, ph->p_memsz, base+ph->p_offset);
    7d5b:	8b 4b 04             	mov    0x4(%ebx),%ecx
    7d5e:	01 f9                	add    %edi,%ecx
    7d60:	8b 53 14             	mov    0x14(%ebx),%edx
    7d63:	8b 43 08             	mov    0x8(%ebx),%eax
    7d66:	e8 e6 fe ff ff       	call   7c51 <readseg>
    for (; ph < eph; ph ++) {
    7d6b:	83 c3 20             	add    $0x20,%ebx
    7d6e:	eb e7                	jmp    7d57 <bootmain+0x6c>
    void (*entry)(void)=(void(*)(void))(elf->e_entry & 0xFFFFFF);
    7d70:	a1 18 00 01 00       	mov    0x10018,%eax
    7d75:	25 ff ff ff 00       	and    $0xffffff,%eax
    entry();
    7d7a:	ff d0                	call   *%eax
    7d7c:	eb fe                	jmp    7d7c <bootmain+0x91>
        movw %ax, %ss               # -> SS: Stack Segment
        movl $0x0, %ebp
        movl $_start, %esp
        call bootmain
loop:
        jmp loop
    7d7e:	66 90                	xchg   %ax,%ax

00007d80 <gdt>:
	...
    7d88:	ff                   	(bad)  
    7d89:	ff 00                	incl   (%eax)
    7d8b:	00 00                	add    %al,(%eax)
    7d8d:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
    7d94:	00                   	.byte 0x0
    7d95:	92                   	xchg   %eax,%edx
    7d96:	cf                   	iret   
	...

00007d98 <gdtdesc>:
    7d98:	17                   	pop    %ss
    7d99:	00                   	.byte 0x0
    7d9a:	80 7d 00 00          	cmpb   $0x0,0x0(%ebp)
