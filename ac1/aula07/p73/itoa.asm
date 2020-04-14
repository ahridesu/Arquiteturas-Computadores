	.data
	.text
	.globl itoa
	
	# completamente não virei a página, não vi o codigo que já existia no guião
	# as "passagens" são iguais, mas é natural que exista 1 ou outra diferença para o guião
	
	# char* itoa(unsigned int n, unsigned int b, char *s) transforma n em int base b
itoa:	subiu	$sp,$sp,20
	sw	$s0,0($sp)
	sw	$s1,4($sp)
	sw	$s2,8($sp)
	sw	$s3,12($sp)
	sw	$ra,16($sp)
	move	$s0,$a0			# $s0 = n
	move	$s1,$a1			# $s1 = b
	move	$s2,$a2			# $s2 = char *s
	move	$s3,$a2			# $s3 = *p = char *s
do:	rem	$a0,$s0,$s1		# $a0 = digit	
	div	$s0,$s0,$s1
	jal	toascii
	sb	$v0,0($s3)
	addiu	$s3,$s3,1		
	bgt	$a0,0,do
	li	$t0,'\0'
	sb	$t0,0($s3)
	move	$a0,$s2
	jal	strrev
	lw	$s0,0($sp)
	lw	$s1,4($sp)
	lw	$s2,8($sp)
	lw	$s3,12($sp)
	lw	$ra,16($sp)
	addiu	$sp,$sp,20
	jr	$ra
	
	 # converte digito v para ASCII
toascii: # char	toascii (char v)
	addiu	$a0,$a0,'0'
	ble	$a0,'9',endif
	addiu	$a0,$a0,7
endif:	move 	$v0,$a0
	jr	$ra
	
