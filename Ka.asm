.MODEL SMALL
.STACK 100H

.DATA
    MSG1 DB 'Enter a string: $'
    MSG2 DB 0DH, 0AH, 'You entered: $'
    BUFFER DB 100 DUP ('$')

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    ; Вивід повідомлення для введення рядка
    LEA DX, MSG1
    MOV AH, 09H
    INT 21H

    ; Зчитування рядка з клавіатури
    MOV AH, 0AH
    LEA DX, BUFFER
    INT 21H

    ; Вивід повідомлення з введеним рядком
    LEA DX, MSG2
    MOV AH, 09H
    INT 21H

    ; Вивід введеного рядка
    LEA DX, BUFFER+2 ; Пропускаємо перші два байти, що містять довжину рядка
    MOV AH, 09H
    INT 21H

    MOV AH, 4CH
    INT 21H
MAIN ENDP

END MAIN