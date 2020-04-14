	.data
str:	.asciiz	"Arquitetura de Computadores I"
	.text
	.globl main
	
	# teste de strlen
main:	subu	$sp,$sp,4
	sw	$ra,0($sp)
	la	$a0,str
	jal	strlen
	lw	$ra,0($sp)
	addiu	$sp,$sp,4
	move	$a0,$v0
	ori	$v0,$0,1
	syscall
	li	$v0,0
	jr	$ra
	
	# strlen, determina e devolve dimensão de string (char *s)
strlen:	li	$t1,0		# len = 0;
while:	lb	$t0,0($a0)
	addiu	$a0,$a0,1
	beq	$t0,'\0',endw
	addi	$t1,$t1,1
	j	while

endw:	move	$v0,$t1
	jr	$ra
