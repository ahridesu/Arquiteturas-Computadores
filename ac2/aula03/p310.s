.equ	TRISE,0x6100
.equ	PORTE,0x6110
.equ	LATE,0x6120
.equ	TRISB,0x6040
.equ	PORTB,0x6050
.equ	LATB,0x6060
.equ 	READ_CORE_TIMER,11
.equ 	RESET_CORE_TIMER,12
.equ 	PRINT_INT,6

.data
.text
.globl 	main
		# contador Johnson 4 bits, actualizado a 1.5Hz, controlado por RB2  
main:	# salvaguarda de registos
		subu	$sp,$sp,8
		sw		$ra,0($sp)
		sw		$s0,4($sp)
		# mapeamento no espaço de memória SFR
		lui		$t1,SFR_BASE_HI
		# programar RE0-3 para saida
		lw		$t1,TRISE($s0)
		andi	$t1,$t1,0xFFF0
		sw		$t1,TRISE($s0)
		# programar RB0-3 como entrada
		lw		$t1,TRISB($s0)
		ori		$t1,$t1,0x000F
		sw		$t1,TRISB($s0)
while:
		# funcionamento a 1.5 Hz
		li 		$a0,750
		jal 	delay
		# "pegar" em RE0-3
		lw		$t1,LATE($s0)
		# ler valor de RB3
		lw		$t3,PORTB($s0)
		andi	$t3,$t3,0x0004
		beqz	$t3,direita
		# "pegar" nos bits menos signidicativos
		andi	$t2,$t1,0x0007
		# "pegar" no bit mais significativo e inverter
		andi	$t3,$t1,0x0008
		beqz	$t3,else0
		li 		$t3,0
		j 		endif0
else0:
		li 		$t3,1
endif0:
		sll 	$t2,$t2,1
		or		$t2,$t2,$t3
		j 		save

direita:
		# "pegar" nos bits menos signidicativos
		andi	$t2,$t1,0x000E
		# "pegar" no bit menos significativo e inverter
		andi	$t3,$t1,0x0001
		beqz	$t3,else1
		li 		$t3,0
		j 		endif1
else1:
		li 		$t3,8
endif1:
		srl 	$t2,$t2,1
		or		$t2,$t2,$t3

save:
		# "enviar" para leds
		sb     $t2,LATE($s0)
		j  		while
		# repor registos
		lw		$ra,0($sp)
		lw		$s0,4($sp)
		addiu	$sp,$sp,8
		jr		$ra

delay:
		ble		$a0,0,endfor
		li		$v0,RESET_CORE_TIMER
		syscall
while2:	li		$v0,READ_CORE_TIMER 
		syscall
		blt		$v0,20000,while2	# 1 ms	
		subu	$a0,$a0,1
		j 		delay

endfor:	
		jal		$ra
