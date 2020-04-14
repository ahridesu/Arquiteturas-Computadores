	.data
array:	.space	50
str0:	.asciiz "Size of array : "
str1:	.asciiz "array["
str2:	.asciiz "] = "
str3:	.asciiz "Enter the value to be inserted: "
str4:	.asciiz "Enter the position: "
str5:	.asciiz "\nOriginal array: "
str6:	.asciiz "\nModified array: "
str7:	.asciiz ", "
str8:	.asciiz "\nErro: posição inserida > size!"
	.eqv	print_string,4
	.eqv	read_int,5
	.eqv	print_int10,1
	.text
	.globl main
	# 
main:	la	$a0,str0
	li	$v0,print_string
	syscall
	li	$v0,read_int
	syscall
	move	$t1,$v0			# $t1 = array_size
	li	$t0,0			# $t0 = i = 0
	la	$t4,array		# $t4 = &array
	
for:	bge	$t0,$t1,endfor
	la	$a0,str1
	li	$v0,print_string
	syscall
	move	$a0,$t0
	li	$v0,print_int10
	syscall
	la	$a0,str2
	li	$v0,print_string
	syscall
	li	$v0,read_int
	syscall
	sll	$t2,$t0,2
	addu	$t2,$t2,$t4
	sw	$v0,0($t2)
	addiu	$t0,$t0,1
	j	for
	
endfor:	la	$a0,str3
	li	$v0,print_string
	syscall
	li	$v0,read_int
	syscall
	move	$t2,$v0			# $t2 = insert_value
	la	$a0,str4
	li	$v0,print_string
	syscall
	li	$v0,read_int
	syscall
	move	$t3,$v0			# $t3 = insert_pos
	la	$a0,str5
	li	$v0,print_string
	syscall
	#	começo da chamada de sub-rotinas
	subiu	$sp,$sp,16
	sw	$s1,0($sp)
	sw	$s2,4($sp)
	sw	$s3,8($sp)
	sw	$ra,12($sp)
	move	$s1,$t1
	move	$s2,$t2
	move	$s3,$t3
	move	$a0,$t4
	move	$a1,$t1
	jal	print_array
	la	$a0,array
	move	$a1,$s2
	move	$a2,$s3
	move	$a3,$s1
	jal	insert
	beq	$v0,1,erro
	la	$a0,str6
	li	$v0,print_string
	syscall
	la	$a0,array
	move	$a1,$s1
	addiu	$a1,$a1,1
	jal	print_array
	li	$v0,0
	j	end	
	
erro:	la	$a0,str8			# modificação para não poder inserir após size
	li	$v0,print_string
	syscall
	li	$v0,-1
	
end:	lw	$s1,0($sp)		
	lw	$s2,4($sp)
	lw	$s3,8($sp)
	lw	$ra,12($sp)
	addiu	$sp,$sp,16
	jr	$ra
	
	#insert	(int *array, int value, int pos, int size) 
insert:	ble	$a2,$a3,else
	li	$v0,1
	jr	$ra

else:	move	$t0,$a3		# i = size 
	subiu	$t0,$t0,1	# i = size - 1
for1:	blt	$t0,$a2,endfor1	
	sll	$t1,$t0,2
	addu	$t1,$t1,$a0
	lw	$t2,0($t1)
	sw	$t2,4($t1)
	subiu	$t0,$t0,1
	j	for1
endfor1:
	sll	$t0,$a2,2
	addu	$t0,$t0,$a0
	sw	$a1,0($t0)
	li	$v0,0
	jr	$ra
	
	#print_array(int *a, int n)
print_array:
	move	$t0,$a0			# $t0 = *a
	sll	$t1,$a1,2		
	addu	$t1,$t1,$t0		# $t2 = *p
	li	$t3,0			# modificação para não imprimir ultima virgula
for2:	bge	$t0,$t1,endfor2
	beqz	$t3,mod	
	la	$a0,str7
	li	$v0,print_string
	syscall
mod:	li	$t3,1
	lw	$a0,0($t0)
	li	$v0,print_int10
	syscall
	addiu	$t0,$t0,4
	j	for2
endfor2:
	jr	$ra
