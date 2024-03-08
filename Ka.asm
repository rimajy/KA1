.model small
.stack 100h
.data
.code
main PROC  
mov ah, 02h
mov dl, 'a'
int 21h
mov ah, 02h
mov dl, 'b'
int 21h
mov ah, 02h
mov dl, 'o'
int 21h
mov ah, 02h
mov dl, 'b'
int 21h
mov ah, 02h
mov dl, 'a'
int 21h
main ENDP
END main