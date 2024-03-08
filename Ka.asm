.model small
.stack 100h
.data
.code
main PROC  
mov ah, 02h
mov dl, '0'
int 21h
main ENDP
END main