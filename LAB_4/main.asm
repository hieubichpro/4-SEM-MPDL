EXTRN READ_SIZE:NEAR
EXTRN READ_MAT:NEAR
EXTRN PRINT_MAT:NEAR
EXTRN CHANGE_MAT:NEAR
PUBLIC N
PUBLIC M
PUBLIC MAT

STKS SEGMENT PARA STACK 'STACK'
    DB 200 DUP (0)
STKS ENDS

DATAS SEGMENT PARA PUBLIC 'DATA'
    N DB 1
    M DB 1
    MAT DB 81 DUP ('0'), '$'
DATAS ENDS

CODES SEGMENT PARA PUBLIC 'CODE'
    ASSUME DS:DATAS, CS:CODES
MAIN:
    MOV AX, DATAS
    MOV DS, AX
    CALL READ_SIZE
    CALL READ_MAT
    CALL CHANGE_MAT
    CALL PRINT_MAT
    ; MOV AH, 09
    ; MOV DX, OFFSET MAT
    ; INT 21H
    MOV AX, 4C00H
    INT 21H
CODES ENDS
END MAIN