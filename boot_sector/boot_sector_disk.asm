; load dh sectors from drive dl into ES:BX
disk_load:
    pusha ; save registers
    push dx ; save parameter

    mov ah, 0x02 ; read
    mov al, dh ; sector count
    mov cl, 0x02 ; sector number
    mov ch, 0x00 ; cylinder
    mov dh, 0x00 ; head number
    int 0x13 ; read disk sector
    jc disk_error ; carry set if read failure

    pop dx
    cmp al, dh
    jne sectors_error ; sectors read not equal to dh

    popa ; restore registers
    ret ; return from function

disk_error:
    ; print error messages
    mov bx, DISK_ERROR
    call print
    call print_nl
    mov dh, ah ; ah = error code, dl = drive that dropped the code
    call print_hex

    jmp disk_loop

sectors_error:
    ; print error messages
    mov bx, SECTORS_ERROR
    call print

disk_loop:
    jmp $

DISK_ERROR: db "Disk read error", 0
SECTORS_ERROR: db "Incorrect number of sectors read", 0