	.data
str:	.asciiz	"2016 e 2020 sao anos bissextos"
	.eqv	print_int10,1
	.text
	.globl main
	# basicamente Integer.parseInt(String s) só que só lê até encontrar valores que não são inteiros
main:	la	$a0,str
	subiu	$sp,$sp,4
	sw	$ra,0($sp)
	jal	atoi
	lw	$ra,0($sp)
	addiu	$sp,$sp,4
	move 	$a0,$v0
	la	$v0,print_int10
	syscall
	li	$v0,0		# return = 0;
	jr	$ra

	# int atoi(char *s)	
atoi:	li	$v0,0
while:	lb	$t0,0($a0)
	blt	$t0,'0',endw
	bgt	$t0,'9',endw
	sub	$t1,$t0,'0'	# *s - '0'
	addiu	$a0,$a0,1	# *s++
	mul	$v0,$v0,10	# res = 10 * res
	add	$v0,$v0,$t1
	j 	while
endw:	jr	$ra	
	
		
			
					