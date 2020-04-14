	.data
	.text
	.globl main
main:	ori $v0,$0,5 #ler do teclado, não esta no guião
	syscall
	or  $t0,$0,$v0
	ori $v0,$0,5
	syscall
	or  $t1,$0,$v0 #acaba leitura do teclado
	and $t2,$t0,$t1
	or  $t3,$t0,$t1
	nor $t4,$t0,$t1
	xor $t5,$t0,$t1
	xori $t6,$t0,0xffffffff #not á patrão!
	jr  $ra
