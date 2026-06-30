 [bits 16]
[org 0x1000]

start:
    mov si, msg

print:
    lodsb
    or al, al
    jz halt

    mov ah, 0x0E
    int 0x10
    jmp print

halt:
    cli
    hlt
    jmp halt

msg db "Hello from MinOS Kernel!", 0