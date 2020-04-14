	.data
str1:	.asciiz "Introduza um numero: "
str2: 	.asciiz "\nO valor em binário é: "
	.eqv print_string,4
	.eqv read_int,5
	.eqv print_char,11
	.text
	.globl main #transforma decimal em binário, espaços, eliminou-se condição, sem zeros a esquerda

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
	li  $t4,0 #$t4 => int flag = 0;
	li  $v0,print_char

for:	bge $t2,32,endfor 
	srl $t1,$t0,31 #$t1 = bit #bem
	sne $t5,$0,$t1
	or  $t5,$t4,$t5
	
if:	beq $t5,$0,end_if #bem
	li  $t4,1
	rem $t3,$t2,4
	
if_esp:	bne $t3,$0,end_esp #bem
	li  $a0,' '
	syscall

end_esp:or  $a0,$0,$t1 #bem
	addi $a0,$a0,0x30
	syscall
	
end_if: sll $t0,$t0,1 #bem
	addi $t2,$t2,1
	j   for
	
endfor:	jr  $ra