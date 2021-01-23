print:
    pusha ; save registers

start:
    mov al, [bx]
    cmp al, 0 ; if null char
    je done

    mov ah, 0x0e ; ttl mode
    
    int 0x10

    add bx, 1 ; increment char pointer
    jmp start

done:
    popa ; restore registers
    ret ; return from function

print_nl:
    pusha ; save registers

    mov ah, 0x0e ; ttl mode

    mov al, 0x0a ; newline
    int 0x10
    mov al, 0x0d ; carriage return
    int 0x10

    popa ; restore registers
    ret ; return from function