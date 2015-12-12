extern printf
extern atoi

section .data

fmt db "%d",10,0 ; format string "%d" + "\n" + string terminator

section .bss

section .text

global main

factorial:
    push    ebp
    mov     ebp, esp

    mov     eax, [ebp+8]
    mov     ebx, eax

factorial_loop:
    cmp     ebx, 1
    jle     factorial_return
    dec     ebx
    imul    eax, ebx
    jmp     factorial_loop

factorial_return:
    mov     esp, ebp
    pop     ebp
    ret

main:
    ; set up stack frame
    push    ebp
    mov     ebp, esp

    ; get argv[1]
    mov     eax, [ebp+12]
    mov     eax, [eax+4]

    ; convert to int
    push    eax
    call    atoi
    add     esp,4

    ; calculate the factorial
    push    eax
    call    factorial
    add     esp, 4

    ; print it out
    push    eax
    push    fmt ; or dword fmt
    call    printf
    add     esp, 8

    ; tear down stack frame
    mov     esp, ebp
    pop     ebp
    ret
