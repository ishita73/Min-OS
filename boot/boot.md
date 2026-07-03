The architecture we'll build
```
boot.asm
│
├── Boot Sector
├── BIOS Print
├── Disk Read
├── Enable A20
├── GDT
├── Protected Mode
├── 32-bit Stack
└── Jump to Kernel
            │
            ▼
kernel.c / kernel.asm
│
├── VGA Driver (no bios)
├── Memory Manager
├── IDT
├── Keyboard Driver
├── Timer
└── Shell
```

after boot.asm run these
---

> nasm -f bin boot/boot.asm -o build/boot.bin
> 
> nasm -f bin kernel/kernel.asm -o build/kernel.bin
> 
> cat build/boot.bin build/kernel.bin > build/os-image.bin

glitchy screen 

            1.Create a REAL floppy image:
            
            2.Write bootloader into sector 0
            
            3.Write kernel into sector 2+
            
            4.Run correctly- floopy mode 

dd if=/dev/zero of=build/os-image.bin bs=512 count=2880    

dd if=build/boot.bin of=build/os-image.bin conv=notrunc

dd if=build/kernel.bin of=build/os-image.bin bs=512 seek=1 conv=notrunc

qemu-system-i386 -fda build/os-image.bin
