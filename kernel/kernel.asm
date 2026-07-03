

; before : BIOS → Bootloader → prints text
; after this phae : BIOS → Bootloader → Kernel → prints text

; ============================================
; Phase 2 -  woeking with kernel
; loading kernel into bootload
; ============================================

[bits 16]
[org 0x1000]              ; Kernel will be loaded at memory address 0x1000



start:
    mov si, msg           ; si pointer to string for ex: char*si= msd (in c)
    call print_string

print_string:
    mov al, [si]          ; Load character into AL            alternatives -> lodsb ( AL=[si]->si=si+1)
    cmp al, 0             ; check if end of string                            or al,al  (if al==0, FLAG =1)
    je done               ; if 0 → stop                                                  (elso al!=0, FLAG =0)   
                                                       
    mov ah, 0x0E          ;                                                    jz done (jumps to done if zero flag is set) 
    int 0x10              ;  print character in AL

    inc si                ; Next character
    jmp print_string      ; repeat loop

done:
    jmp done              ; Infinite loop

msg db "Hello from MinOS Kernel!", 0

