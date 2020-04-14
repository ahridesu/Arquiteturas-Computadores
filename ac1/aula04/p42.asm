	.data
	.eqv   SIZE,20
	.eqv   read_string,8
	.eqv   print_int10,1
	.align 2 # não no guião
str:	.space SIZE 

	.text
	.globl main #lê string e imprimie quantidade de caracteres numéricos,ponteiro
main:	
	la  $a0,str
	li  $a1,SIZE
	li  $v0,read_string
	syscall
	li  $t0,0   # num = 0
	la  $t1,str # ponteiro inicio string
while: 
	lb  $t2,0($t1) # ler posição memoria
	beq $t2,'\0',endw
	blt $t2,'0',endif
	bgt $t2,'9',endif
	addi $t0,$t0,1 # num++;

endif:
	addiu $t1,$t1,1
	j  while
	
endw:	or  $a0,$0,$t0
	li  $v0,print_int10
	syscall
	jr  $ra
