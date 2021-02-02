KERNEL_DIR ?= .

KERNEL_VERSION = 4.19.157
KERNEL_SRC = $(KERNEL_DIR)/kernel_src/
KERNEL_BIN = $(KERNEL_SRC)/arch/x86/boot/bzImage
KERNEL_BIN_NAME = vmlinuz-$(KERNEL_VERSION)-llenotre

INITRAMFS = initramfs.img
INITRAMFS_DIR = initramfs/

INSTALL_SYSTEM_PATH = iso/install/

all: tmp_linux.iso

$(KERNEL_BIN): Makefile
	./download_kernel.sh
	make -C $(KERNEL_SRC) xconfig
	make -C $(KERNEL_SRC) prepare
	make -C $(KERNEL_SRC) kernelrelease
	make -C $(KERNEL_SRC)

$(INITRAMFS): Makefile tmp_init compile_packages.sh source_urls deps
	./compile_packages.sh 0
	cp tmp_init $(INITRAMFS_DIR)/init
	rm -rf initramfs/home/* initramfs/usr/share/man/
	cd $(INITRAMFS_DIR)/ && find . | cpio -H newc -o | gzip >../$(INITRAMFS)

tmp: tmp_linux.iso

tmp_linux.iso: $(INITRAMFS) grub.cfg #$(KERNEL_BIN)
	mkdir -p iso/boot/grub/
	cp grub.cfg iso/boot/grub/
	./compile_packages.sh 1
	./compile_packages.sh 2
	./copy_installer.sh
	cp -f $(KERNEL_BIN) iso/boot/$(KERNEL_BIN_NAME)
	cp -f $(INITRAMFS) iso/boot/$(INITRAMFS)
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

.PHONY: prepeare_initramfs tmp clean fclean re
