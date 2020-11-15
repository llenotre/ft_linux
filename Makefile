KERNEL_VERSION = 4.19.157
KERNEL_BIN = vmlinuz-$(KERNEL_VERSION)-llenotre
KERNEL_SRC = kernel_src/

$(KERNEL_BIN):
	./download_kernel.sh
	cd $(KERNEL_SRC)
	make xconfig
	make prepare
	make kernelrelease
	make

# TODO Compile packages

tmp: tmp_linux.iso

tmp_linux.iso: $(KERNEL)
	mkdir -p iso/grub/
	cp grub.cfg iso/grub/
	cp $(KERNEL_BIN)
	# TODO Build an iso

clean:
	rm -rf $(KERNEL_SRC)
	# TODO Packages sources
	rm -rf iso/

fclean: clean
	rm -f $(KERNEL_BIN)
	# TODO Remove packages executables

.PHONY: tmp clean fclean
