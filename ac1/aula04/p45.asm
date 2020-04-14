	.data
	.eqv SIZE,20
	.eqv read_string,8
	.eqv print_string,4
	.align 2
str:	.space SIZE
str1:	.asciiz "Introduza uma string: "
	.text
	.globl main # string para maiusculas

main:	la  $a0,str1
	li  $v0,print_string
	syscall
	la  $a0,str
	li  $a1,SIZE
	li  $v0,read_string
	syscall
	la  $t0,str # p = str

while:	lb  $t1,0($t0)
	beq $t1,'\n',endw
	beq $t1,'\0',endw
	bgt $t1,0x7A,endif
	blt $t1,0x61,endif
	subi $t1,$t1,0x61
	addi $t1,$t1,0x41
	sb  $t1,0($t0)				
endif:	addiu $t0,$t0,1
	j   while
	
endw:	la  $a0,str
	li  $v0,print_string
	syscall
	jr  $ra
