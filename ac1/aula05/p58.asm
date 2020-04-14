	.data
array:	.word	str1,str2,str3
str1:	.asciiz "Array"
str2:	.asciiz	"de"
str3:	.asciiz	"ponteiros"
str4:	.asciiz	"\nString #"
str5:	.asciiz ": "
	.eqv	print_int10,1
	.eqv	print_string,4
	.eqv	print_char,11
	.eqv	SIZE,3
	.text
	.globl main
	
	# imprimir Strings carater a carater separados pelo "-" (index)
main:	la	$t0,array	# ponteiro para array
	li	$t1,0		# i = 0

for:	bge	$t1,SIZE,endf
	# imprimir dentro for
	la	$a0,str4
	li	$v0,print_string
	syscall
	move	$a0,$t1
	li	$v0,print_int10
	syscall
	la	$a0,str5
	li	$v0,print_string
	syscall
	# fim prints
	li	$t2,0		# j = 0
	sll	$t3,$t1,2
	addu	$t3,$t3,$t0	# $t3 = posicao de array[i]
	# modificação minha ao exercicio para não imprimir o ultimo "-" (rudimentar)
	li	$t5,0
while:  
	lw	$t4,0($t3)	# $t4 = posicao de string
	addu	$t4,$t4,$t2
	lb	$t6,0($t4)
	beq	$t6,'\0',endw	
	# imprimir dentro while
	beqz	$t5,endif
	li	$a0,'-'
	syscall
	
endif:	move 	$a0,$t6
	li	$v0,print_char
	syscall
	li	$t5,1
	addiu	$t2,$t2,1
	j	while
	
endw:	
	addiu	$t1,$t1,1
	j	for

endf:	jr	$ra
