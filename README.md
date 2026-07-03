
A lightweight operating system built from scratch in **C** and **x86 Assembly** .

 Diving into bootloader, kernel, memory management, interrupt handling, device drivers, and a shell.

# #OS

> *An attempt to build an operating system from scratch.*
>
> *What could possibly go wrong?*

---

## ⚙️ How a Computer Boots
```
When you turn on a computer:
Power ON
↓
BIOS starts
↓
Reads first 512 bytes from boot device
↓
Loads it into memory at 0x7C00
↓
Executes it (our bootloader)
```
---

## 📁 Project Structure

```
MinOS/
│
├── boot/
│ └── boot.asm # Bootloader (entry point)
│
├── kernel/
│ ├── kernel.asm # Early kernel experiments
│ └── kernel.c # Future C kernel
│
├── build/
│ ├── boot.bin
│ ├── kernel.bin
│ └── os-image.bin
│
├── linker.ld # Linker script
├── Makefile # Build system
└── README.md
```

---

## 🛠️ Tools Used

- NASM (Assembly compiler)
- GCC (C compiler)
- LD (Linker)
- QEMU (OS emulator)
- Make (build automation)
- WSL (Ubuntu on Windows)

  ---
  
## 🗺️ Roadmap

- [x] Bootloader
- [x] Bootable OS in QEMU
- [x] BIOS screen output
- [x] Load kernel from disk
- [x] Switch to Protected Mode (32-bit)
- [ ] VGA text driver
- [ ] Keyboard driver
- [ ] Memory management
- [ ] Interrupt handling
- [ ] Shell (command line)
- [ ] File system
- [ ] Multitasking
- [ ] User programs

---

---

## Core components


| Component | Description |
|-----------|-------------|
| Bootloader | Custom x86 boot stage, loads the kernel from disk |
| Kernel | Minimal C kernel, sets up GDT/IDT |
| VGA output | Direct text-mode display via memory-mapped I/O |
| Keyboard | IRQ-driven input handler |
| Shell | Basic command-line interface |
| Memory & IRQs | Segmentation, paging, interrupt handling |

--- 
