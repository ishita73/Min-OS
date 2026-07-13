;  print func->disk routines -> enable A20-> GDT-> protected mode-> C kernel
; Phase 1 - writing bootloader in x86 asm
;boot/
;│── boot.asm          ; Entry point
;│── print.asm         ; BIOS print routines
;│── disk.asm          ; Disk loading
;│── a20.asm           ; Enable A20
;│── gdt.asm           ; GDT + descriptors
;│── protected.asm     ; Switch to protected mode




[bits 16]
[org 0x7C00]                    ;  bootloader starts  at 0x7C00



  BOOT_DRIVE db 0
start:
     mov [BOOT_DRIVE], dl    ; [BOOT_DRIVE] = 0x80 (first hard disk)

    mov si, msg
    call print

    call enable_a20            ; MUST happen before protected mode
    
    call load_disk             ; load kernel from disk into memory at 0x1000
 
    call load_gdt

    call switch_to_pm           ; switch to 32-bit protected mode
    





print:
    mov al, [si]       ; load character into AL
    cmp al, 0          ; check if end of string
    je print_done
                ; if 0 → stop
    mov ah, 0x0E       ; BIOS teletype function

    int 0x10           ; print character in AL
    inc si             ; next character     
    jmp print          ; repeat loop

print_done:
    ret


enable_a20:
    in al, 0x92        ; read port 0x92 (System Control Port A)
    or al, 0x02        ; set bit 1 to enable A20
    out 0x92, al       ; write back to port 0x92
    ret

    

load_disk:             ;  (BIOS interrupt 13h)
    mov ah, 0x02       ; read sectors from disk
    mov al, 2        ; sectors to read
    mov ch, 0x00       ; cylinder 0
    mov cl, 0x02       ; starting with sector 2 (first sector of kernel) 
    
    mov dh, 0x00          ; num of sectors
    mov dl, [BOOT_DRIVE]       ; boot drive
    mov bx, 0x1000     ; kernel load address
    int 0x13
    ret



; ---- GDT ----
; Each descriptor is 8 bytes laid out as:
; limit(0-15), base(0-15), base(16-23), access, flags+limit(16-19), base(24-31)

                                     
gdt_start:

gdt_null:
    dq 0                               ; null descriptor-0 : It occupies 8 byte      (0x00)

gdt_code:                             ; creates the descriptor-1 : code/  for executable code  (0x08)
    dw 0xFFFF                         ; Code starts at: 0x00000000 
    dw 0x0000
    db 0x00                            ; permissions: executable , readable, kernel only 
    db 10011010b
    db 11001111b
    db 0x00                  
;  dw 0xFFFF, 0, 0x9A00, 0x00CF
;  dq  0x00CF9A000000FFFF

gdt_data:
                    ; another descriptor-2: data/ for variable ,stack ,arrays, string  (0x10)
                    ;dq 0x00CF92000000FFFF
    dw 0xFFFF
    dw 0x0000
    db 0x00
    db 10010010b
    db 11001111b
    db 0x00

gdt_end:

gdt_desc:                           ; CPU doesn't search memory for the GDT on its own 
    dw gdt_end - gdt_start - 1
    dd gdt_start



load_gdt:

    cli                              ; prevents interrupts while switching CPU modes.
    lgdt [gdt_desc]                  ; load GDT descriptor 
    ret                              ; "CPU, here is your new GDT."



    ; Next:
    ; switch_to_protected_mode

 
 switch_to_pm:

   
    mov eax, cr0                     ; read CR0, set bit 0
    or eax, 1                        ; set PE bit in CR0 to enable protected mode
    mov cr0, eax                     ; flip the protected mode bit
    jmp 0x08:init_pm                 ; far jump to code segment selector (0x08) and init_pm label into 32-bit land
                            
;Without this jump, the CPU may continue executing using the old real-mode instruction prefetch, leading to undefined behavior.
    
[bits 32]            ; 32-BIT PROTECTED MODE ENTRY


init_pm:

    mov ax, 0x10   ; point to data segment
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax     ;all data accesses use your protected-mode data segment.
    mov ss, ax
    mov esp, 0x90000     ;a stack pointer at address

    jmp 0x1000      ; jump to our C kernel!
    jmp $



[bits 16]       
msg db "Hello from Bootloader !", 0



times 510-($-$$) db 0                         ; pad to 510 bytes
dw 0xAA55                                     ;  BIOS ending signature for bootloader
