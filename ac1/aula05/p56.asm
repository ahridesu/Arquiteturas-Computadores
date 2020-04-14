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
	
	# leitura de array de ponteiros para strings
main:	la	$t0,array	# ponteiro para array
	li	$t1,0		# i = 0

for:	bge	$t1,SIZE,endf
	sll	$a0,$t1,2	
	addu	$a0,$a0,$t0	# array[i]
	lw	$a0,0($a0)
	# imprimir
	li	$v0,print_string
	syscall
	li	$a0,'\n'
	li	$v0,print_char
	syscall
	addiu	$t1,$t1,1
	j	for

endf:	jr	$ra
