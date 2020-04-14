		.equ readInt10,5
		.equ printInt,6
		.equ printInt10,7
		.equ PRINT_STR,8
		.data
str1:	.asciiz "\nIntroduza um numero (sinal e módulo)\n"
str2:	.asciiz "\nValor lido em base 2: \n"
str3:	.asciiz "\nValor lido em base 16: \n"
str4:	.asciiz "\nValor lido em base 10 (unsigned): \n"
str5:	.asciiz "\nValor lido em base 10 (signed): \n"
		.text
		.globl main

main:	la 		$a0,str1
		li 		$v0,PRINT_STR
		syscall

		li 		$v0,readInt10
		syscall
		move 	$t0,$v0

		la 		$a0,str2
		li 		$v0,PRINT_STR
		syscall

		move	$a0,$t0
		li 		$a1,2
		li 		$v0,printInt
		syscall

		la 		$a0,str3
		li 		$v0,PRINT_STR
		syscall

		move	$a0,$t0
		li 		$a1,16
		li 		$v0,printInt
		syscall

		la 		$a0,str4
		li 		$v0,PRINT_STR
		syscall

		move	$a0,$t0
		li 		$a1,10
		li 		$v0,printInt
		syscall

		la 		$a0,str5
		li 		$v0,PRINT_STR
		syscall

		move	$a0,$t0
		li 		$v0,printInt10
		syscall

		j		main
