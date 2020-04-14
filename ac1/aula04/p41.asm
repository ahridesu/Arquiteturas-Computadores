	.data
	.eqv   SIZE,20
	.eqv   read_string,8
	.eqv   print_int10,1
	.align 2 # não no guião
str:	.space SIZE 
	
	.text 
	.globl main # lê string e imprimie quantidade de caracteres numéricos,array
main:	la  $a0,str
	
	li  $a1,SIZE
	li  $v0,read_string
	syscall
	li  $t0,0 # num
	li  $t1,0 # i
while:	
	la  $t2,str
	addu $t3,$t2,$t1 # str+i
	lb  $t4,0($t3)
	beq $t4,'\0',endw

if:	blt $t4,'0',endif
	bgt $t4,'9',endif
	addi $t0,$t0,1

endif:
	addi $t1,$t1,1
	j while
	
endw:	or  $a0,$0,$t0
	li  $v0,print_int10
	syscall
	jr  $ra
