[org 0x7c00]

KERNEL_OFFSET equ 0x1000

    mov [BOOT_DRIVE], dl ; dl set up by BIOS

    mov bp, 0x9000 ; setting up the stack far from the code
    mov sp, bp

    mov bx, MSG_REAL_MODE
    call print
    call print_nl

    call load_kernel
    call switch_to_pm
    jmp $

%include "boot-sector/bootsect-print.asm"
%include "boot-sector/bootsect-print-hex.asm"
%include "boot-sector/bootsect-disk.asm"
%include "boot-sector/32bit-gdt.asm"
%include "boot-sector/32bit-print.asm"
%include "boot-sector/32bit-switch.asm"

[bits 16]
load_kernel:
    mov bx, MSG_LOAD_KERNEL
    call print
    call print_nl

    mov bx, KERNEL_OFFSET ; read from disk and store at 0x1000
    mov dh, 2
    mov dl, [BOOT_DRIVE]
    call disk_load
    ret

[bits 32]
BEGIN_PM:
    mov ebx, MSG_PROT_MODE
    call print_string_pm
    call KERNEL_OFFSET ; give control to the kernel
    jmp $ ; if kernel returns, infinite loop

BOOT_DRIVE db 0
MSG_REAL_MODE db "started in 16-bit real mode", 0
MSG_PROT_MODE db "started in 32-bit protected mode", 0
MSG_LOAD_KERNEL db "loading kernel into memory", 0

; padding and special number
times 510-($-$$) db 0
dw 0xaa55