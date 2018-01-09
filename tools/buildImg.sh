#!/bin/sh
dd if=/dev/zero of=bin/os.img bs=512 count=200 
mkfs.fat bin/os.img >>/dev/null
(
echo n # Add a new partition
echo p # Primary partition
echo 2 # Partition number
echo 5 # First sector (Accept default: 1)
echo 100 # Last sector (Accept default: varies)
echo a
echo w # Write changes
) | fdisk  bin/os.img

dd if=bin/bootloader of=bin/os.img  conv=notrunc 
dd if=bin/kernel of=bin/os.img seek=5 bs=512 conv=notrunc 
echo "Success:type \"qemu-system-i386 bin/os.img\" to run"
