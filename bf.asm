        global  _start
next:   inc r14
        xor rax, rax
        mov rdi, r12
        lea rsi, [rsp - 1]
        mov rdx, 1
        syscall
        mov dl, [rsp - 1]
        test rax, rax
        cmovnz rax, rdx
        ret
_start: xor r14, r14
        mov rdi, [rsp + 0x10]
        mov rax, 2
        xor rsi, rsi
        xor rdx, rdx
        syscall
        mov r12, rax
        sub rsp, 0x200
        mov r13, rsp
        mov rcx, 0x200 / 8
        xor rax, rax
        mov rdi, rsp
        rep stosq
loop:   call next
        jmp [data + rax * 8]
id:     sub al, 44
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
.skip:  mov rcx, 1
.sloop: call next
        lea rdx, [rcx + 1]
        cmp al, '['
        cmove rcx, rdx
        je .sloop
        loop .sloop
        jmp loop
end:    pop rsi
        mov al, [r13]
        test al, al
        jz loop
        push rsi
        dec rsi
        mov r14, rsi
        mov rax, 8
        mov rdi, r12
        xor rdx, rdx
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
        xor rdi, rdi
        syscall
data:   dq exit, 42 dup(loop), id, in, id, out, 13 dup(loop), lr, loop, lr, 28 dup(loop), start, loop, end, 34 dup(loop)
