	.data
	.eqv 	SIZE,5
str1:	.asciiz "\nIntroduza um numero: "
	.align 	2
lista:	.space  20
	.eqv	read_int,5
	.eqv	print_string,4
	.text
	.globl main			# programa que lê valores para array, acesso sequencial
main:	li	$t0,0			# i = 0;
	la	$t1,lista		# faço minima ideia porque esta instruçao estava em baixo -_-
while:	bge	$t0,SIZE,endw
	la	$a0,str1		#print
	li	$v0,print_string
	syscall				#final print
	li	$v0,read_int
	syscall				
	sll	$t2,$t0,2		# lista + i
	addu	$t2,$t1,$t2
	sw	$v0,0($t2)
	addi	$t0,$t0,1
	j	while
endw:	jr	$ra
