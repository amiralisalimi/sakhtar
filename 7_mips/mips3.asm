		.data
so:			.word		14
cr:			.word		13
lf:			.word		10
max_number:	.word		400
is_prime:	.space		400
inp:		.word		0
ten:		.word		10
new_line:	.asciiz		"\n"

			.text
			
start:
		li		$s5,4
		jal		is_prime_initial
		jal		eratost
stick1:
		jal		scan_int
		move	$t1,$v0
stick2:
		jal		nxt_line
		mul		$t1,$t1,4
		sw		$t1,inp
		li		$t8,8	#bx
	outer:
		addi	$t8,$t8,8
		lw		$t7,inp
		bgt		$t8,$t7,done
		la		$s7,is_prime
		addi	$s7,$s7,4
	inner:
		addi	$s7,$s7,4
		lw		$t6,0($s7)
		beq		$t6,$zero,inner
		la		$t5,is_prime
		sub		$a1,$s7,$t5
		move	$t9,$a1	#di
		neg		$t9,$t9
		add		$a2,$t8,$t9
		add		$t5,$t5,$a2
		lw		$a3,0($t5)
		beq		$a3,$zero,inner
		move	$s0,$t0
		div		$t8,$s5
		mflo	$s4
		move	$t0,$s4
		move	$a0,$t0
		jal		print_pos
		move	$t0,$s0
		li		$a0,'='
		jal		write_char
		li		$s2,4
		la		$s1,is_prime
		sub		$a3,$s7,$s1
		div		$a3,$s2
		mflo	$s3
		move	$s0,$t0
		move	$t0,$s3
		move	$a0,$t0
		jal		print_pos
		move	$t0,$s0
		li		$a0,'+'
		jal		write_char
		move	$s0,$t0
		div		$t8,$s5
		mflo	$s4
		move	$t0,$s4
		sub		$t0,$t0,$s3
		#jal		print_pos3
		move	$a0,$t0
		jal		print_pos
		move	$t0,$s0
		jal		nxt_line
		subi	$t1,$t1,1
		bne		$t1,$zero,outer
	done:
		li		$v0,10
		syscall	#stop running
		
				
# Initialize 1 to each is_prime member					
is_prime_initial:
	la		$t0,is_prime
	li		$t1,100
	li		$t2,1
p:
	sw		$t2,0($t0)
	addi	$t0,$t0,4
	subi	$t1,$t1,1
	bne		$t1,$zero,p
	jr		$ra		
	
										
eratost:
	la		$t0,is_prime
	sw		$zero,0($t0)
	addi	$t0,$t0,4
	sw		$zero,0($t0)
	addi	$t0,$t0,4
	li		$t9,4
	outer_erat:
		addi	$t9,$t9,4
		lw		$t8,max_number
		bge		$t9,$t8,erat_done
		move	$t2,$t9
	inner_erat:
		add		$t2,$t2,$t9
		lw		$t8,max_number
		bge		$t2,$t8,outer_erat
		la		$t0,is_prime
		add		$t0,$t0,$t2
		sw		$zero,0($t0)
		j		inner_erat
	erat_done:
		j		stick1
		


#store input char in $v0	
read_char:
	li		$v0,12
	syscall
	jr		$ra	#return
	
	
#store input in $v0
scan_int:
	li	$v0,5
	syscall
	jr	$ra
		
		
nxt_line:
	move 	$s0,$a0	#push $a0
	move 	$s1,$v0	#push $v0
	la	$a0,new_line
	li	$v0,4
	syscall
	move	$a0,$s0	#pop $a0
	move	$v0,$s1	#pop $v0
	jr	$ra #return
	
	
# prints positive number in $a0	
print_pos:
	li		$v0,1
	syscall
	jr		$ra
		
		
#print char in $a0
write_char:
	move 	$s0,$v0	#push $v0
	li		$v0,11
	syscall
	move	$v0,$s0	#pop $v0
	jr	$ra #return
																			

															
																														
																																													
																																																												
																																																																											
																																																																																																								