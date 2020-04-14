.equ READ_CORE_TIMER,11
.equ RESET_CORE_TIMER,12
.equ PUT_CHAR,3
.equ PRINT_INT,6

.data
.text
.globl 	main

main: 	li		$t0,0
while:	li		$v0,READ_CORE_TIMER # while (1) {
		syscall
		blt		$v0,20000000,while	# while(readCoreTimer() < 20000);
		li		$a0,' '
		li		$v0,PUT_CHAR
		syscall						# putChar(' ');
		addi	$t0,$t0,1
		move	$a0,$t0
		li		$a1,10
		li		$v0,PRINT_INT
		syscall						# printInt(++counter, 10);
		#		salvaguarda registo
		subu	$sp,$sp,4           # stack Point = 4
		sw		$ra,0($sp)          
		li	 	$a0,5000            # 5000 pq sim, são 5s
		jal		delay               # Bora para a função delay
		lw		$ra,0($sp)          
		addiu	$sp,$sp,4           #Repor
		li		$v0,RESET_CORE_TIMER
		syscall						# resetCoreTimer();
		j		while               # Não tem fim
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
