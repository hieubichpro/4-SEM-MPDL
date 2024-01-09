EXTRN output: near
PUBLIC char, K, Result

SSTACK SEGMENT PARA STACK 'stack'
	DB 100 DUP(0)
SSTACK ENDS

SDATA SEGMENT PARA 'data'
	InviteMsg1 db "Enter a character: $"
	InviteMsg2 db 0DH,0AH,"Enter a digit K: $"
    Result db 0DH,0AH,"Result: $"
	char db '0'
	K db '0'
SDATA ENDS

SCODE SEGMENT PARA PUBLIC 'code'
	ASSUME DS:SDATA, CS:SCODE, SS:SSTACK

main:
	mov	AX, SDATA
	mov	DS, AX
	
	mov AH, 09h
	mov DX, OFFSET InviteMsg1
	int 21h
	
	mov AH, 01h
	int 21h
	mov char, AL

	mov AH, 09
	mov DX, OFFSET InviteMsg2
	int 21h

	mov AH, 01h
	int 21h
	mov K, AL

	jmp output
SCODE ENDS

END main