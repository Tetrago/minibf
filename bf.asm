        xor r14, r14
        mov rdi, [rsp + 0x10]
        mov rax, 2
        xor esi, esi
        xor edx, edx
        syscall
        mov r12, rax
        lea r13, [data + 4096]
loop:   call next
        jmp [data + rax * 8]
next:   inc r14
        xor eax, eax
        mov rdi, r12
        lea rsi, [rsp - 1]
        mov byte [rsi], 0
        mov rdx, 1
        syscall
        movzx eax, byte [rsp - 1]
        ret
id:     sub rax, 44
        sub [r13], al
        jmp loop
lr:     sub rax, 61
        add r13, rax
        jmp loop
start:  mov al, [r13]
        test al, al
        jz .skip
        push r14
        jmp loop
.skip:  xor r15, r15
inc:    inc r15
sloop:  call next
        jmp [data + 2048 + rax * 8]
dec:    dec r15
        jnz sloop
        jmp loop
end:    pop r14
        dec r14
        mov rsi, r14
        mov rax, 8
        mov rdi, r12
        xor edx, edx
        syscall
        jmp loop
out:    mov rsi, r13
        lea rdi, [rsp - 1]
        movsb
in:     sub rax, 44
        shr rax, 1
        mov rdi, rax
        lea rsi, [rsp - 1]
        mov rdx, 1
        syscall
        test di, di
        jnz loop
        mov rdi, r13
        movsb
        jmp loop
exit:   mov rax, 60
        xor edi, edi
        syscall
        section .data
data:   dq exit, 42 dup(loop), id, in, id, out, 13 dup(loop), lr, loop, lr, 28 dup(loop), start, loop, end, 162 dup(loop), exit, 90 dup(sloop), inc, sloop, dec, 162 dup(sloop), 0x40 dup(0)
