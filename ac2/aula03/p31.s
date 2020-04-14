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
		andi	$t2,$t2,0xFFFE
		sw		$t2,TRISE($t1)
		# programar RB0 como entrada
		lw		$t2,TRISB($t1)
		ori		$t2,$t2,0x0001
		sw		$t2,TRISB($t1)
		
		# ciclo infinito
while:	
		# ler de RB0 
		lw		$t2,PORTB($t1)
		and 	$t2,$t2,0x0001
		# "pegar" em RE0 
		lw		$t3,LATE($t1)
		# if(RB0==0)
		beq		$t2,1,else		
		and 	$t3,$t3,0xFFFE
		j 		endif
else:					
		or 		$t3,$t3,$t2
endif:			
		# guardar em RE0
		sw		$t3,LATE($t1)
		j		while               
		jr		$ra
