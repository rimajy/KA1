.model small
.stack 100h

.data
    input_buffer    db  255 dup(?)
    numbers         dw  10000 dup(?)
    count           dw  ?
    delimiter       db  0Dh, 0Ah, '$'
    ctrl_c_flag     db  ?
    array           dw 3, 2, 6, 4, 1
    array_count     dw 5

.code
main proc
    mov ax, @data
    mov ds, ax

    mov cx, 0
    mov [ctrl_c_flag], 0   ; initialize Ctrl+C flag

    ; Initialize array and count
    mov cx, word ptr array_count
    mov [count], cx

    ; Copy array into numbers
    mov si, offset numbers
    mov di, offset array
    mov cx, word ptr array_count
    rep movsw
 ; Bubble sort algorithm
 mov cx, word ptr [count]   ; Load count into cx
 dec cx                      ; cx = count - 1
outerLoop:
 push cx
 mov si, offset array       ; Set si to point to the beginning of the array
innerLoop:
 mov ax, [si]              ; Load the value at si
 cmp ax, [si+2]            ; Compare with the next value
 jl nextStep               ; If ax < [si+2], jump to nextStep
 xchg [si+2], ax           ; Swap values
 mov [si], ax
nextStep:
 add si, 2                 ; Move to the next element
 loop innerLoop            ; Repeat inner loop
 pop cx
 loop outerLoop            ; Repeat outer loop

 ; Print sorted numbers
 mov cx, word ptr [count]   ; Load count into cx
 mov bx, 0                  ; Set index bx to 0
 mov [ctrl_c_flag], 1       ; Set Ctrl+C flag to proceed to printing the array
 jmp output_loop

output_loop:
 cmp [ctrl_c_flag], 1       ; Check Ctrl+C flag
 je exit_program            ; If set, exit program

 mov ax, [numbers + bx]     ; Load number into ax
 call print_number          ; Print the number
 inc bx                      ; Increment index bx
 cmp bx, word ptr [count]   ; Compare bx to the count of elements
 jl output_loop             ; Jump to output_loop if bx is less than count

exit_program:
 mov ah, 4Ch
 int 21h

 print_number proc
 push ax bx cx dx si
 mov bx, 10
 xor cx, cx
 xor dx, dx
divide_loop:
 xor dx, dx
 div bx
 push dx
 inc cx
 test ax, ax
 jnz divide_loop
 
 print_loop:
     pop dx
     add dl, '0'
     mov ah, 02h
     int 21h
     dec cx       ; зменшуємо лічильник
     jz print_done ; якщо лічильник дорівнює 0, виходимо з циклу
     loop print_loop
print_done:
     pop si dx cx bx ax
     ret
print_number endp

main endp
end main

