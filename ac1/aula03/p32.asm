	.data
str1:	.asciiz "Introduza um numero: "
str2: 	.asciiz "\nO valor em binário é: "
	.eqv print_string,4
	.eqv read_int,5
	.eqv print_char,11
	.text
	.globl main #transforma decimal em binário, espaços tb

main:	la  $a0,str1
	li  $v0,print_string
	syscall
	li  $v0,read_int
	syscall
	or  $t0,$0,$v0 #$t0 = value = read_int()
	la  $a0,str2
	li  $v0,print_string
	syscall
	li  $t2,0 #$t2 = i = 0
	li  $v0,print_char

for:	bge $t2,32,endfor
	rem $t3,$t2,4

if_esp:	bne $t3,$0,end_esp
	li  $a0,' '
	syscall

end_esp:andi $t1,$t0,0x80000000 #$t1 = bit
	beq $t1,$0,else
	li  $a0,'1' #ou ascii 49
	syscall
	j endif
	
else:	li  $a0,'0' #ou ascii 48
	syscall
	
endif:	sll $t0,$t0,1
	addi $t2,$t2,1
	j   for
	
endfor:	jr  $ra
		