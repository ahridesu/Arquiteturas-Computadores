	.data
array:	.word 7692, 23, 5, 234
	.eqv  print_int10, 1
	.eqv  SIZE, 4
	.text
	.globl main # soma valores no array, array pre-definido, ponteiro

main:	li  $t3,0    # soma = 0
	li  $t4,SIZE
	sub $t4,$t4,1
	sll $t4,$t4,2
	la  $t0,array # array
	addu $t1,$t0,$t4
	
while:  
	bgtu $t0,$t1,endw
	lw  $t2,0($t0)
	add $t3,$t3,$t2
	addu $t0,$t0,4
	j    while

endw:   or  $a0,$0,$t3
	li  $v0,print_int10
	syscall
	jr  $ra