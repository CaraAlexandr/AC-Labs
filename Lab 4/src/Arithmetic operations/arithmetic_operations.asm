SYS_EXIT  equ 1
SYS_READ  equ 3
SYS_WRITE equ 4
STDIN     equ 0
STDOUT    equ 1

segment .data

    msg db "Please enter a digit ", 0xA,0xD
    len equ $- msg
    newline db 0xA

segment .bss

    number1 resb 2
    number2 resb 2
    result resb 1
    result2 resb 1

segment .text

    msg2 db "Please enter a second digit", 0xA,0xD
    len2 equ $- msg2

    msg3 db "The sum is: "
    len3 equ $- msg3

    msg4 db "The minus is: "
    len4 equ $- msg4

global _start

_start:

    mov eax, SYS_WRITE   ; System write
    mov ebx, STDOUT      ; System output
    mov ecx, msg         ; What to write
    mov edx, len     ; Length to write
    int 0x80             ; Interupt Kernel

    mov eax, SYS_READ    ; System read
    mov ebx, STDIN       ;
    mov ecx, number1
    mov edx, 2
    int 0x80

    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, msg2
    mov edx, len2
    int 0x80

    mov eax, SYS_READ
    mov ebx, STDIN
    mov ecx, number2
    mov edx, 2
    int 0x80

    call add
    call minus

    ; Exit the program
    mov eax, SYS_EXIT
    xor ebx, ebx
    int 0x80

add:
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, msg3
    mov edx, len3
    int 0x80

    mov eax, [number1]
    sub eax, '0'
    mov ebx, [number2]
    sub ebx, '0'

    add eax, ebx

    ; Check if the sum is greater than 9
    cmp eax, 10
    jl short single_digit_sum

    ; If the sum is greater than 9, handle two-digit numbers
    xor edx, edx
    mov ebx, 10
    div ebx

    add eax, '0'
    mov [result], al
    add edx, '0'
    mov [result+1], dl
    inc edi

    ; Adjust the length to write 2 characters
    mov edx, 2
    jmp short print_sum_result

single_digit_sum:
    add eax, '0'
    mov [result], al

    ; Adjust the length to write 1 character
    mov edx, 1

print_sum_result:

    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, result
    mov [result+edx], byte 0xA  ; Add newline character after the sum result
    add edx, 1                  ; Increment length to include newline character
    int 0x80


minus:

    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, msg4
    mov edx, len4
    int 0x80

    ; Load number1 into eax and subtract '0' to convert from ASCII to decimal
    mov eax, [number1]
    sub eax, '0'
    ; Do the same for number2
    mov ebx, [number2]
    sub ebx, '0'

    ; Subtract ebx from eax, storing the result in eax
    sub eax, ebx
    ; Add '0' to eax to convert the digit from decimal to ASCII
    add eax, '0'

    ; Store the result in result2
    mov [result2], eax

    ; Print the result digit
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, result2
    mov edx, 1
    int 0x80

    ; Print the newline character
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, newline
    mov edx, 1
    int 0x80

    ret


exit:
    mov eax, SYS_EXIT
    xor ebx, ebx
    int 0x80
