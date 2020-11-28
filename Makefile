KERNEL_VERSION = 4.19.157
KERNEL_SRC = kernel_src/
KERNEL_BIN = $(KERNEL_SRC)/arch/x86/boot/bzImage
KERNEL_BIN_NAME = vmlinuz-$(KERNEL_VERSION)-llenotre

INITRAMFS = initramfs.img

all: compile_packages tmp_linux.iso
	./compile_packages.sh

$(KERNEL_BIN): Makefile
	./download_kernel.sh
	make -C $(KERNEL_SRC) xconfig
	make -C $(KERNEL_SRC) prepare
	make -C $(KERNEL_SRC) kernelrelease
	make -C $(KERNEL_SRC)

$(INITRAMFS): Makefile
	mkdir -p initramfs/{bin,etc,proc,sys}
	cd initramfs/ && find . | cpio -H newc -o | gzip >../$(INITRAMFS)

tmp: tmp_linux.iso

tmp_linux.iso: $(KERNEL_BIN) $(INITRAMFS) grub.cfg
	mkdir -p iso/boot/grub/
	cp grub.cfg iso/boot/grub/
	cp $(KERNEL_BIN) iso/boot/$(KERNEL_BIN_NAME)
	cp $(INITRAMFS) iso/boot/$(INITRAMFS)
# TODO Copy packages
	grub-mkrescue -o $@ iso

clean:
	make -C $(KERNEL_SRC) clean
	make -C $(KERNEL_SRC) mrproper
	rm -rf initramfs/
	rm -rf iso/

fclean: clean
	rm -rf $(KERNEL_SRC)
	rm -f $(KERNEL_BIN)
	rm -rf pkg_sources
	rm initramfs.img

.PHONY: compile_packages tmp clean fclean
