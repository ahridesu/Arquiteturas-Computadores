	.data #"está no segmento de dados"
	
mensagem: .asciiz "Olá mundo" #"Diretiva"
	
	.text
	.globl main
main:	la $a0, mensagem
	ori $v0, $0, 4
	syscall
	jr $ra