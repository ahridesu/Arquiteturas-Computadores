.equ 	SFR_BASE_HI,0xBF88
.equ	TRISE,0x6100
.equ	PORTE,0x6110
.equ	LATE,0x6120
.equ	TRISB,0x6040
.equ	PORTB,0x6050
.equ	LATB,0x6060
.equ 	PRINT_INT,6

.data
.text
.globl 	main

main:	# mapeamento no espaço de memória SFR
		lui		$t1,SFR_BASE_HI
		# programar RE0 para saida
		lw		$t2,TRISE($t1)
		andi	$t2,$t2,0xFFF0
		sw		$t2,TRISE($t1)
		# programar RB0 como entrada
		lw		$t2,TRISB($t1)
		ori		$t2,$t2,0x000F
		sw		$t2,TRISB($t1)	
		# ciclo infinito
while:	
		# ler de RB0-3 
		lw		$t2,PORTB($t1)
		lw 		$t3,LATE($t1)
		# "pegar" em RE0-3
		sb 		$t2,LATE($t1)
		lw 		$t3,LATE($t1)		
		j		while               
		jr		$ra

