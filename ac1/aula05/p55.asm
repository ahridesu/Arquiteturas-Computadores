	.data
	.eqv	FALSE,0
	.eqv	TRUE,1
	.eqv	SIZE,10
	.eqv	print_int10,1
	.eqv	read_int,5
	.eqv	print_string,4
str1:	.asciiz "\nIntroduza um numero: "
str2:	.asciiz "; "
str3:	.asciiz "\nConteudo do array:\n"
	.align 	2
lista:	.space  40
	.text
	.globl main	
	# programa lê valores para array(ponteiro), ordenação sequencial(ponteiro), impressao de valores(indice)
	
	# leitura de valores(ponteiro)
main:					
	la	$t0,lista		# $t0 = lista (ponteiro)
	li	$t2,SIZE		# $t2 = SIZE
	sll	$t2,$t2,2		# $t2 * 4
	addu	$t2,$t0,$t2		# $t2 = lista + SIZE
while0:	bgeu	$t0,$t2,endw0
	la	$a0,str1		#print
	li	$v0,print_string
	syscall				#final print
	li	$v0,read_int
	syscall				
	sw	$v0,0($t0)
	addiu	$t0,$t0,4		#de int em int (word em word)
	j	while0
endw0:					# fim leitura de valores para array

	# inicio ordenação (ponteiro)
	la	$t0,lista		# $t0 = ponteiro lista
	li	$t2,SIZE		
	sll	$t2,$t2,2
	addu	$t2,$t2,$t0		# SIZE
	subiu	$t3,$t2,4		# SIZE - 1
for0:	bgeu	$t0,$t3,endf0
	addiu	$t1,$t0,4		# $t1 = segundo ponteiro

for1:	bgeu	$t1,$t2,endf1
	lw	$t4,0($t0)
	lw	$t5,0($t1)

if:	ble	$t4,$t5,endif		# comparação de valores
	move 	$t6,$t4			# $t6 = aux
	move	$t4,$t5
	move	$t5,$t6
	sw	$t4,0($t0)
	sw	$t5,0($t1)			

endif:	addiu	$t1,$t1,4
	j	for1

endf1:	addiu	$t0,$t0,4
	j	for0

endf0:	# final da ordenação
			
	# codigo para imprimir (leitura por index)
	la	$t0,lista
	li	$t1,0			# i = 0
while1:	bgeu 	$t1,SIZE,endw1
	sll	$t2,$t1,2		# lista + i
	addu	$t2,$t2,$t0		
	lw	$a0,0($t2)		# $t1 = valor			
	
	li	$v0,print_int10		#imprimir valor e string
	syscall
	la	$a0,str2
	li	$v0,print_string
	syscall  			#acabam aqui prints
	
	addu	$t1,$t1,1
	j	while1

endw1:	jr	$ra