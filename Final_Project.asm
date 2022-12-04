; 1-down, 4-left, 6-right, 9-up
; R0 - SNACK COL
; R1 - SNACK ROW
; R2 - FEED COL
; R3 - FEED ROW
; SET INITIAL POINT TO (1,4). INTIAL DIRECTION TO GO : RIGHT

; LCD -> TIME 7-SEG -> INTEGER

	ORIGIN	8000
;==========
; DOT MATRIX
COLGREEN	EQU	0FFC5H
COLRED		EQU	0FFC6H
ROW		EQU	0FFC7H
;==========

;==========
; DATA INPUT/OUTPUT INTERFACE
DATAOUT		EQU	0FFE0H
DATAIN		EQU	0FFE1H
;==========


;==========
; FUNCTION KEY
RWKEY	EQU	10H	; READ AND WRITE KEY
COMMA	EQU	11H	; COMMA(,)
PERIOD	EQU	12H	; PERIOD(.)
GO	EQU	13H	; GO-KEY
REG	EQU	14H	; REGISTER KEY
CD	EQU	15H	; DECREASE KEY
INCR	EQU	16H	; INCREASE KEY
ST	EQU	17H	; SINGLE STEP KEY
RST	EQU	18H	; RST KEY
;==========



;==========
; SUBROTINE : FINDKEYCODE
; INPUT : A
; OUTPUT : A
; FUNC : FIND CORRECT KEY CODE
;==========
FINDKEYCODE:	PUSH	PSW ; STORE PSW VALUE AT STACK
		SETB	PSW.4	; USING BANK-3 REG
		SETB	PSW.3

INITIAL:	MOV	R4, #00H ; INTIALIZING R4 == USING R4 TO KEY VALUE
		MOV	A, #11101111B; INITIAL VALUE OF DATAOUT
		SETB	C

COLSCAN:	MOV	R5, A	; STORE DATA_OUT AT R5
		INC	R4	; SAVING R4'S ROW VALUE
		CALL 	SUBKEY	; SEARCHING KEY PAD INPUT
		
		CJNE	A,#0FFH,RSCAN ; IF A DOES NOT EQUL AS #0FFH -> KEY INPUT OCCURS
		
		MOV	A, R5
		SETB	C
		RRC	A	; MOVE NEXT COLUMN
		JNC	INITIAL ; IF SCANNING ALL COLUMNS -> RESTART
		JMP	COLSCAN	; BRANCH FOR SCANNING NEXT COLUMN

RSCAN:		MOV	R6, #00H ; STORE R2'S ROW VALUE
ROWSCAN:	RRC	A	; SERACHING WHICH ROW CHANGES 0->1
		JNC	MATRIX	; IF CARRY OCCURS -> BRANCH TO MATRIX
		INC	R6	; IF CARRY DOESN'T OCCURS -> MOVE NEXT ROW
		JMP	ROWSCAN	; BRANCH FOR SCANNING NEXT ROW

MATRIX:		MOV	A, R6	; PRESERVE ROW VALUE AT R6
		MOV	B, #05H	; 1ROW CONSISTS 5 COLUMNS
		MUL	AB	; CHANGE 2D-MAT TO 1D-MAT
		ADD	A, R4	; PRESERVE COLUMN VALUE AT R4
		CALL	INDEX	; SELECT KEY CODE
		POP	PSW	; BRING PSW TO STACK\
		RET		; RETURN TO ORIGINAL ROUTINE


;==========
; SUBROUTINE : SUBKEY
; INPUT : ACC
; OUTPUT : ACC
; FUNC : PULL DATA TO DATAOUT AND CHECK RESULT BY USING DATAIN
;==========
SUBKEY:		MOV	DPTR,#DATAOUT
		MOVX	@DPTR, A
		MOV	DPTR,#DATAIN
		MOVX	A,@DPTR
		RET


;===========
; SUBROUTINE : INDEX
; INPUT : ACC
; OUTPUT : ACC
; FUNC : DEFINE KEY CODE
;==========

INDEX	MOVC A, @A+PC	; A CAN GET 1~24 NUM.
	RET

KEYBASE:	DB	ST	; SW1, ST	1
		DB	INCR	; SW6, INCREASE	2
		DB	CD	; SW11, CD	3
		DB	REG	; SW15, REG	4
		DB	GO	; SW19, GO	5
		DB	0CH	; SW2, C	6
		DB	0DH	; SW7, D	7
		DB	0EH	; SW12, E	8
		DB	0FH	; SW16, F	9
		DB	COMMA	; SW20, COMMA(,)10
		DB	08H	; SW3, 8	11
		DB	09H	; SW8, 9	12
		DB	0AH	; SW13, A	13
		DB	0BH	; SW14, B	14
		DB	PERIOD	; SW21, PERIOD(.)15
		DB	04H	; SW4, 4	16
		DB	05H	; SW9, 5	17
		DB	06H	; SW14, 6	18
		DB	07H	; SW18, 7	19
		DB	RWKEY	; SW22, R/W	20
		DB	00H	; SW5, 0	21
		DB	01H	; SW10, 1	22
		DB	02H	; SW22, 2	23
		DB	03H	; SW23, 3	24
		DB	RST	; SW24, RST KEY	25

IF4:		CJNE	A,#04H, IF1	; IF INPUT DOESN'T EQUAL AS 4 -> JUMP TO IF1
		MOV	MYKEY, A	
		CALL	HEADER
		RET

IF1:		CJNE	A,#01H, IF6	; IF INPUT DOESN'T EQUAL AS 1 -> JUMP TO IF6
		MOV	MYKEY, A
		CALL	HEADER
		RET

IF6:		CJNE	A,#06H, IF9	; IF INPUT DOESN'T EQUAL AS 6 -> JUMP TO IF9
		MOV	MYKEY, A
		CALL	HEADER
		RET

IF9:		CJNE	A,#09H, NOTFOUND ; IF INPUT DOESN'T EQUAL AS 9 -> JUMP TO NOTFOUND
		MOV 	MYKEY, A
		CALL	HEADER
		RET

NOTFOUND:	RET

HEADER:		A, MYKEY

L_MOVE:		CJNE	A,#04H,R_MOVE

END