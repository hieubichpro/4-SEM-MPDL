PUBLIC READ_SIZE
PUBLIC READ_MAT
PUBLIC PRINT_MAT
PUBLIC CHANGE_MAT
EXTRN N:BYTE
EXTRN M:BYTE
EXTRN MAT:BYTE

CODES SEGMENT PARA PUBLIC 'CODE'
    ASSUME CS:CODES

PRINT_SPACE:
    MOV AH, 2
    MOV DL, " "
    INT 21H
    RET

NEW_LINE:
    MOV AH, 2
    MOV DL, 10
    INT 21H
    MOV DL, 13
    INT 21H
    RET

CHANGE:
    ADD MAT[SI], 32
    JMP GO_BACK


READ_SIZE:
    MOV AH, 1
    INT 21H
    MOV N, AL
    SUB N, '0'
    
    CALL PRINT_SPACE
    
    MOV AH, 1
    INT 21H
    MOV M, AL
    SUB M, '0'
    
    CALL NEW_LINE
    RET

READ_MAT:
    MOV CX, 0
    MOV BL, 0
    MOV BH, N
    READ:
        MOV AH, 0
        MOV AL, 9
        MUL BL
        MOV SI, AX
        CALL NEW_LINE
        MOV CL, M
        READ_ROW:
            MOV AH, 1
            INT 21H
            MOV MAT[SI], AL
            INC SI
            CALL PRINT_SPACE
            LOOP READ_ROW
        MOV CL, BH
        DEC BH
        INC BL
        LOOP READ
    RET

PRINT_MAT:
    CALL NEW_LINE
    MOV CX, 0
    MOV BL, 0
    MOV BH, N
    PRINT:
        MOV AH, 0
        MOV AL, 9
        MUL BL
        MOV SI, AX
        CALL NEW_LINE
        MOV CL, M
        PRINT_ROW:
            MOV AH, 2
            MOV DL, MAT[SI]
            INT 21H
            INC SI
            CALL PRINT_SPACE
            LOOP PRINT_ROW
        MOV CL, BH
        DEC BH
        INC BL
        LOOP PRINT
    RET

CHANGE_MAT:
    MOV CX, 0
    MOV BL, 0
    MOV BH, N
    ITERATE_ROW:
        MOV AH, 0
        MOV AL, 9
        MUL BL
        MOV SI, AX
        MOV CL, M
        ITERATE_COL:
            MOV DH, MAT[SI]
            CMP DH, 'U'
            JE CHANGE

            CMP DH, 'E'
            JE CHANGE

            CMP DH, 'O'
            JE CHANGE

            CMP DH, 'A'
            JE CHANGE

            CMP DH, 'I'
            JE CHANGE
            GO_BACK:
            INC SI
            LOOP ITERATE_COL
        MOV CL, BH
        DEC BH
        INC BL
        LOOP ITERATE_ROW
    RET
CODES ENDS
END
; for i in range(10):
;   for j in range(10):