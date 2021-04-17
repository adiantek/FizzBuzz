bits 16
org 0x7c00

boot:
    mov ax, 0x2401
    int 0x15

mov ax, 0x3
int 0x10

lgdt [gdt_pointer]
mov eax, cr0 
or eax,0x1
mov cr0, eax
jmp CODE_SEG:boot2

gdt_start:
    dq 0x0
gdt_code:
    dw 0xFFFF
    dw 0x0
    db 0x0
    db 10011010b
    db 11001111b
    db 0x0
gdt_data:
    dw 0xFFFF
    dw 0x0
    db 0x0
    db 10010010b
    db 11001111b
    db 0x0
gdt_end:

gdt_pointer:
    dw gdt_end - gdt_start
    dd gdt_start
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

bits 32

boot2:
    call fizzbuzz
    lodsb
    or al,al
    cli
    hlt

fizzbuzz:
    push    ebp
    push    ebx
    push    edi
    push    esi
    xor     eax, eax
    inc     eax
    mov     ecx, 0xB8000
    mov     edi, 255
.LBB0_1:
    mov     edx, eax
    and     edx, edi
    imul    esi, edx, 205
    shr     esi, 10
    lea     ebp, [esi + 4*esi]
    imul    edx, edx, 171
    shr     edx, 9
    lea     edx, [edx + 2*edx]
    neg     edx
    mov     ebx, eax
    sub     ebx, ebp
    add     dl, al
    je      .LBB0_2
    test    bl, bl
    je      .LBB0_4
    and     esi, -2
    lea     ebx, [esi + 4*esi]
    neg     ebx
    and     ebx, edi
    cmp     eax, 11
    jb      .LBB0_7
    movzx   edx, al
    imul    edx, edx, 205
    shr     edx, 11
    add     dl, 48
    mov     byte [ecx], dl
    mov     byte [ecx + 1], 15
    add     ecx, 2
.LBB0_7:
    add     ebx, eax
    or      bl, 48
    lea     esi, [ecx + 1]
    mov     byte [ecx], bl
    add     ecx, 2
    jmp     .LBB0_8
.LBB0_2:
    mov     dword [ecx], 0x0F690F66
    mov     dword [ecx + 4], 0x0F7A0F7A
    add     ecx, 8
    test    bl, bl
    jne     .LBB0_9
.LBB0_4:
    mov     dword [ecx], 0x0F750F62
    mov     word [ecx + 4], 0x0F7A
    lea     esi, [ecx + 7]
    mov     byte [ecx + 6], 122
    add     ecx, 8
.LBB0_8:
    mov     byte [esi], 15
.LBB0_9:
    mov     word [ecx], 0x0F20
    add     ecx, 2
    inc     eax
    cmp     eax, 101
    jne     .LBB0_1
    pop     esi
    pop     edi
    pop     ebx
    pop     ebp
    ret

times 510 - ($-$$) db 0
dw 0xaa55
times 163840 - ($-$$) db 0