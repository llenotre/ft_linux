KERNEL_VERSION = 4.19.157
KERNEL_SRC = kernel_src/
KERNEL_BIN = $(KERNEL_SRC)/vmlinux
KERNEL_BIN_NAME = vmlinuz-$(KERNEL_VERSION)-llenotre

all: compile_packages $(KERNEL_BIN)
	./compile_packages.sh

$(KERNEL_BIN):
	./download_kernel.sh
	make -C $(KERNEL_SRC) clean
	make -C $(KERNEL_SRC) mrproper
	make -C $(KERNEL_SRC) xconfig
	make -C $(KERNEL_SRC) prepare
	make -C $(KERNEL_SRC) kernelrelease
	make -C $(KERNEL_SRC)
	cp kernel_src/vmlinux $(KERNEL_BIN)

tmp: tmp_linux.iso

tmp_linux.iso: $(KERNEL_BIN) grub.cfg
	mkdir -p iso/boot/grub/
	cp grub.cfg iso/boot/grub/
	cp $(KERNEL_BIN) iso/boot/$(KERNEL_BIN_NAME)
# TODO Copy packages
	grub-mkrescue -o $@ iso

clean:
	rm -rf $(KERNEL_SRC)
	# TODO Packages sources
	rm -rf iso/

fclean: clean
	rm -rf pkg_sources
	rm -f $(KERNEL_BIN)

.PHONY: compile_packages tmp clean fclean
