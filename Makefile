# ============================================
# MinOS Build System
# ============================================

ASM = nasm
QEMU = qemu-system-i386

BOOT_SRC = boot/boot.asm
KERNEL_SRC = kernel/kernel.asm

BUILD = build
BOOT_BIN = $(BUILD)/boot.bin
KERNEL_BIN = $(BUILD)/kernel.bin
OS_IMAGE = $(BUILD)/os-image.bin

all: run

# --------------------------------------------
# Build bootloader
# --------------------------------------------
$(BOOT_BIN): $(BOOT_SRC)
	@mkdir -p $(BUILD)
	$(ASM) -f bin $(BOOT_SRC) -o $(BOOT_BIN)

# --------------------------------------------
# Build kernel
# --------------------------------------------
$(KERNEL_BIN): $(KERNEL_SRC)
	@mkdir -p $(BUILD)
	$(ASM) -f bin $(KERNEL_SRC) -o $(KERNEL_BIN)

# --------------------------------------------
# Create disk image
# --------------------------------------------
$(OS_IMAGE): $(BOOT_BIN) $(KERNEL_BIN)
	dd if=/dev/zero of=$(OS_IMAGE) bs=512 count=2880
	dd if=$(BOOT_BIN) of=$(OS_IMAGE) conv=notrunc
	dd if=$(KERNEL_BIN) of=$(OS_IMAGE) bs=512 seek=1 conv=notrunc

# --------------------------------------------
# Run in QEMU (FLOPPY MODE)
# --------------------------------------------
run: $(OS_IMAGE)
	$(QEMU) -fda $(OS_IMAGE)

# --------------------------------------------
# Clean build files
# --------------------------------------------
clean:
	rm -rf $(BUILD)

# --------------------------------------------
# Rebuild everything
# --------------------------------------------
rebuild: clean all