	ORG	8000H

DATAOUT		EQU	0FFF0H
DATAIN		EQU	0FFF1H	

TIMEVALUE	EQU	35H
SECOND		EQU	36H

;==========FUNCTION KEY
RWKEY	EQU	10H
COMMA	EQU	11H
PERIOD	EQU	12H
GO	EQU	13H
REG	EQU	14H
CD	EQU	15H
INCR	EQU	16H
ST	EQU	17H
RST	EQU	18H

;==========LCD VARIABLES
LCDWIR	EQU	0FFE0H
LCDWDR	EQU	0FFE1H
LCDRIR	EQU	0FFE2H
LCDRDR	EQU	0FFE3H

INST	EQU	20H
DATA	EQU	21H
LROW	EQU	22H; LCD ROW1,2
LCOL	EQU	23H; LCD COL0~
NUMFONT	EQU	24H; MESSAGE NUMBER
FDPL	EQU	25H
FDPH	EQU	26H

;=========LCD INSTRUCTIONS
CLEAR	EQU	01H
CUR_HOME	EQU	02H	;MOVE CURSOR HOME
ENTRY2	EQU	06H		;CURSOR DIRECION, ADDRESS+1,CURSOR RIGHT

DCB6	EQU	0EH		;CURSOR ON, BLINK OFF
FUN5	EQU	38H		

LINE_1	EQU	80H
LINE_2	EQU	0C0H

;============LCD SAVE
BPOR	EQU	2CH
BPOR2	EQU	2DH
BPOR3	EQU	2EH

;============KEY SAVE
VBUF	EQU	40H
CKST	EQU	41H
BPOV	EQU	42H

;============DELAY SAVE
DS1	EQU	4AH
DS2	EQU	4BH
DS3	EQU	4CH

;============DIRECT SAVE
DIRECT1	EQU	4DH

MOV	TMOD,#00000001B
MOV	IE,#10000010B
MOV	SECOND, #0000


LCD_INIT:	MOV	INST,#FUN5
		CALL	INSTWR
		MOV	INST,#DCB6
		CALL	INSTWR
		MOV	INST,#CLEAR
		CALL	INSTWR
		MOV	INST,#ENTRY2
		CALL	INSTWR
		MOV	TIMEVALUE, #14
		

MAIN:	JMP $

;======SUBROUTINE CUR_MOV
CUR_MOV:
	MOV	A,LROW
	CJNE	A,#01H,NEXT
	MOV	A,#LINE_1
	ADD	A,LCOL
	MOV	INST,A
	CALL	INSTWR
	JMP	RET_POINT
NEXT:	CJNE	A,#02H,RET_POINT
	MOV	A,#LINE_2
	ADD	A,LCOL
	MOV	INST,A
	CALL	INSTWR
RET_POINT:	RET

;=========SUBROUTINE DISFONT
DISFONT:	MOV	R5,#00H
FLOOP3:	MOV	A,R4
	ADD	A,R5
	CJNE	A,#20,FLOOP
	MOV	LCOL,#00H
	CALL	CUR_MOV
FLOOP2:	MOV	DPL,FDPL
	MOV	DPH,FDPH
	MOV	A,R5
	MOVC	A,@A+DPTR
	MOV	DATA,A
	CALL	DATAWR
	INC	R5
	MOV	A,R5
	CJNE	A,NUMFONT,FLOOP2
	RET
FLOOP:	MOV	DPL,FDPL
	MOV	DPH,FDPH
	MOV	A,R5
	MOVC	A,@A+DPTR
	MOV	DATA,A

	CALL	DATAWR
	INC	R5
	MOV	A,R5
	CJNE	A,NUMFONT,FLOOP3
	RET

;==========SUBROUTINE DATAWR
DATAWR:	CALL	INSTRD
	MOV	DPTR,#LCDWDR
	MOV	A,DATA
	MOVX	@DPTR,A
	RET
;=-========SUBROUTINE INSTWR
INSTWR:	CALL	INSTRD
	MOV	DPTR,#LCDWIR
	MOV	A,INST
	MOVX	@DPTR,A
	RET
;==========SUBROUTINE INSTRD
INSTRD:	MOV	DPTR,#LCDRIR
	MOVX	A,@DPTR
	JB	ACC.7,INSTRD
	RET

;==========
; SUBROUTINE : DISP_TIME
; INPUT : SECOND(PLAY TIME)
; OUTPUT : LCD DISPLAY
; FUNC : DISPLAY PLAYING TIME AT LCD DISPLAY
;==========

DISP_TIME:	MOV	LROW, #01H
		MOV	LCOL, #07H
		
		CALL	CUR_MOV
		MOV	DPTR, #NUM
		MOV	FDPL, DPL
		MOV	FDPH, DPH
		CALL	TIMEDISP


		; CLEAR DISPLAY
		
		
		RET


TIMEDISP:	
		PUSH	A
		MOV	A, SECOND
		MOV	B, #1000
		DIV	AB
		MOV	DPL, FDPL
		MOV	DPH, FDPH
		MOVC	A, @A+DPTR
		MOV	DATA, A
		CALL	DATAWR 

		MOV	A, B
		MOV	B, #100
		DIV	AB
		MOVC	A, @A+DPTR
		MOV	DATA, A
		CALL	DATAWR
		
		MOV	A, B
		MOV	B, #10
		DIV	AB
		MOVC	A, @A+DPTR
		MOV	DATA, A
		CALL	DATAWR

		MOV	A, B
		MOVC	A, @A+DPTR
		MOV	DATA, A
		CALL	DATAWR
		
		POP	A
		RET


NUM:	DB	'0','1','2','3','4'
	DB	'5','6','7','8','9'



;==========
; SUBROUTINE : SERVICE
; FUNC : TIMER
;==========
SERVICE:
	CLR	TCON.TR0
	PUSH	A
	DJNZ	TIMEVALUE,SERRET
	MOV	TIMEVALUE,#14
	INC	SECOND
	CALL	DISP_TIME

SERRET:	MOV	TH0,#00H
	MOV	TL0,#00H
	POP	A
	SETB	TCON.TR0
	RETI

ORG	000BH
JMP	SERVICE






