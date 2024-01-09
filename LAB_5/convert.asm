PUBLIC TO_REAL_NUM
PUBLIC TO_BIN
PUBLIC TO_HEX
EXTRN LEN: BYTE
EXTRN NUM: BYTE
EXTRN NEG_FLAG: BYTE
EXTRN REAL_NUM: WORD
EXTRN BIN_STR: BYTE
EXTRN HEX_STR: BYTE
CODES SEGMENT PARA PUBLIC 'CODE'
    ASSUME CS:CODES
TO_REAL_NUM:
    XOR CX, CX
    MOV CL, LEN
    
    DEC CX
    MOV SI, CX
    INC CX

    MOV BX, 1

    REAL_LABEL:
        XOR AX, AX
        MOV AL, NUM[SI]
        SUB AX, "0"
        MUL BX
        ADD REAL_NUM, AX

        MOV AX, BX
        MOV BX, 10
        MUL BX
        MOV BX, AX

        DEC SI

        LOOP REAL_LABEL
    RET

TO_BIN:
    MOV AX, REAL_NUM
    MOV SI, 15
    XOR DX, DX
    MOV BX, 2

    BIN_LABEL:
        DIV BX
        MOV BIN_STR[SI], DL
        ADD BIN_STR[SI], "0"
        XOR DX, DX
        DEC SI

        CMP AX, 0
        JNE BIN_LABEL
    RET

TO_HEX_CHAR:
    ADD HEX_STR[SI], 55
    JMP BACK

TO_HEX:
    MOV NEG_FLAG, 0
    XOR CX, CX
    XOR DX, DX
    MOV BX, 16
    MOV SI, 4
    MOV AX, REAL_NUM
    CMP AX, 32767
    JA TO_NEG
    CMP NEG_FLAG, 0
    JE TO_POS

    HEX_LABEL:
        DIV BX
        MOV HEX_STR[SI], DL

        CMP DL, 9
        JG TO_HEX_CHAR
        ADD HEX_STR[SI], "0"

        BACK:
        XOR DX, DX
        
        DEC SI
        CMP AX, 0
        JNE HEX_LABEL
    RET
TO_POS:
    MOV HEX_STR[0], "+"
    JMP HEX_LABEL
TO_NEG:
    MOV NEG_FLAG, 1
    MOV CX, 65536
    SUB CX, AX
    MOV AX, CX
    MOV HEX_STR[0], "-"
    JMP HEX_LABEL

CODES ENDS
END
    
