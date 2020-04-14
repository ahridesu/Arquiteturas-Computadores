	.data
str1:	.asciiz "Introduza dois numeros: "
str2:	.asciiz "Resultado: "
	.eqv	read_int,5
	.eqv	print_string,4
	.eqv	print_int10,1
	.text
	.globl main # multiplicador de 16 bits
main:	li  $t0, 0 # $t0 = res
	li  $t1, 0 # $t1 = i
	la  $a0,str1
	li  $v0,print_string
	syscall
	li  $v0,read_int
	syscall
	or  $t2,$0,$v0 # $t2 = mdor
	li  $v0,read_int
	syscall
	or  $t3,$0,$v0 # $t3 = mdo
	# and´s
	andi $t2,$t2,0x0FFFF
	andi $t3,$t3,0x0FFFF
while:	
	beqz $t2,endw
	bge $t1,16,endw
	addi $t1,$t1,1 #i++
	
	and $t4,$t2,0x01
	beqz $t4,endif
	add $t0,$t0,$t3
	
endif:	sll $t3,$t3,1
	srl $t2,$t2,1
	j while
	
endw:	la  $a0,str2
	li  $v0,print_string
	syscall
	move $a0,$t0
	li  $v0,print_int10
	syscall
	jr  $ra
