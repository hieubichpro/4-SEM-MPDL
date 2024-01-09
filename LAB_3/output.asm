EXTRN char: byte, K: byte, Result: byte
PUBLIC output

SCODE SEGMENT para PUBLIC 'code'
	ASSUME CS:SCODE
output:
	mov AH, 09
	mov DX, OFFSET Result
	int 21h

	mov AL, char
	add AL, K
	sub AL, 30h

	mov AH, 02h
	mov DL, AL
	int 21h
	
	mov AH, 4Ch
	int 21h
SCODE ENDS

END