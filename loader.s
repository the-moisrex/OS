.set MAGIC, 0x1badb002
.set FLAGS, (1 << 0 | 1 << 1)
.set CHECKSUM, -(MAGIC + FLAGS)

# Magic values to identify it's a kernel:
.section .multiboot
    .long MAGIC
    .long FLAGS
    .long CHECKSUM

.section .text
.extern kernel_main
.extern call_constructors
.global loader

loader:
    mov $kernel_stack, %esp

    # Call C++ class constructors
    call call_constructors

    # Call kernel main
    push %eax # multi boot struct pointer
    push %ebx # magic number
    call kernel_main

    # infinite loop in case we come out of kernel_main:
_stop:
    cli
    hlt
    jmp _stop


.section .bss
.space 2*1024*1024  # 2 MiB
kernel_stack:
