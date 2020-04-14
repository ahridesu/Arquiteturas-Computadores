	.data
str1:	.asciiz "Nr. de parametros: "
str2:	.asciiz	"\np"
str3:	.asciiz ": "	
	.eqv	print_int10,1
	.eqv	print_string,4
	.text
	.globl main
	
	# imprime argumantos String passados a main por (int argc, char *argv[]) 
main:	move	$t0,$a0			# $t0 = argc
	la	$a0,str1
	li	$v0,print_string
	syscall
	move	$a0,$t0
	li	$v0,print_int10
	syscall
	li	$t1,0			# i = 0
	
for:	bge	$t1,$t0,endf
	# imprimir tretas
	la	$a0,str2
	li	$v0,print_string
	syscall
	move	$a0,$t1
	li	$v0,print_int10
	syscall
	la	$a0,str3
	li	$v0,print_string
	syscall
	# agora as coisa sérias	
	sll	$t2,$t1,2
	addu	$t2,$t2,$a1
	lw	$a0,0($t2)
	syscall
	addiu	$t1,$t1,1
	j	for
	
endf:	li	$v0,0
	jr	$ra			