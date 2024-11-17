
# C++ Compiler Parameters
CPPPARAMS= -m32 -fno-use-cxa-atexit -nostdlib -fno-builtin -fno-rtti -fno-exceptions -fno-leading-underscore

# Assembler Parameters
ASMPARAMS= --32

LDPARAMS= -melf_i386

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
