.equ 	SFR_BASE_HI,0xBF88
.equ	TRISE,0x6100
.equ	PORTE,0x6110
.equ	LATE,0x6120
.equ 	READ_CORE_TIMER,11
.equ 	RESET_CORE_TIMER,12	
.equ 	PRINT_INT,6

.data
.text
.globl 	main

main:	# salvaguarda (só para te chatear Mariana ;) ) de registos
		subu	$sp,$sp,12
		sw		$ra,0($sp)
		sw		$s0,4($sp)
		sw		$s1,8($sp)
		# mapeamento no espaço de memória SFR
		lui		$s1,SFR_BASE_HI
		# programar RE0 para saida
		lw		$t1,TRISE($s1)
		andi	$t1,$t1,0xFFFE
		sw		$t1,TRISE($s1)
		#		int v = 0
		li 		$s0,0
		#		while(1)
while:	
		# LATE0 = v;
		# "pegar" em RE0 
		lw		$t1,LATE($s1)
		# if(RE0==0)
		beq		$s0,1,else		
		and 	$t1,$t1,0xFFFE
		j 		endif
else:					
		or 		$t1,$t1,$s0
endif:
		sw		$t1,LATE($s1)
		#		delay(500)
		li 		$a0,500
		jal		delay
		#		v^=1
		xor		$s0,$s0,1
		#		final do while
		j		while
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
