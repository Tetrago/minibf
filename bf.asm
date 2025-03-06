        global  _start
next:   inc qword [data + 0x10]
        xor rax, rax
        mov rdi, [data]
        lea rsi, [rsp - 1]
        mov rdx, 1
        syscall
        mov dl, [rsp - 1]
        test rax, rax
        cmovnz rax, rdx
        ret
_start: mov rdi, [rsp + 0x10]
        mov rax, 2
        xor rsi, rsi
        xor rdx, rdx
        syscall
        mov [data], rax
        sub rsp, 0x200
        mov [data + 8], rsp
        mov rcx, 0x200 / 8
        xor rax, rax
        mov rdi, rsp
        rep stosq
loop:   call next
        jmp [data + rax * 8 + 0x18]
id:     mov rdx, [data + 8]
        sub rax, 44
        sub [rdx], al
        jmp loop
lr:     sub rax, 61
        add [data + 8], al
        jmp loop
start:  mov rax, [data + 8]
        mov al, [rax]
        test al, al
        jz .skip
        mov rax, [data + 0x10]
        push rax
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
        mov rax, [data + 8]
        mov al, [rax]
        test al, al
        jz loop
        push rsi
        dec rsi
        mov [data + 0x10], rsi
        mov rax, 8
        mov rdi, [data]
        xor rdx, rdx
        syscall
        jmp loop
out:    mov rsi, [data + 8]
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
        mov rdi, [data + 8]
        movsb
        jmp loop
exit:   mov rax, 60
        xor rdi, rdi
        syscall
        section .data
        data dq 3 dup(0), exit, 42 dup(loop), id, in, id, out, 13 dup(loop), lr, loop, lr, 28 dup(loop), start, loop, end, 34 dup(loop)
