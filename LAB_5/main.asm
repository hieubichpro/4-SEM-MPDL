EXTRN READ_NUM: NEAR
EXTRN PRINT_BIN: NEAR
EXTRN PRINT_HEX: NEAR
EXTRN NEW_LINE: NEAR
EXTRN QUIT: NEAR

STKS SEGMENT PARA STACK 'STACK'
    db 100 dup ('0')
STKS ENDS

DATAS SEGMENT PARA PUBLIC 'DATA'
    MENU DB "1. Input unsigned decimal number", 10, 13
         DB "2. Convert to unsigned binary and print", 10, 13
         DB "3. Convert to signed hexadecimal and print", 10, 13
         DB "4. Exit", 10, 13
         DB "Choose task: $"

    ARR_PTR DW READ_NUM, PRINT_BIN, PRINT_HEX, QUIT
DATAS ENDS

CODES SEGMENT PARA PUBLIC 'CODE'
    ASSUME CS:CODES, DS:DATAS, SS:STKS
MAIN:
    MOV AX, DATAS
    MOV DS, AX

MY_MENU:
    MOV AH, 9
    MOV DX, OFFSET MENU
    INT 21H

    MOV AH, 1
    INT 21H

    MOV AH, 0
    SUB AL, "1"
    SHL AX, 1
    MOV BX, AX

    CALL NEW_LINE
    CALL ARR_PTR[BX]
    CALL NEW_LINE
JMP MY_MENU
CODES ENDS
END MAIN