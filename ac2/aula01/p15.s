		.equ printInt,6
		.equ printInt10,7
		.equ printStr,8
		.equ readStr,9
		.equ STR_MAX_SIZE,20
		.data
intro:	.asciiz "Introduza 2 string: \n"
espaco:	.asciiz "\n"
resul:	.asciiz "Resultados:\n"
str1:	.space	STR_MAX_SIZE+1
str2:	.space	STR_MAX_SIZE+1
str3:	.space  2*STR_MAX_SIZE+1
		.text
		.globl main

main:	# 		salvaguarda registos
		subu	$sp,$sp,12
		sw 		$ra,0($sp)
		sw 		$s0,4($sp)
		sw 		$s1,8($sp)
		#		printStr("Introduza 2 strings: ")
		la		$a0,intro
		li		$v0,printStr
		syscall
		# 		readStr( str1, STR_MAX_SIZE );
		la		$a0,str1
		li		$a1,STR_MAX_SIZE
		li		$v0,readStr
		syscall
		move	$s0,$v0
		# 		mudança de linha acrescentada por mim
		la		$a0,espaco
		li		$v0,printStr
		syscall
		# 		readStr( str2, STR_MAX_SIZE );
		la		$a0,str2
		li		$a1,STR_MAX_SIZE
		li		$v0,readStr
		syscall
		move	$s1,$v0
		# 		mudança de linha acrescentada por mim
		la		$a0,espaco
		li		$v0,printStr
		syscall
		# 		printStr("Resultados:\n")
		la		$a0,resul
		li		$v0,printStr
		syscall
		# 		strlen(str1)
		la		$a0,str1
		jal		strln
		# 		prinInt( strlen(str1), 10 );
		move	$a0,$v0
		li 		$a1,10
		li 		$v0,printInt
		syscall
		# 		mudança de linha acrescentada por mim
		la		$a0,espaco
		li		$v0,printStr
		syscall
		# 		strlen(str2)
		la		$a0,str2
		jal		strln
		# 		prinInt( strlen(str2), 10 );
		move	$a0,$v0
		li 		$a1,10
		li 		$v0,printInt
		syscall
		# 		mudança de linha acrescentada por mim
		la		$a0,espaco
		li		$v0,printStr
		syscall
		# 		strcpy(str3, str1);
		la 		$a0,str3
		la 		$a1,str1
		jal		strcpy
		# 		strcat(str3, str2)
		la 		$a0,str3
		la 		$a1,str2
		jal		strcat
		#		printStr( strcat(str3, str2) );
		move	$a0,$v0
		li 		$v0,printStr
		syscall
		# 		mudança de linha acrescentada por mim
		la		$a0,espaco
		li		$v0,printStr
		syscall
		#		strcmp(str1, str2)
		la 		$a0,str1
		la 		$a1,str2
		jal		strcmp
		# 		printInt10( strcmp(str1, str2) );
		move 	$a0,$v0
		li 		$v0,printInt10
		syscall
		# 		reposição registos
		lw		$ra,0($sp)
		lw 		$s0,4($sp)
		lw 		$s1,8($sp)
		addiu	$sp,$sp,12
		# 		return 0
		li		$v0,0
		jr		$ra


# strlen: $a0=s, $v0=length, $t0 = *s 
strln:	li		$v0,0
strlnw:
		lb		$t0,0($a0)
		beq		$t0,0,endstrln
		addiu	$v0,$v0,1
		addiu	$a0,$a0,1
		j 		strlnw

endstrln:
		jr	$ra

# strcpy: $a0=dst, $a1=src, $v0=rp, $t0 = *src
strcpy:	move	$v0,$a0
strcpyw:
		lb		$t0,0($a1)
		sb 		$t0,0($a0)
		beq		$t0,0,endstrcpy
		addiu	$a0,$a0,1
		addiu	$a1,$a1,1
		j 		strcpyw

endstrcpy:
		jr	$ra

# strcat: $a0=dst, $a1=src, $s0=rp, $t0 = *src 
strcat:	# 		salvaguarda registos
		subu	$sp,$sp,8
		sw      $ra,0($sp)
		sw 		$s0,4($sp)
		move	$s0,$a0
strcatw:
		lb		$t0,0($a0)
		beq		$t0,0,endstrcat
		addiu	$a0,$a0,1
		j 		strcatw

endstrcat:
		jal		strcpy
		#		devolver *rp = dst
		move	$v0,$s0
		#		reposição de registos
		lw      $ra,0($sp)
		lw 		$s0,4($sp)
		addiu	$sp,$sp,8
		jr		$ra

# strcmp: $a0=s1, $a1=s2, $v0=rp, $t0=*s1, $t1=*s2
strcmp:	
strcmpw:
		lb		$t0,0($a0)
		lb 		$t1,0($a1)
		bne     $t0,$t1,endstrcmp	
		beq		$t0,0,endstrcmp		
		addiu	$a0,$a0,1
		addiu	$a1,$a1,1
		j 		strcmpw

endstrcmp:
		subu 	$v0,$t0,$t1
		jr		$ra
