
;<Program title>

jmp start

;data
l: equ 09h
start_add: equ 8000h
store_a: equ 1000h

;code
start: mvi e, l
lxi h, start_add
lxi sp, 0ffffh

loop_outer: sta store_a ; 13
mov a, e ; 4
cpi 00h ; 7
lda store_a ; 13
jnz loop_inner_init ; 10
hlt

loop_inner_init: mvi c, 00h ; 7
loop_inner: sta store_a ; 13
mov a, c ; 4
cmp e ; 4
lda store_a ; 13
jnz inner_loop_body ; 10
dcr e ; 4
jmp loop_outer ; 10

inner_loop_body: push h ; 12
dad b ; 6
mov d, m ; 7
inx h ; 6
sta store_a ; 13
mov a, m ; 7
cmp d ; 4
cc swap ; 18
lda store_a ; 13
pop h ; 12
inr c ; 4
jmp loop_inner ; 10

swap: mov m, d ; 7
dcx h ; 6
mov m, a ; 7
ret ; 12