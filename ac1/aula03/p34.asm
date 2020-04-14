	.data
str1:	.asciiz "Introduza um numero: "
str2:	.asciiz "\nValor em código Gray: "
str3:	.asciiz "\nValor em binario: "
	.eqv print_string,4
	.eqv read_int,5
	.eqv print_int16,34
	.text
	.globl main #gray para binário

main:	la  $a0,str1
	li  $v0,print_string
	syscall
	li  $v0,read_int
	syscall
	or  $t0,$0,$v0 # $t0 = gray
	srl $t1,$t0,1  # $t1 = mask
	or  $t2,$0,$t0 # $t2 = bin

while:	beqz $t1,endw
	xor $t2,$t2,$t1
	srl $t1,$t1,1
	j while

endw:   la  $a0,str2
	li  $v0,print_string
	syscall
	or  $a0,$0,$t0
	li  $v0,print_int16
	syscall
	la  $a0,str3
	li  $v0,print_string
	syscall
	or  $a0,$0,$t2
	li  $v0,print_int16
	syscall
	
	jr  $ra