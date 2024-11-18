
# C++ Compiler Parameters
CPPPARAMS= -m32 -fno-use-cxa-atexit -nostdlib -fno-builtin -fno-rtti -fno-exceptions -fno-leading-underscore

# Assembler Parameters
ASMPARAMS= --32

LDPARAMS= -melf_i386

QEMUOPTIONS := -no-reboot -boot d -device VGA,edid=on,xres=1024,yres=768 # -trace events=/tmp/qemuTrace.txt -d cpu_reset #-readconfig qemu-usb-config.cfg -drive if=none,id=stick,file=disk.img -device usb-storage,bus=ehci.0,drive=stick


# Object files
objects = loader.o kernel.o

%.o: %.cpp
	g++ $(CPPPARAMS) -o $@ -c $<

%.o: %.s
	as $(ASMPARAMS) -o $@ $<

kernel.bin: linker.ld $(objects)
	ld $(LDPARAMS) -T $< -o $@ $(objects)

install: kernel.bin
	sudo cp $< /boot/kernel.bin

kernel.iso: kernel.bin grub/grub.cfg
	rm -f $@
	rm -rf iso
	mkdir iso
	mkdir iso/boot
	mkdir iso/boot/grub
	cp kernel.bin iso/boot/kernel.bin
	cp grub/grub.cfg iso/boot/grub/grub.cfg
	grub-mkrescue --output=$@ iso
	rm -rf iso

run: kernel.iso
	qemu-system-i386 -cdrom $< $(QEMUOPTIONS) -serial stdio &

run-kernel: kernel.bin
	qemu-system-i386 $(QEMUOPTIONS) -serial stdio -kernel kernel.bin &

clean:
	rm -f $(objects)
	rm -f kernel.bin
	rm -rf iso
	rm -rf kernel.iso
