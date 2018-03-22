
;<Program title>

jmp start

;data
LABEL: DB 0004H

;code
start: NOP
LXI H, LABEL
MOV A, M
hlt