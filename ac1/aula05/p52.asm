	.data
str1:	.asciiz "; "
str2:	.asciiz "\nConteudo do array:\n"
lista:	.word	8,-4,3,5,124,-15,87,9,27,15
	.eqv	print_int10,1
	.eqv	print_string,4
	.eqv	SIZE,10
	.text
	.globl main	# programa imprimir valores dentro de array pré-definido, acesso por ponteiro

main:	la	$a0,str2
	li	$v0,print_string
	syscall
	la	$t0,lista	# $t0 = lista (ponteiro)
	li	$t2,SIZE	# $t2 = SIZE
	sll	$t2,$t2,2		# $t2 * 4
	addu	$t2,$t0,$t2	# $t2 = lista + SIZE
while:	bgeu	$t0,$t2,endw
	lw	$t1,0($t0)	# $t1 = valor
	
	or	$a0,$0,$t1	#imprimir valor e string	
	li	$v0,print_int10
	syscall
	la	$a0,str1
	li	$v0,print_string
	syscall  		#acabam aqui prints
	
	addu	$t0,$t0,4	# 4 porque esta a carregar words(4 bytes, 32 bits)
	j	while

endw:	jr	$ra	