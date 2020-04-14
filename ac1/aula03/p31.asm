	.data
str1:	.asciiz "Introduza um numero: "
str2:	.asciiz "Valor ignorado\n"
str3:	.asciiz "A soma dos positivos é: "
	.eqv print_string,4
	.eqv read_int,5
	.eqv print_int10,1
	.text
	.globl main #acumulador de valores positivos lidos, ciclo for(;i<5;) 
main:	li  $t0,0 #soma = 0
	li  $t2,0 #i = 0

for:	bge $t2,5,endfor
	la  $a0,str1
	ori $v0,$0,print_string
	syscall
	ori $v0,$0,read_int
	syscall
	or  $t1,$0,$v0 #value = read_int()
	ble $t1,$0,else
	add $t0,$t0,$t1
	j   endif

else:	la  $a0,str2
	ori $v0,$0,print_string
	syscall
	
endif:	addi $t2,$t2,1
	j    for
	
endfor:	la  $a0,str3
	ori $v0,$0,print_string
	syscall
	or  $a0,$0,$t0
	ori $v0,$0,print_int10
	syscall
	jr  $ra
	