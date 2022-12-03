;1-down, 4-left, 6-right, 9-up
;R0 - SNACK COL
;R1 - SNACK ROW
;R2 - 먹이 COL
;R3 - 먹이 ROW
;초기 위치는 (4,4)로 설정한다. 방향 : 오른쪽(Def)

;LCD -> TIME 7-SEG -> 점수

    ORIGIN  8000

;==========
;DOT MATRIX 정의
COLGREEN    EQU 0FFC5H
COLRED      EQU 0FFC6H
ROW         EQU 0FFC7H
;==========
;==========
;데이터 입출력 저장
DATA_OUT       EQU 0FFE0H
DATA_IN        EQU 0FFF1H
;==========

;==========
; 기능키
RWKEY   EQU 10H ; READ AND WRITE KEY
COMMA   EQU 11H ; COMMA(,)
PERIOD  EQU 12H ; PERIOD(.)
GO      EQU 13H ; GO-KEY
REG     EQU 14H ; REGISTER KEY
CD      EQU 15H ; DECRESE KEY
INCR    EQU 16H ; INCRESE KEY
ST      EQU 17H ; SINGLE STEP KEY
RST     EQU 18H ; RST KEY
;========

;========
; 서브루틴 : INDEX
; 입력 : ACC
; 출력 : ACC
; 기능 : 키 코드의 값을 정의
;========

INDEX:  MOVC A, @A+PC ; 누산기는 1~24의 값을 가진다.
KEYBASE:    DB  ST      ;SW1,ST             1
            DB  INCR    ;SW6,INCREASE       2
            DB  CD      ;SW11,CD            3
            DB  REG     ;SW15, REG          4
            DB  GO      ;SW19, GO           5
            DB  0CH     ;SW2, C             6
            DB  0DH     ;SW7, D             7
            DB  0EH     ;SW12, E            8
            DB  0FH     ;SW16, F            9
            DB  COMMA   ;SW20, COMMA(,)     10
            DB  O8H     ;SW3, 8             11
            DB  09H     ;SW8, 9             12
            DB  0AH     ;SW13, A            13
            DB  0BH     ;SW17, B            14
            DB  PERIOD  ;SW21, PERIOD(.)    15
            DB  04H     ;SW4, 4             16
            DB  05H     ;SW9, 5             17
            DB  06H     ;SW14, 6            18
            DB  07H     ;SW18, 7            19
            DB  RWKEY   ;SW22, R/W          20
            DB  00H     ;SW5, 0 17          21   
            DB  01H     ;SW10, 1            22
            DB  02H     ;SW24, 2            23
            DB  03H     ;SW23, 3            24
            DB  RST     ;SW24, RST KEY      25

            END
