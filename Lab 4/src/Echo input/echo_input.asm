; ----------------------------------------------------------------------------------------
; To assemble and run:
;
; nasm -f elf64 -o echo_input.o echo_input.asm&&ld -o echo_input echo_input.o&&./echo_input
; ----------------------------------------------------------------------------------------


global _start

section .data

; File descriptors for stdin and stdout
STDIN equ 0
STDOUT equ 1

; System call numbers for sys_read and sys_write
SYS_READ equ 0
SYS_WRITE equ 1

; System call number for sys_exit
SYS_EXIT equ 60

; Buffer size for reading input
BUFFER_SIZE equ 256

section .bss

; Buffer for storing input
buffer: resb BUFFER_SIZE

section .text

_start:

; Read input from the user
mov rax, SYS_READ      ; sys_read
mov rdi, STDIN         ; file descriptor for stdin
mov rsi, buffer        ; address of the buffer
mov rdx, BUFFER_SIZE   ; buffer size
syscall

; Store the number of bytes read in rcx
mov rcx, rax

; Write the input to the screen
mov rax, SYS_WRITE     ; sys_write
mov rdi, STDOUT        ; file descriptor for stdout
mov rsi, buffer        ; address of the buffer
mov rdx, rcx           ; number of bytes to write
syscall

; Exit the program
mov rax, SYS_EXIT      ; sys_exit
mov rdi, 0             ; exit status 0 (success)
syscall