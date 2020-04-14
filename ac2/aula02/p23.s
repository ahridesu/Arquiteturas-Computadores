.equ READ_CORE_TIMER,11
.equ RESET_CORE_TIMER,12
.equ PUT_CHAR,3
.equ PRINT_INT,6

.data
.text
.globl 	main

main:
while:	li		$v0,READ_CORE_TIMER # while (1) {
		syscall
		blt		$v0,10000000,while	# while(readCoreTimer() < 20000);
        li		$v0,RESET_CORE_TIMER
		syscall						# resetCoreTimer();		
        li		$a0,' '
		li		$v0,PUT_CHAR
		syscall						# putChar(' ');
        # ler valor dos switches
        lui     $t1,0xBF88
        lw      $t2,0x6050($t1)
        and		$t2,$t2,0x000F		# como só queremos o valor dos ultimos 4 bits(switches) o resto vai a 0
        # imprimir valores 		
        move	$a0,$t2
		li		$a1,2
		li		$v0,PRINT_INT
		syscall						# printInt(++counter, 10);
		j		while               # Não tem fim
		jr		$ra
