KERNEL_VERSION = 4.19.157
KERNEL_SRC = kernel_src/
KERNEL_BIN = $(KERNEL_SRC)/arch/x86/boot/bzImage
KERNEL_BIN_NAME = vmlinuz-$(KERNEL_VERSION)-llenotre

INITRAMFS = initramfs.img
INITRAMFS_DIR = initramfs/

all: tmp_linux.iso

$(KERNEL_BIN): Makefile
	./download_kernel.sh
	make -C $(KERNEL_SRC) xconfig
	make -C $(KERNEL_SRC) prepare
	make -C $(KERNEL_SRC) kernelrelease
	make -C $(KERNEL_SRC)

$(INITRAMFS): Makefile tmp_init compile_packages.sh
	rm -rf $(INITRAMFS_DIR) installed
	mkdir -p $(INITRAMFS_DIR)/{etc,proc,sys,mnt}
	mkdir -p $(INITRAMFS_DIR)/{usr/bin,usr/share,usr/lib,usr/local,usr/include}
	cd $(INITRAMFS_DIR) && ln -rs usr/bin bin && ln -rs usr/lib lib && ln -rs usr/lib lib64
	cd $(INITRAMFS_DIR)/usr && ln -rs lib lib64 && ln -rs bin sbin
	make -C $(KERNEL_SRC) headers_install ARCH=i386 INSTALL_HDR_PATH=../$(INITRAMFS_DIR)/usr
	./compile_packages.sh --tmp
	cp tmp_init $(INITRAMFS_DIR)/init
	cd $(INITRAMFS_DIR)/ && find . | cpio -H newc -o | gzip >../$(INITRAMFS)

tmp: tmp_linux.iso

tmp_linux.iso: $(INITRAMFS) grub.cfg #$(KERNEL_BIN)
	mkdir -p iso/boot/grub/
	cp grub.cfg iso/boot/grub/
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
