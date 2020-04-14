	.data
	.text
	.globl main #gray->binário
main:	li  $t0,0xC53F7216
	or  $t1,$0,$t0
	srl $t3,$t1,4
	xor $t1,$t1,$t3
	srl $t3,$t1,2
	xor $t1,$t1,$t3
	srl $t3,$t1,1
	xor $t1,$t1,$t3
	or  $t2,$0,$t1
	jr  $ra
	# 0x862A5C1B
	# algo esta mal neste!