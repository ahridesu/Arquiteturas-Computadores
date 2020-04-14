	.data
str1:	.asciiz "\nNúmero de Caracteres: "
str2:	.asciiz	"\nNúmero de Maiúsculas: "
str3:	.asciiz "\nNúmero de Minúsculas: "
str4:	.asciiz "String com maior número de Caracteres: "
str5:	.asciiz ": "
str6:	.asciiz "Erro!\nPrograma sem argumentos!"	
	.eqv	print_int10,1
	.eqv	print_string,4
	.eqv	print_char,11
	.text
	.globl main
	
	#  Programa imprimie o que está em cima escrito a partir dos argumentos (int argc, char *argv[])
main:	move	$t0,$a0			# $t0 = argc
	beqz	$t0,noArgs		# sem argumentos não existe programa
	sll	$t0,$t0,2		# $t0 = Max index
	addu	$t0,$t0,$a1
	li	$t5,0			# $t5 = Max caracteres
	li	$t6,0			# $t6 = Index String Max Carateres
	
for:	bge	$a1,$t0,endf
	lw	$t1,0($a1)		# $t1 = *p para String
	li	$t2,0			# $t2 = número de caracteres
	li	$t3,0			# $t3 = número de letras Maiusculas
	li	$t4,0			# $t4 = número letas Minúsculas
	
while:
	lb	$t7,0($t1)		# $t7 = char
	beq	$t7,'\0',endw
	# imprimir tretas
	move	$a0,$t7
	li	$v0,print_char
	syscall
	# fim impressão
	addiu	$t2,$t2,1		# número caracteres++;
if1:	blt	$t7,'A',endif1
	bgt	$t7,'Z',endif1
	addiu	$t3,$t3,1		# número Maiusculas++;
endif1:	
if2:	blt	$t7,'a',endif2
	bgt	$t7,'z',endif2
	addiu	$t4,$t4,1		# número Maiusculas++;
endif2:
	addiu	$t1,$t1,1
	j	while
	
endw:	
	# imprimir valores temporários
	la	$a0,str5
	li	$v0,print_string
	syscall
	la	$a0,str1
	syscall
	move	$a0,$t2
	li	$v0,print_int10
	syscall
	la	$a0,str2
	li	$v0,print_string
	syscall
	move	$a0,$t3
	li	$v0,print_int10
	syscall
	la	$a0,str3
	li	$v0,print_string
	syscall
	move	$a0,$t4
	li	$v0,print_int10
	syscall
	li	$a0,'\n'
	li	$v0,print_char
	syscall
	syscall
	# fim das impressões
if3:	blt	$t2,$t5,endif3
	move	$t5,$t2
	move	$t6,$a1
endif3:	
	addiu	$a1,$a1,4
	j	for
	
endf:	la 	$a0,str4
	li	$v0,print_string
	syscall
	move 	$a0,$t6
	lw	$a0,0($t6)
	syscall
	la	$a0,str1
	syscall
	move 	$a0,$t5
	li	$v0,print_int10
	syscall
	li	$v0,0
	jr	$ra
	
noArgs: la 	$a0,str6
	li	$v0,print_string
	syscall
	li	$v0,1
	jr	$ra