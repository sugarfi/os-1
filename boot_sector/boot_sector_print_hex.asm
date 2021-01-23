print_hex:
    pusha ; save registers

    mov cx, 0 ; index variable

hex_loop:
    cmp cx, 4 ; 4 bytes to print per word
    je end

    mov ax, dx
    and ax, 0x000f ; mask for the first byte
    add al, 0x30 ; get ascii value of number
    cmp al, 0x39 ; if digit is 9 or lower, continue
    jle step2

    add al, 0x7 ; represent as letter

step2:
    mov bx, HEX_OUT + 5 ; put hex symbol at end of HEX_OUT
    sub bx, cx
    mov [bx], al

    ror dx, 4 ; rotate right to get the next hex digit

    add cx, 1 ; increment index and loop
    jmp hex_loop

end:
    mov bx, HEX_OUT ; print hex string
    call print

    popa ; restore registers
    ret ; return from function

HEX_OUT:
    db '0x0000', 0 ; reserve memory for hex string
