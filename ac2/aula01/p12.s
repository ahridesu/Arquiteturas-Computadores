		.equ intkey,1
		.equ PRINT_STR,8
		.data
msg:	.asciiz "Key pressed\n"
		.text
		.globl main

main:	li		$v0,intkey
		syscall
		beq		$v0,0,main
		beq		$v0,'\n',end 
		# printStr("Key pressed\n");
		la 		$a0,msg
		li 		$v0,PRINT_STR
		syscall
		j 		main
end:	# return 0;
		li		$v0,0
		jr		$ra
