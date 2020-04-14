	.data
str:	.asciiz	"101101"
	.eqv	print_int10,1
	.text
	.globl main
	# transforma binário em decimal
main:	la	$a0,str
	subiu	$sp,$sp,4
	sw	$ra,0($sp)
	jal	atoi
	lw	$ra,0($sp)
	addiu	$sp,$sp,4
	move 	$a0,$v0
	la	$v0,print_int10
	syscall
	jr	$ra

	# int atoi(char *s)	
atoi:	li	$v0,0		# res = 0
	li	$t3,-1		# 2 ^ peso
	move 	$t2,$a0		# $t2 = maxIndex
while0:	lb	$t0,0($t2)
	blt	$t0,'0',while1
	bgt	$t0,'1',while1
	addiu	$t2,$t2,1	
	j	while0
		
while1:	blt	$t2,$a0,endw
	lb	$t0,0($t2)	# val
	subi	$t0,$t0,'0'	# *s - '0'
	sllv	$t0,$t0,$t3	# val * 2 ^ peso
	addu	$v0,$v0,$t0	# res += val
	subiu	$t2,$t2,1
	addiu	$t3,$t3,1
	j 	while1
	
endw:	jr	$ra
