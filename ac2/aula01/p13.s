		.equ getChar,2
		.equ putChar,3
		.data
		.text
		.globl main

main:	li		$v0,getChar
		syscall
		beq 	$v0,'\n',end
		move	$a0,$v0
		li		$v0,putChar
		syscall
		j 	main
end:	# return 0;
		li		$v0,1
		jr		$ra
