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
	.globl main	# programa lê valores para array(ponteiro), ordenação bubble-sort(indice), impressao de valores(indice)

main:					# leitura de valores, igual a p51.asm só que usando ponteiro
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

	# inicio ordenação (indice)
	la	$t6,lista		# $t6 = lista
do:	
	li	$t4,FALSE		# houve_troca = FALSE
	li	$t5,0			# i = 0
	li	$t2,SIZE
	subu 	$t2,$t2,1		# SIZE - 1
while1:	bge 	$t5,$t2,endw1		# while(i < SIZE-1)
	sll	$t7,$t5,2		# lista + i
	addu	$t7,$t7,$t6
	lw	$t8,0($t7)		# load 2 plavras para comparar
	lw	$t9,4($t7)	
if:	ble	$t8,$t9,endif		# if começa aqui, nao onde esta no guião
#if:	bleu	$t8,$t9,endif		# trocar com o de cima para versão em unsigned		
	sw	$t8,4($t7)		# trocar palavras
	sw	$t9,0($t7)
	li	$t4,TRUE
	
endif:	addiu	$t5,$t5,1
	j	while1
endw1:	
	beq	$t4,TRUE,do
					
	la	$a0,str3		# imprimir mensagem e etc 
	li	$v0,print_string
	syscall	
	
	# codigo para imprimir (leitura por index)
	li	$t5,0			# i = 0
while2:	bgeu 	$t5,SIZE,endw2
	sll	$t7,$t5,2		# lista + i
	addu	$t7,$t7,$t6		
	lw	$a0,0($t7)		# $t1 = valor			
	
	li	$v0,print_int10		#imprimir valor e string
	syscall
	la	$a0,str2
	li	$v0,print_string
	syscall  			#acabam aqui prints
	
	addu	$t5,$t5,1
	j	while2

endw2:	jr	$ra	
	
	
