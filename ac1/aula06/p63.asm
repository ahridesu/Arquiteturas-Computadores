	.data
str1:	.asciiz	"I serodatupmoC ed arutetiuqrA"
str2:	.space	31
str3:	.asciiz "String too long: "
str4:	.asciiz "\n"
	.eqv	STR_MAX_SIZE,30
	.eqv	print_string,4
	.eqv	print_int10,1
	.text
	.globl main
	# imprime string, copia(index) depois reverte e imprime
main:	la	$a0,str1
	subu	$sp,$sp,4
	sw	$ra,0($sp)
	jal	strlen
if:	bgt	$v0,STR_MAX_SIZE,else
	la	$a0,str2
	la	$a1,str1
	jal	strcpy
	#prints
	move	$a0,$v0
	li	$v0,print_string
	syscall
	la	$a0,str4
	syscall
	la	$a0,str2
	jal	strrev
	move	$a0,$v0
	li	$v0,print_string
	syscall
	#fim prints
	li	$v0,0
	j	endif
	
else:	la	$a0,str3
	li	$v0,print_string
	syscall
	la	$a0,str1
	jal	strlen
	move	$a0,$v0
	li	$v0,print_int10
	syscall
	li	$v0,-1
	j	endif
	
endif:	lw	$ra,0($sp)
	addiu	$sp,$sp,4
	jr	$ra
	# strcpy (char *dst, char *src)
strcpy:	li	$t2,0		#i=0
do:	
	addu	$t0,$t2,$a0	# dst[i] = src[i]
	addu	$t1,$t2,$a1
	lb	$t1,0($t1)	
	sb	$t1,0($t0)
	beq	$t1,'\0',endw3
	addiu	$t2,$t2,1
	j	do

endw3:	move	$v0,$a0
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

	# strrev, determina e devolve dimensão de string (char *str)
strrev:	
	subu	$sp,$sp,16	# reservar espaço na stack
	sw	$ra,0($sp)	# guardar $ra
	sw	$s0,4($sp)	# guardar registos
	sw	$s1,8($sp)
	sw	$s2,12($sp)
	move	$s0,$a0		# salvar valores de entrada
	move	$s1,$a0		# p1 = str
	move	$s2,$a0		# p2 = str
	lb	$t1,0($s2)
	# p2 = str.length - 1 (\0 não conta para substituir)
while1:	
	beq	$t1,'\0',endw1	
	addiu	$s2,$s2,1
	lb	$t1,0($s2)
	j	while1
endw1:	
	subiu	$s2,$s2,1
	
	# while (p1 < p2)
while2:	
	bge	$s1,$s2,endw2
	move	$a0,$s1
	move	$a1,$s2
	jal	exchange
	addiu	$s1,$s1,1
	subiu	$s2,$s2,1
	j	while2
	
	# meter dados nos sitios certos
endw2:	
	move	$v0,$s0
	lw	$ra,0($sp)
	lw	$s0,4($sp)
	lw	$s1,8($sp)
	lw	$s2,12($sp)
	addu	$sp,$sp,16
	jr	$ra

	# mudar lugar de caracteres
exchange:
	lb	$t0,0($a0)
	lb	$t1,0($a1)
	sb	$t0,0($a1)
	sb	$t1,0($a0)
	jr	$ra
