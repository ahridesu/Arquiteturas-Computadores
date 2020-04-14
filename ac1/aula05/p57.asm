	.data
array:	.word	str1,str2,str3
str1:	.asciiz "Array"
str2:	.asciiz	"de"
str3:	.asciiz	"ponteiros"
	.eqv	print_string,4
	.eqv	print_char,11
	.eqv	SIZE,3
	
	.text
	.globl main
	
	# leitura de array de ponteiros para strings(acesso por ponteiro)
main:	la	$t0,array	# *p para array
	li	$t1,SIZE	# $t1 = Size * 4 + array 
	sll	$t1,$t1,2
	addu	$t1,$t1,$t0
	
for:	bge	$t0,$t1,endf
	lw	$a0,0($t0)	
	# imprimir
	li	$v0,print_string
	syscall
	li	$a0,'\n'
	li	$v0,print_char
	syscall
	addiu	$t0,$t0,4
	j	for

endf:	jr	$ra