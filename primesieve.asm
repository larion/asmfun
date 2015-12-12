extern printf
extern atoi

section .data
fmt db "%d",10,0

section .bss
    numbers      resb 500000000

section .text

global main

main:
    ; set up stack frame
    push    ebp
    mov     ebp, esp
    sub     esp, 12

    ; get argv[1]
    mov     eax, [ebp+12]
    mov     eax, [eax+4]

    ; convert to int and store
    push    eax
    call    atoi
    add     esp, 4
    mov     [ebp-12], eax

    ; 1 is not a prime so set numbers[0] to 1
    mov byte [numbers], 1

    ; store current index in ebp-4
    mov     dword [ebp-4], 0
sieve:
    mov     eax, [ebp-4]
    cmp     byte [numbers+eax], 1
    ; next if it's not a prime
    je      .next

    inc     eax
    mov     [ebp-8], eax ; set increment for the inner loop
    mov     eax, [ebp-4]
.innerloop:
    add     eax, [ebp-8]
    mov     ebx, [ebp-12]
    dec     ebx
    cmp     eax, ebx
    jg      .next
    mov     byte [numbers+eax], 1
    jmp     .innerloop

.next:
    ; i++
    inc     dword [ebp-4]
    ; check if i*i < sqrt(max)
    mov     eax, [ebp-4]
    inc     eax
    imul    eax, eax
    cmp     eax, [ebp-12]
    jl      sieve

    ; count from 0 to max-1
    mov     ecx, [ebp-12]
    mov     dword [ebp-4], 0

    mov eax, 0
print_loop:
    mov     eax, [ebp-4]
    cmp     byte [numbers+eax], 1
    ; next if it's not a prime
    je      print_loop_next

    push    ecx

    ; call printf
    inc     eax
    push    eax
    push    fmt
    call    printf
    add     esp, 8

    pop     ecx
print_loop_next:
    inc     dword [ebp-4]
    loop    print_loop

    mov eax, 0
    ; tear down stack frame and return
    mov     esp, ebp
    pop     ebp
    ret
