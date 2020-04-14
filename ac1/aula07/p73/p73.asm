	.data
	.eqv	MAX_STR_SIZE,33
	.eqv	print_string,4
	.eqv	read_int,5
str:	.space	MAX_STR_SIZE
	.text
	.globl main
	# 
main:	subiu	$sp,$sp,12
	sw	$s0,0($sp)
	sw	$s1,4($sp)
	sw	$ra,8($sp)
	la	$s1,str			# $s1 = str	
do:	li	$v0,read_int
	syscall
	move	$s0,$v0			# $s0 = value
	# prints e chamadas a itoa
	move	$a0,$s0
	li	$a1,2
	move	$a2,$s1
	jal	itoa
	move	$a0,$v0
	li	$v0,print_string
	syscall
	move	$a0,$s0
	li	$a1,8
	move	$a2,$s1
	jal	itoa
	move	$a0,$v0
	li	$v0,print_string
	syscall
	move	$a0,$s0
	li	$a1,12
	move	$a2,$s1
	jal	itoa
	move	$a0,$v0
	li	$v0,print_string
	syscall
	# while(val != 0)
	bne	$s0,'0',do
	# repor valores e acabar
	lw	$s0,0($sp)
	lw	$s1,4($sp)
	lw	$ra,8($sp)
	addiu	$sp,$sp,12
	li	$v0,0
	jr	$ra