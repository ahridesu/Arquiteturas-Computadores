	.data
	.text
	.globl strrev
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