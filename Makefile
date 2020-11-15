KERNEL_VERSION = 4.19.157
KERNEL_BIN = vmlinuz-$(KERNEL_VERSION)-llenotre
KERNEL_SRC = kernel_src/

$(KERNEL_BIN):
	./download_kernel.sh
	make -C $(KERNEL_SRC) clean
	make -C $(KERNEL_SRC) mrproper
	make -C $(KERNEL_SRC) xconfig
	make -C $(KERNEL_SRC) prepare
	make -C $(KERNEL_SRC) kernelrelease
	make -C $(KERNEL_SRC)
	cp kernel_src/vmlinux $(KERNEL_BIN)

# TODO Compile packages

tmp: tmp_linux.iso

tmp_linux.iso: $(KERNEL) grub.cfg
	mkdir -p iso/boot/grub/
	cp grub.cfg iso/boot/grub/
	cp $(KERNEL_BIN) iso/boot/
	grub-mkrescue -o $@ iso

clean:
	rm -rf $(KERNEL_SRC)
	# TODO Packages sources
	rm -rf iso/

fclean: clean
	rm -f $(KERNEL_BIN)
	# TODO Remove packages executables

.PHONY: download_kernel tmp clean fclean
