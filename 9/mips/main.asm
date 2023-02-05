	.data
input:		.space	400
digits:		.space	400
new_line:	.asciiz	"\n"
sizeCounter:	.word	0

	.text
main:

	jal		get_input
l1:
	jal		nxt_line
	jal		counter
l2:
	move	$a0,$a2
	sw		$a0,sizeCounter
	jal		print_num
	jal		nxt_line
	jal		sort
	jal		final_print
	
	
	

#stor input char in $v0	
read_char:
	li		$v0,12
	syscall
	jr		$ra	#return
	

nxt_line:
	move 	$s0,$a0	#push $a0
	move 	$s1,$v0	#push $v0
	la	$a0,new_line
	li	$v0,4
	syscall
	move	$a0,$s0	#pop $a0
	move	$v0,$s1	#pop $v0
	jr	$ra #return
	
	
#print char in $a0
print_char:
	move 	$s0,$v0	#push $v0
	li		$v0,11
	syscall
	move	$v0,$s0	#pop $v0
	jr	$ra #return
	
	
get_input:
	move	$s0,$v0	#push $v0
	move	$s1,$t1	#push $t1
	move	$s2,$a2	#push $a2	
	la	$t1,input
	li	$a2,10	#Enter
	
	loop1:
		jal		read_char
		sw		$v0,0($t1)
		addi	$t1,$t1,4	#next index
		beq		$v0,$a2,end	#if not Enter get next input
		j		loop1
		
	end:
		move	$v0,$s0	#pop $v0
		move	$t1,$s1	#pop $t1
		move	$a2,$s2	#pop $a2
		j		l1
		
		
counter:
	li	$a1,10	#Enter
	li	$s2,40	#(
	li	$s3,41	#)
	li	$a2,0	#counter
	li	$a3,0
	li	$t3,0
	li	$t4,0
	li	$t5,0
	li	$t6,0
	la	$t1,input
	la	$t2,input
	la	$t4,input
	la	$t3,digits
	li	$k0,4
	loop2:
		lw	$v1,0($t1)
		beq	$v1,$a1,end1
		beq	$v1,$s2,mov
		beq	$v1,$s3,increment
		beq	$v1,$zero,increment
		
	loop3:
		lw	$k1,0($t2)
		beq	$k1,$a1,increment
		beq	$k1,$zero,increment1
		beq	$k1,$s2,increment1
		beq	$k1,$s3,index
		addi	$t2,$t2,4	#next index
		j	loop3
		
	index:
		addi	$t1,$t1,4
		sub		$s7,$t1,$t4
		div		$s7,$k0
		mflo	$s7		#index of input array
		sw		$s7,0($t3)
		addi	$a2,$a2,1
		addi	$t3,$t3,4
		addi	$t2,$t2,4
		sub		$s7,$t2,$t4
		div		$s7,$k0
		mflo	$s7	
		sw		$s7,0($t3)
		subi	$t2,$t2,4
		sw		$zero,0($t2)
		addi	$t2,$t2,4
		addi	$a2,$a2,1
		addi	$t3,$t3,4
		j		loop2
		
	mov:
		move	$t2,$t1
		j		loop3
		
	increment:
		addi	$t1,$t1,4
		j		loop2
		
	increment1:
		addi	$t2,$t2,4
		j		loop3
		
	end1:
		j		l2
		
		
#print int in $a0
print_num:
	li	$v0,1
	syscall
	jr	$ra
		
		

final_print:
	li	$t7,' '	#make space between nums
	li	$t8,400
	la	$t0,digits
	la	$t1,digits
		loopp:
			sub		$t9,$t0,$t1
			beq		$t9,$t8,printEnd
			lw		$a0,0($t0)
			bne		$a0,$zero,pr1
			addi	$t0,$t0,4
			j		loopp
			
		pr1:
			jal		print_num
			move	$a0,$t7
			jal		print_char
			addi	$t0,$t0,4
			j		loopp
			
		printEnd:
			li		$v0,10 #Stop program 
			syscall
			
			
			
sort:
	lw		$t6,sizeCounter
	move	$t9,$t6
	up2:
		move	$t8,$t6
		la		$t0,digits
	up1:
		lw		$t6,0($t0)
		addi	$t0,$t0,4
		lw		$t7,0($t0)
		subi	$t0,$t0,4	
		bgt		$t7,$t6,down
		addi	$t0,$t0,4
		lw		$t5,0($t0)
		subi	$t0,$t0,4
		lw		$t4,0($t0)
		sw		$t5,0($t0)
		move	$t5,$t4
		addi	$t0,$t0,4
		sw		$t5,0($t0)
		subi	$t0,$t0,4
		
	down:
		addi	$t0,$t0,4
		subi	$t8,$t8,1
		bne		$t8,$zero,up1
		subi	$t9,$t9,1
		bne		$t9,$zero,up2
		jr		$ra	#return	

    
			
		
		
		
		
				
