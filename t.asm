.MODEL SMALL
.STACK 100H

.DATA
    MAX_NUMBERS equ 10000
    MAX_LINE_LENGTH equ 255
    filename DB "textfile.txt", 0 ; Назва файлу для зчитування
    buffer DB MAX_LINE_LENGTH dup (?)
    numbers DW MAX_NUMBERS dup (?)

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    ; Відкриття файлу
    MOV AH, 3DH
    MOV AL, 0
    LEA DX, filename
    INT 21H
    JC EXIT_PROGRAM
    MOV BX, AX ; Збереження дескриптора файлу

READ_LOOP:
    ; Читання рядка з файлу
    MOV AH, 3FH
    MOV BX, AX
    LEA DX, buffer
    INT 21H
    JC EXIT_PROGRAM

    ; Розбиття рядка на числа та збереження їх у масиві
    CALL PARSE_NUMBERS

    JMP READ_LOOP

PARSE_NUMBERS:
    XOR SI, SI ; SI - індекс поточного числа в масиві
    XOR CX, CX ; CX - лічильник символів у рядку
    MOV DI, OFFSET buffer ; DI - вказівник на початок рядка

PARSE_LOOP:
    MOV AL, [DI] ; Завантаження символу з рядка
    CMP AL, 0 ; Перевірка кінця рядка
    JE END_PARSE
    CMP AL, '0'
    JB NEXT_CHAR
    CMP AL, '9'
    JA NEXT_CHAR
    SUB AL, '0' ; Конвертація символу у десяткове число
    MOV AH, 0
    MOV BX, numbers[SI] ; Завантаження поточного числа
    MOV DX, 10
    MUL DX ; BX * 10
    ADD BX, AX ; BX = BX * 10 + AL
    MOV numbers[SI], BX ; Збереження числа
    INC CX ; Інкремент лічильника символів
    INC SI ; Інкремент індексу масиву
    INC DI ; Перехід до наступного символу
    JMP PARSE_LOOP

NEXT_CHAR:
    CMP CX, 0 ; Перевірка чи було зчитано число
    JE SKIP_CHAR ; Якщо не було - пропустити символ

    ; Збереження числа у масиві
    INC SI ; Інкремент індексу масиву
    MOV CX, 0 ; Скидання лічильника символів
    JMP PARSE_LOOP

SKIP_CHAR:
    INC DI ; Пропустити символ
    JMP PARSE_LOOP

END_PARSE:
    CALL PRINT_NUMBERS
    RET

    PRINT_NUMBERS:
        MOV SI, 0 ; Почати з першого елемента масиву
    PRINT_LOOP_START:
        MOV BX, numbers[SI] ; Завантажити поточне число
        CALL PRINT_DECIMAL ; Вивести його на екран
        INC SI ; Інкремент індексу масиву
        CMP SI, MAX_NUMBERS ; Перевірка чи досягнуто кінця масиву
        JAE END_PRINT_LOOP
        MOV DL, ',' ; Вивести кому
        MOV AH, 2
        INT 21H
        JMP PRINT_LOOP_START
    END_PRINT_LOOP:
        MOV DL, 0DH ; Перехід на новий рядок
        MOV AH, 2
        INT 21H
        MOV DL, 0AH
        INT 21H
        RET

EXIT_PROGRAM:
    MOV AH, 4CH
    INT 21H

PRINT_DECIMAL:
    MOV AX, BX
    MOV CX, 10
    XOR DX, DX
DIV_LOOP:
    DIV CX
    PUSH DX
    CMP AX, 0
    JNZ DIV_LOOP
PRINT_LOOP:
    POP DX
    ADD DL, '0'
    MOV AH, 2
    INT 21H
    RET

MAIN ENDP

END MAIN