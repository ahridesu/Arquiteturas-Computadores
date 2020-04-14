	.data
	.text
	.globl main #tradução para gray
main:	li  $t0,0x862A5C1B
	srl $t1,$t0,1
	xor $t1,$t1,$t0
	jr  $ra
