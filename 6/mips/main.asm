	.data
	line1:	.space	400
	line2:	.space	400
	line3:	.space	400
	input:	.space	400
	ans_line1:	.space	400
	size_of_word:	.space	400
	ans_line2:	.space	400
	size_of_word2:	.space	400
	ans_line3:	.space	400
	size_of_word3:	.space	400
	index:	.word	5
	new_line:	.asciiz	"\n"
	large_index: .word	0
	
	.text
start:
	jal		get_char1_input
stick1:
	jal		get_char2_input
stick2:
	jal		get_char3_input
stick3:
	jal		get_input
stick4:
	jal		find_answers1
stick5:
	jal		find_size
stick6:
	jal		find_largest
stick7:
	jal		find_largestNum_index
stick8:
	jal		print_final
stick9:
	jal		nxt_line
	jal		find_answers2
stick10:
	jal		find_size2
stick12:
	jal		find_largest2
stick11:
	jal		find_largestNum_index2
stick13:
	jal		print_final2
stick14:
	jal		nxt_line
	jal		find_answers3
stick15:
	jal		find_size3
stick17:
	jal		find_largest3
stick16:
	jal		find_largestNum_index3
stick18:
	jal		print_final3
stick19:
	jal		nxt_line
	li		$v0,10 #Stop program 
			syscall



#store input char in $v0	
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
	
	
get_char1_input:
	li	$t1,10	#Enter
	li	$t2,' '	#Space
	la	$t0,line1
	next_char1:
		jal		read_char
		beq		$v0,$t1,end1
		beq		$v0,$t2,next_char1
		sw 		$v0,0($t0)
		addi	$t0,$t0,4
		j		next_char1
		
	end1:
		j		stick1
		
		
		
get_char2_input:
	li	$t1,10	#Enter
	li	$t2,' '	#Space
	la	$t0,line2
	next_char2:
		jal		read_char
		beq		$v0,$t1,end2
		beq		$v0,$t2,next_char2
		sw 		$v0,0($t0)
		addi	$t0,$t0,4
		j		next_char2
		
	end2:
		j		stick2
		
		
		
get_char3_input:
	li	$t1,10	#Enter
	li	$t2,' '	#Space
	la	$t0,line3
	next_char3:
		jal		read_char
		beq		$v0,$t1,end3
		beq		$v0,$t2,next_char3
		sw 		$v0,0($t0)
		addi	$t0,$t0,4
		j		next_char3
		
	end3:
		j		stick3
		
		
get_input:
	li	$t1,10	#Enter
	la	$t0,input
	next_char4:
		jal		read_char
		beq		$v0,$t1,end4
		sw		$v0,0($t0)
		addi	$t0,$t0,4
		j		next_char4
		
	end4:
		j		stick4
		
		
find_answers1:
	la	$t0,input
	la	$t2,line1
	la	$t5,ans_line1
	li	$t9,0
	loop1:
		lw		$t1,0($t0)
		beq		$t1,$zero,end5
		
	main:
		lw		$t3,0($t2)
		lw		$t4,0($t0)
		beq		$t3,$t4,assignment
		addi	$t2,$t2,4
		lw		$t3,0($t2)
		beq		$t3,$zero,label1
		j		loop1
		
	assignment:
		beq		$t9,$zero,zero
		lw		$t4,0($t0)
		sw		$t4,0($t5)
		addi	$t5,$t5,4
		addi	$t0,$t0,4
		j		loop1
		
	label1:
		la		$t2,line1
		addi	$t5,$t5,4
		
	loop2:
		lw		$t3,0($t0)
		lw		$t1,0($t2)
		beq		$t1,$t3,assignment
		addi	$t2,$t2,4
		lw		$t8,0($t2)
		bne		$t8,$zero,loop2
		addi	$t0,$t0,4
		la		$t2,line1
		j		main
		
	end5:
		j		stick5
		
	zero:
		li		$t9,1
		la		$t5,ans_line1
		j		assignment
		
		
		
find_largest:
	li		$t9,100
	li		$t8,0
	la		$t0,size_of_word
	up:
		lw		$t1,0($t0)
		bgt		$t8,$t1,nxt
		move	$t8,$t1
	nxt:
		addi	$t0,$t0,4
		subi	$t9,$t9,1
		bne		$t9,$zero,up
		sw		$t8,large_index
		j		stick7
		
		
find_size:
	
	li	$t7,0	#cx
	li	$t3,400
	la	$t0,ans_line1
	la	$t9,ans_line1
	la	$t1,size_of_word
	loop3:
		sub		$a1,$t0,$t9
		beq		$a1,$t3,end7
		lw		$t8,0($t0)
		beq		$t8,$zero,lbl1
		addi	$t7,$t7,1
		addi	$t0,$t0,4
		j		loop3
		
	lbl1:
		addi	$t0,$t0,4
		bne		$t7,$zero,lbl2
		j		loop3
		
	lbl2:
		sw		$t7,0($t1)
		addi	$t1,$t1,4
		li		$t7,0
		j		loop3
		
	end7:
		j		stick6
		
		
		
find_largestNum_index:
	li		$t6,4
	la		$t0,size_of_word
	lw		$t9,large_index
	li		$t8,0
	l2:
		lw		$t1,0($t0)
		beq		$t1,$t9,pEnd
		addi	$t0,$t0,4
		j		l2
		
	pEnd:
		la		$t5,size_of_word
		sub		$a1,$t0,$t5
		div		$a1,$t6
		mflo	$s7
		sw		$s7,index
		j		stick8
		
		
		
print_final:
	la		$t0,ans_line1
	subi	$t0,$t0,4
	lw		$t8,index
	beq		$t8,$zero,printEnd
	
	l3:
		addi	$t0,$t0,4
		lw		$t7,0($t0)
		beq		$t7,$zero,decre
		j		l3
		
	decre:
		addi	$t0,$t0,4
		lw		$t7,0($t0)
		subi	$t0,$t0,4
		bne		$t7,$zero,l4
		j		l3
		
	l4:
		subi	$t8,$t8,1
		beq		$t8,$zero,printEnd
		j		l3
	printEnd:
		addi	$t0,$t0,4
		lw		$t7,0($t0)
		beq		$t7,$zero,end6
		move	$a0,$t7
		jal		print_char
		j		printEnd
		
	end6:
		j		stick9
		
		
		
find_answers2:
	la	$t0,input
	la	$t2,line2
	la	$t5,ans_line2
	li	$t9,0
	loopp1:
		lw		$t1,0($t0)
		beq		$t1,$zero,endd5
		
	mainn:
		lw		$t3,0($t2)
		lw		$t4,0($t0)
		beq		$t3,$t4,assignmentt
		addi	$t2,$t2,4
		lw		$t3,0($t2)
		beq		$t3,$zero,labell1
		j		loopp1
		
	assignmentt:
		beq		$t9,$zero,zeroo
		lw		$t4,0($t0)
		sw		$t4,0($t5)
		addi	$t5,$t5,4
		addi	$t0,$t0,4
		j		loopp1
		
	labell1:
		la		$t2,line2
		addi	$t5,$t5,4
		
	loopp2:
		lw		$t3,0($t0)
		lw		$t1,0($t2)
		beq		$t1,$t3,assignmentt
		addi	$t2,$t2,4
		lw		$t8,0($t2)
		bne		$t8,$zero,loopp2
		addi	$t0,$t0,4
		la		$t2,line2
		j		mainn
		
	endd5:
		j		stick10
		
	zeroo:
		li		$t9,1
		la		$t5,ans_line2
		j		assignmentt
		
		
		
find_largest2:
	li		$t9,100
	li		$t8,0
	la		$t0,size_of_word2
	upp:
		lw		$t1,0($t0)
		bgt		$t8,$t1,nxtt
		move	$t8,$t1
	nxtt:
		addi	$t0,$t0,4
		subi	$t9,$t9,1
		bne		$t9,$zero,upp
		sw		$t8,large_index
		j		stick11
		
		
find_size2:
	
	li	$t7,0	#cx
	li	$t3,400
	la	$t0,ans_line2
	la	$t9,ans_line2
	la	$t1,size_of_word2
	loopp3:
		sub		$a1,$t0,$t9
		beq		$a1,$t3,endd7
		lw		$t8,0($t0)
		beq		$t8,$zero,lbll1
		addi	$t7,$t7,1
		addi	$t0,$t0,4
		j		loopp3
		
	lbll1:
		addi	$t0,$t0,4
		bne		$t7,$zero,lbll2
		j		loopp3
		
	lbll2:
		sw		$t7,0($t1)
		addi	$t1,$t1,4
		li		$t7,0
		j		loopp3
		
	endd7:
		j		stick12
		
		
		
find_largestNum_index2:
	li		$t6,4
	la		$t0,size_of_word2
	lw		$t9,large_index
	li		$t8,0
	ll2:
		lw		$t1,0($t0)
		beq		$t1,$t9,pEndd
		addi	$t0,$t0,4
		j		ll2
		
	pEndd:
		la		$t5,size_of_word2
		sub		$a1,$t0,$t5
		div		$a1,$t6
		mflo	$s7
		sw		$s7,index
		j		stick13
		
		
		
print_final2:
	la		$t0,ans_line2
	subi	$t0,$t0,4
	lw		$t8,index
	beq		$t8,$zero,printEndd
	
	ll3:
		addi	$t0,$t0,4
		lw		$t7,0($t0)
		beq		$t7,$zero,decree
		j		ll3
		
	decree:
		addi	$t0,$t0,4
		lw		$t7,0($t0)
		subi	$t0,$t0,4
		bne		$t7,$zero,ll4
		j		ll3
		
	ll4:
		subi	$t8,$t8,1
		beq		$t8,$zero,printEndd
		j		ll3
	printEndd:
		addi	$t0,$t0,4
		lw		$t7,0($t0)
		beq		$t7,$zero,endd6
		move	$a0,$t7
		jal		print_char
		j		printEndd
		
	endd6:
		j		stick14
		
		
		
				
	
		
find_answers3:
	la	$t0,input
	la	$t2,line3
	la	$t5,ans_line3
	li	$t9,0
	looppp1:
		lw		$t1,0($t0)
		beq		$t1,$zero,enddd5
		
	mainnn:
		lw		$t3,0($t2)
		lw		$t4,0($t0)
		beq		$t3,$t4,assignmenttt
		addi	$t2,$t2,4
		lw		$t3,0($t2)
		beq		$t3,$zero,labelll1
		j		looppp1
		
	assignmenttt:
		beq		$t9,$zero,zerooo
		lw		$t4,0($t0)
		sw		$t4,0($t5)
		addi	$t5,$t5,4
		addi	$t0,$t0,4
		j		looppp1
		
	labelll1:
		la		$t2,line3
		addi	$t5,$t5,4
		
	looppp2:
		lw		$t3,0($t0)
		lw		$t1,0($t2)
		beq		$t1,$t3,assignmenttt
		addi	$t2,$t2,4
		lw		$t8,0($t2)
		bne		$t8,$zero,looppp2
		addi	$t0,$t0,4
		la		$t2,line3
		j		mainnn
		
	enddd5:
		j		stick15
		
	zerooo:
		li		$t9,1
		la		$t5,ans_line3
		j		assignmenttt
		
		
		
find_largest3:
	li		$t9,100
	li		$t8,0
	la		$t0,size_of_word3
	uppp:
		lw		$t1,0($t0)
		bgt		$t8,$t1,nxttt
		move	$t8,$t1
	nxttt:
		addi	$t0,$t0,4
		subi	$t9,$t9,1
		bne		$t9,$zero,uppp
		sw		$t8,large_index
		j		stick16
		
		
find_size3:
	
	li	$t7,0	#cx
	li	$t3,400
	la	$t0,ans_line3
	la	$t9,ans_line3
	la	$t1,size_of_word3
	looppp3:
		sub		$a1,$t0,$t9
		beq		$a1,$t3,enddd7
		lw		$t8,0($t0)
		beq		$t8,$zero,lblll1
		addi	$t7,$t7,1
		addi	$t0,$t0,4
		j		looppp3
		
	lblll1:
		addi	$t0,$t0,4
		bne		$t7,$zero,lblll2
		j		looppp3
		
	lblll2:
		sw		$t7,0($t1)
		addi	$t1,$t1,4
		li		$t7,0
		j		looppp3
		
	enddd7:
		j		stick17
		
		
		
find_largestNum_index3:
	li		$t6,4
	la		$t0,size_of_word3
	lw		$t9,large_index
	li		$t8,0
	lll2:
		lw		$t1,0($t0)
		beq		$t1,$t9,pEnddd
		addi	$t0,$t0,4
		j		lll2
		
	pEnddd:
		la		$t5,size_of_word3
		sub		$a1,$t0,$t5
		div		$a1,$t6
		mflo	$s7
		sw		$s7,index
		j		stick18
		
		
		
print_final3:
	la		$t0,ans_line3
	subi	$t0,$t0,4
	lw		$t8,index
	beq		$t8,$zero,printEnddd
	
	lll3:
		addi	$t0,$t0,4
		lw		$t7,0($t0)
		beq		$t7,$zero,decreee
		j		lll3
		
	decreee:
		addi	$t0,$t0,4
		lw		$t7,0($t0)
		subi	$t0,$t0,4
		bne		$t7,$zero,lll4
		j		lll3
		
	lll4:
		subi	$t8,$t8,1
		beq		$t8,$zero,printEnddd
		j		lll3
	printEnddd:
		addi	$t0,$t0,4
		lw		$t7,0($t0)
		beq		$t7,$zero,enddd6
		move	$a0,$t7
		jal		print_char
		j		printEnddd
		
	enddd6:
		j		stick19
		

		
		
		
