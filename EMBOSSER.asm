
; Braille Embosser

JMP MAIN

;data
MEMORY_START_ADD: EQU 0000H
RAM_START_ADD: EQU 8000H
MEMORY_END_ADD: EQU 80FFH

CWR: EQU 80H
PORTA: EQU 81H ; OUTPUT PORT
PORTB: EQU 82H ; INPUT PORT
PORTC: EQU 83H ; PIN EMBOSSING PORT

COUNT: EQU 0342H
RESPONSE_TIME_COUNT: EQU

PORT_LCD: EQU 00H

; LCD COMMAND CODES
LCD_COMMAND: EQU 00H
LCD_DATA: EQU 40H
LCD_CLEAR: EQU 01H
CURSOR_HOME: EQU 02H
ICWS: EQU 06H
DSPCURBLK: EQU 0EH
CURLEFT: EQU 14H
BIT8LINE2: EQU 38H

; MAP KBINPUT TO BRAILLE OUTPUT
CASEA: MVI A, 20H
RET
CASEB: MVI A, 28H
RET
CASEC: MVI A, 30H
RET
CASED: MVI A, 34H
RET
CASEE: MVI A, 24H
RET
CASEF: MVI A, 38H
RET
CASEG: MVI A, 3CH
RET
CASEH: MVI A, 2CH
RET
CASEI: MVI A, 18H
RET
CASEJ: MVI A, 1CH
RET
CASEK: MVI A, 22H
RET
CASEL: MVI A, 2AH
RET
CASEM: MVI A, 32H
RET
CASEN: MVI A, 36H
RET
CASEO: MVI A, 26H
RET
CASEP: MVI A, 3AH
RET
CASEQ: MVI A, 3EH
RET
CASER: MVI A, 2EH
RET
CASES: MVI A, 1AH
RET
CASET: MVI A, 1EH
RET
CASEU: MVI A, 23H
RET
CASEV: MVI A, 2BH
RET
CASEW: MVI A, 1DH
RET
CASEX: MVI A, 33H
RET
CASEY: MVI A, 37H
RET
CASEZ: MVI A, 27H
RET
CASE0: MVI A, 07H
RET
CASE1: MVI A, 08H
RET
CASE2: MVI A, 0AH
RET
CASE3: MVI A, 0CH
RET
CASE4: MVI A, 0DH
RET
CASE5: MVI A, 09H
RET
CASE6: MVI A, 0EH
RET
CASE7: MVI A, 0FH
RET
CASE8: MVI A, 0BH
RET
CASE9: MVI A, 06H
RET
CASESPACE: MVI A, 00H
RET
CASEPERIOD: MVI A, 11H
RET
CASECOMMA: MVI A, 01H
RET

; MAP KBINPUT TO ASCII VALUE
CASEA_ASCII: MVI A, 41H
RET
CASEB_ASCII: MVI A, 42H
RET
CASEC_ASCII: MVI A, 43H
RET
CASED_ASCII: MVI A, 44H
RET
CASEE_ASCII: MVI A, 45H
RET
CASEF_ASCII: MVI A, 46H
RET
CASEG_ASCII: MVI A, 47H
RET
CASEH_ASCII: MVI A, 48H
RET
CASEI_ASCII: MVI A, 49H
RET
CASEJ_ASCII: MVI A, 4AH
RET
CASEK_ASCII: MVI A, 4BH
RET
CASEL_ASCII: MVI A, 4CH
RET
CASEM_ASCII: MVI A, 4DH
RET
CASEN_ASCII: MVI A, 4EH
RET
CASEO_ASCII: MVI A, 4FH
RET
CASEP_ASCII: MVI A, 50H
RET
CASEQ_ASCII: MVI A, 51H
RET
CASER_ASCII: MVI A, 52H
RET
CASES_ASCII: MVI A, 53H
RET
CASET_ASCII: MVI A, 54H
RET
CASEU_ASCII: MVI A, 55H
RET
CASEV_ASCII: MVI A, 56H
RET
CASEW_ASCII: MVI A, 57H
RET
CASEX_ASCII: MVI A, 58H
RET
CASEY_ASCII: MVI A, 59H
RET
CASEZ_ASCII: MVI A, 5AH
RET
CASE0_ASCII: MVI A, 30H
RET
CASE1_ASCII: MVI A, 31H
RET
CASE2_ASCII: MVI A, 32H
RET
CASE3_ASCII: MVI A, 33H
RET
CASE4_ASCII: MVI A, 34H
RET
CASE5_ASCII: MVI A, 35H
RET
CASE6_ASCII: MVI A, 36H
RET
CASE7_ASCII: MVI A, 37H
RET
CASE8_ASCII: MVI A, 38H
RET
CASE9_ASCII: MVI A, 39H
RET
CASESPACE_ASCII: MVI A, 20H
RET
CASEPERIOD_ASCII: MVI A, 2EH
RET
CASECOMMA_ASCII: MVI A, 2CH
RET

;code
MAIN: XRA A
LXI B, 00FFH
LXI H, RAM_START_ADD
LXI SP, MEMORY_END_ADD
CALL INIT_LCD

WHILE_LOOP_CONDITION: CPI 28H ; COMPARE CONTENT OF A WITH KEYCODE OF ENTER
JNZ WHILE_LOOP
MOV A, C
CPI 0FFH
JNZ WHILE_LOOP
JMP MAIN

WHILE_LOOP: CALL KYBORD
CPI 27H ; KEYCODE OF BACKSPACE
JNZ ELSE_IF
MOV A, C
CPI 0FFH
JZ WHILE_LOOP_CONDITION
DCR C
CALL REMOVE_LCD
JMP WHILE_LOOP_CONDITION

ELSE_IF: CPI 28H
JNZ ELSE
MOV A, C
CPI 0FFH
JZ MAIN
CALL EMBOSS
JMP WHILE_LOOP_CONDITION

ELSE: INX B
LXI H, RAM_START_ADD
DAD B
MOV M, A
CALL DISPLAY_LCD
JMP WHILE_LOOP_CONDITION

EMBOSS: PUSH PSW
PUSH D
PUSH H
MVI D, 00H
LOOP: LXI H, RAM_START_ADD
DAD D
MOV A, M
CALL HEX_TO_BRAILLE
OUT PORTC
CALL RESPONSE_TIME_DELAY
DCR C
INR D
MOV A, C
CPI 0FFH
JNZ LOOP
POP H
POP D
POP PSW
RET

HEX_TO_BRAILLE: CPI 00H
CZ CASEA
RZ
CPI 01H
CZ CASEB
RZ
CPI 02H
CZ CASEC
RZ
CPI 03H
CZ CASED
RZ
CPI 04H
CZ CASEE
RZ
CPI 05H
CZ CASEF
RZ
CPI 06H
CZ CASEG
RZ
CPI 07H
CZ CASEH
RZ
CPI 08H
CZ CASEI
RZ
CPI 09H
CZ CASEJ
RZ
CPI 0AH
CZ CASEK
RZ
CPI 0BH
CZ CASEL
RZ
CPI 0CH
CZ CASEM
RZ
CPI 0DH
CZ CASEN
RZ
CPI 0EH
CZ CASEO
RZ
CPI 0FH
CZ CASEP
RZ
CPI 10H
CZ CASEQ
RZ
CPI 11H
CZ CASER
RZ
CPI 12H
CZ CASES
RZ
CPI 13H
CZ CASET
RZ
CPI 14H
CZ CASEU
RZ
CPI 15H
CZ CASEV
RZ
CPI 16H
CZ CASEW
RZ
CPI 17H
CZ CASEX
RZ
CPI 18H
CZ CASEY
RZ
CPI 19H
CZ CASEZ
RZ
CPI 1AH
CZ CASE0
RZ
CPI 1BH
CZ CASE1
RZ
CPI 1CH
CZ CASE2
RZ
CPI 1DH
CZ CASE3
RZ
CPI 1EH
CZ CASE4
RZ
CPI 1FH
CZ CASE5
RZ
CPI 20H
CZ CASE6
RZ
CPI 21H
CZ CASE7
RZ
CPI 22H
CZ CASE8
RZ
CPI 23H
CZ CASE9
RZ
CPI 24H
CZ CASECOMMA
RZ
CPI 25H
CZ CASEPERIOD
RZ
CPI 26H
CZ CASESPACE
RZ

HEX_TO_ASCII: CPI 00H
CZ CASEA_ASCII
RZ
CPI 01H
CZ CASEB_ASCII
RZ
CPI 02H
CZ CASEC_ASCII
RZ
CPI 03H
CZ CASED_ASCII
RZ
CPI 04H
CZ CASEE_ASCII
RZ
CPI 05H
CZ CASEF_ASCII
RZ
CPI 06H
CZ CASEG_ASCII
RZ
CPI 07H
CZ CASEH_ASCII
RZ
CPI 08H
CZ CASEI_ASCII
RZ
CPI 09H
CZ CASEJ_ASCII
RZ
CPI 0AH
CZ CASEK_ASCII
RZ
CPI 0BH
CZ CASEL_ASCII
RZ
CPI 0CH
CZ CASEM_ASCII
RZ
CPI 0DH
CZ CASEN_ASCII
RZ
CPI 0EH
CZ CASEO_ASCII
RZ
CPI 0FH
CZ CASEP_ASCII
RZ
CPI 10H
CZ CASEQ_ASCII
RZ
CPI 11H
CZ CASER_ASCII
RZ
CPI 12H
CZ CASES_ASCII
RZ
CPI 13H
CZ CASET_ASCII
RZ
CPI 14H
CZ CASEU_ASCII
RZ
CPI 15H
CZ CASEV_ASCII
RZ
CPI 16H
CZ CASEW_ASCII
RZ
CPI 17H
CZ CASEX_ASCII
RZ
CPI 18H
CZ CASEY_ASCII
RZ
CPI 19H
CZ CASEZ_ASCII
RZ
CPI 1AH
CZ CASE0_ASCII
RZ
CPI 1BH
CZ CASE1_ASCII
RZ
CPI 1CH
CZ CASE2_ASCII
RZ
CPI 1DH
CZ CASE3_ASCII
RZ
CPI 1EH
CZ CASE4_ASCII
RZ
CPI 1FH
CZ CASE5_ASCII
RZ
CPI 20H
CZ CASE6_ASCII
RZ
CPI 21H
CZ CASE7_ASCII
RZ
CPI 22H
CZ CASE8_ASCII
RZ
CPI 23H
CZ CASE9_ASCII
RZ
CPI 24H
CZ CASECOMMA_ASCII
RZ
CPI 25H
CZ CASEPERIOD_ASCII
RZ
CPI 26H
CZ CASESPACE_ASCII
RZ

KYBORD: PUSH B
PUSH D
; SEND 00H TO LCD DATA BUFFER
MVI A, 00H
OUT PORT_LCD
XRA A
MOV E, A
OUT PORTA

KYREL: IN PORTB
ANI 01111111B
CPI 01111111B
JNZ KYREL

CALL DBONCE

KYCHK: IN PORTB
ANI 01111111B
CPI 01111111B

JZ KYCHK
CALL DBONCE

MVI A, 7FH
MVI B, 06H

NXTROW: RLC
MOV D, A
OUT PORTA
IN PORTB
ANI 01111111B
MVI C, 07H

NXTCOL: RAR
JNC CODE
INR E
DCR C
JNZ NXTCOL
MOV A, D
DCR B
JNZ NXTROW
JMP KYCHK

CODE: MOV A, E
POP D
POP B
RET

DBONCE: PUSH B
PUSH PSW
LXI B, COUNT
LOOPDBONCE: DCX B
MOV A, C
ORA B
JNZ LOOPDBONCE
POP PSW
POP B
RET

RESPONSE_TIME_DELAY: PUSH B
PUSH PSW
LXI B, RESPONSE_TIME_COUNT
LOOPDBONCE_RESPONSE_TIME: DCX B
MOV A, C
ORA B
JNZ LOOPDBONCE_RESPONSE_TIME
POP PSW
POP B
RET

PULSE_LCD: MVI A, 00H
OUT PORTA ; LOWER LCD_ENABLE LINE
MVI A, 10000000B
OUT PORTA ; RAISE LCD_ENABLE LINE
NOP
MVI A, 00000000B
OUT PORTA ; LOWER LCD_ENABLE LINE
RET

DISPLAY_LCD: CALL HEX_TO_ASCII
OUT PORT_LCD
CALL PULSE_LCD
RET

REMOVE_LCD: NOP
RET

INIT_LCD: PUSH PSW

; CLEAR LCD
MVI A, LCD_COMMAND
OUT PORTA ; LCD COMMAND REGISTER SELECT

MVI A, LCD_CLEAR
OUT PORT_LCD ; CLEAR COMMAND
CALL PULSE_LCD

; INCREMENT CURSOR WITHOUT SHIFT
MVI A, ICWS
OUT PORT_LCD
CALL PULSE_LCD

; DISPLAY ON, CURSOR ON, BLINK OFF
MVI A, DSPCURBLK
OUT PORT_LCD
CALL PULSE_LCD

; SHIFT CURSOR LEFT WITHOUT SHIFTING SCREEN
MVI A, CURLEFT
OUT PORT_LCD
CALL PULSE_LCD

; 8 BIT 2 LINE MODE
MVI A, BIT8LINE2
OUT PORT_LCD
CALL PULSE_LCD

POP PSW
RET

hlt