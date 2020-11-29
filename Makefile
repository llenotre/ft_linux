KERNEL_VERSION = 4.19.157
KERNEL_SRC = kernel_src/
KERNEL_BIN = $(KERNEL_SRC)/arch/x86/boot/bzImage
KERNEL_BIN_NAME = vmlinuz-$(KERNEL_VERSION)-llenotre

INITRAMFS = initramfs.img
INITRAMFS_DIR = initramfs/

all: tmp_linux.iso

compile_packages:
	./compile_packages.sh

$(KERNEL_BIN): Makefile
	./download_kernel.sh
	make -C $(KERNEL_SRC) xconfig
	make -C $(KERNEL_SRC) prepare
	make -C $(KERNEL_SRC) kernelrelease
	make -C $(KERNEL_SRC)

$(INITRAMFS): Makefile init compile_packages
	rm -rf $(INITRAMFS_DIR)
	mkdir -p $(INITRAMFS_DIR)/{bin,sbin,etc,proc,sys}
	cp init $(INITRAMFS_DIR)
	cp pkg_builds/bash-5.1-rc2/bash $(INITRAMFS_DIR)/bin/
	cp `find pkg_builds/coreutils-8.32/src/ -type f -executable` $(INITRAMFS_DIR)/bin/
	cd $(INITRAMFS_DIR)/ && find . | cpio -H newc -o | gzip >../$(INITRAMFS)

tmp: tmp_linux.iso

tmp_linux.iso: $(KERNEL_BIN) $(INITRAMFS) grub.cfg
	mkdir -p iso/boot/grub/
	cp grub.cfg iso/boot/grub/
	cp $(KERNEL_BIN) iso/boot/$(KERNEL_BIN_NAME)
	cp $(INITRAMFS) iso/boot/$(INITRAMFS)
	grub-mkrescue -o $@ iso

clean:
	make -C $(KERNEL_SRC) clean
	make -C $(KERNEL_SRC) mrproper
	rm -rf pkg_builds/
	rm -rf initramfs/
	rm -rf iso/

fclean: clean
	# TODO Remove kernel source archive
	rm -rf $(KERNEL_SRC)
	rm -f $(KERNEL_BIN)
	rm -rf pkg_sources
	rm initramfs.img

re: fclean all

.PHONY: compile_packages tmp clean fclean re
