	.data
str1:	.asciiz	"Arquitetura de "
str2:	.space	50
str3:	.asciiz "Computadores I"
str4:	.asciiz "\n"
	.eqv	print_string,4
	.eqv	print_int10,1
	.text
	.globl main
	# concatenar Strings
main:	subu	$sp,$sp,4
	sw	$ra,0($sp)
	la	$a0,str2
	la	$a1,str1
	jal	strcpy
	move	$a0,$v0
	li	$v0,print_string
	syscall
	la	$a0,str4
	syscall
	la	$a0,str2
	la	$a1,str3
	jal	strcat
	move	$a0,$v0
	li	$v0,print_string
	syscall
	lw	$ra,0($sp)
	addiu	$sp,$sp,4
	li	$v0,0
	jr	$ra
	# strcat (char *dst, char *src)
strcat:	move	$t0,$a0
while4:	lb	$t1,0($t0)
	beq	$t1,'\0',endw4
	addiu	$t0,$t0,1
	j	while4
	
endw4:	subiu	$sp,$sp,8
	sw	$a0,0($sp)
	sw	$ra,4($sp)
	move	$a0,$t0
	jal	strcpy
	lw	$ra,4($sp)
	lw	$v0,0($sp)
	addiu	$sp,$sp,8
	jr	$ra
	# strcpy (char *dst, char *src)	
strcpy:	move	$v0,$a0
do:	
	addu	$t0,$t2,$a0	# dst[i] = src[i]
	addu	$t1,$t2,$a1
	lb	$t1,0($t1)	
	sb	$t1,0($t0)
	beq	$t1,'\0',endw3
	addiu	$a0,$a0,1
	addiu	$a1,$a1,1
	j	do

endw3:	jr	$ra