        xor r14, r14
        mov rdi, [rsp + 0x10]
        mov rax, 2
        xor esi, esi
        xor edx, edx
        syscall
        mov r12, rax
        sub rsp, 0x200
        mov r13, rsp
        mov rcx, 0x200 / 8
        xor eax, eax
        mov rdi, rsp
        rep stosq
loop:   call next
        jmp [data + rax * 8]
next:   inc r14
        xor eax, eax
        mov rdi, r12
        lea rsi, [rsp - 1]
        mov rdx, 1
        syscall
        mov dl, [rsp - 1]
        test rax, rax
        cmovnz rax, rdx
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
.skip:  xor r15d, r15d
.inc:   inc r15
.loop:  call next
        cmp al, '['
        je .inc
        cmp al, ']'
        jne .loop
        dec r15
        jnz .loop
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
data:   dq exit, 42 dup(loop), id, in, id, out, 13 dup(loop), lr, loop, lr, 28 dup(loop), start, loop, end, 34 dup(loop)
