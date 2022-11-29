    ORIGIN  8000

COLGREEN    EQU 0FFC5H
COLRED      EQU 0FFC6H
ROW         EQU 0FFC7H

;1-down, 4-left, 6-right, 9-up
;R0 - SNACK COL
;R1 - SNACK ROW
;R2 - 먹이 COL
;R3 - 먹이 ROW
;초기 위치는 (4,4)로 설정한다. 방향 : 오른쪽(Def)

;LCD -> TIME 7-SEG -> 점수


;========
; 서브루틴 : INDEX
; 입력 : ACC
; 출력 : ACC
; 기능 : 키 코드의 값을 정의
;========

;DEFINE FUNCTION KEY
RWKEY   EQU 10H ; READ AND WRITE KEY
COMMA   EQU 11H ; COMMA(,)
PERIOD  EQU 12H ; PERIOD(.)
GO      EQU 13H ; GO-KEY
REG     EQU 14H ; REGISTER KEY
CD      EQU 15H ; DECRESE KEY
INCR    EQU 16H ; INCRESE KEY
ST      EQU 17H ; SINGLE STEP KEY
RST     EQU 18H ; RST KEY

INDEX:  MOVC A, @A+PC ; 누산기는 1~24의 값을 가진다.
KEYBASE:    DB  ST      ;SW1,ST 1
            DB  INCR    ;SW6,INCREASE   2
            DB  CD      ;SW11,CD    3
            DB  REG     ;SW15, REG 4
            DB  GO      ;SW19, GO   5
            DB  0CH     ;SW2, C     6
            DB  0DH     ;SW7, D     7
            DB  0EH
            DB  0FH
            DB  COMMA
            DB  O8H
            DB  09H
            DB  0AH
            DB  0BH
            DB  PERIOD
            DB  04H
            DB  05H
            DB  06H
            DB  07H
            DB  RWKEY
            DB  00H
            DB  01H
            DB  02H
            DB  03H
            DB  RST

            END
