	.data
	cr: 			.word	13
	lf:				.word	10
	so:				.word	14
	num:			.word	0	#Polinomial degree
	coeff_int:		.space	400	#Integer part of coeffs
	coeff_flt:		.space	400	#Fraction part of coeffs
	is_negative:	.word	0	#is negative flag
	ten:			.word	10
	new_line:		.asciiz	"\n"
	
	.text
start:
	la		$t5,coeff_int
	la		$t4,coeff_flt
	#input num
	jal		scan_int
	sw		$v0,num
	
	#take n+1 input for coeffs
	addi	$v0,$v0,1
	move	$t1,$v0
	move	$k0,$t1
	add		$t1,$t1,$t1
	add		$t1,$t1,$t1
	add		$t5,$t5,$t1
	add		$t4,$t4,$t1
	jal		nxt_line
scan_coeffs:
	jal		scan_float
	sw		$t2,0($t5)
	sw		$t3,0($t4)
	subi	$t5,$t5,4
	subi	$t4,$t4,4
	jal		nxt_line
	subi	$k0,$k0,1
	bne		$k0,$zero,scan_coeffs
	
	#scan is int
	jal		scan_int
	bne		$k0,$zero,compute_integral
compute_derivative:
	lw		$t8,num
	add		$t8,$t8,$t8
	add		$t8,$t8,$t8
	la		$t4,coeff_int
	la		$t5,coeff_flt
		multiply:
			lw		$t2,0($t4)
			lw		$t3,0($t5)
			jal		mul_float
			sw		$t2,0($t4)
			sw		$t3,0($t5)		
			subi	$t8,$t8,1
			bne		$t8,$zero,multiply
			j		print_result
			
compute_integral:
	lw		$t8,num
	add		$t8,$t8,$t8
	add		$t8,$t8,$t8
	la		$t4,coeff_int
	la		$t5,coeff_flt
		divide:
			lw		$t2,0($t4)
			lw		$t3,0($t5)
			jal		div_float
			sw		$t2,0($t4)
			sw		$t3,0($t5)		
			subi	$t8,$t8,1
			bne		$t8,$zero,divide
			
print_result:
	lw		$t8,num
	jal		nxt_line
	add		$t8,$t8,$t8
	add		$t8,$t8,$t8
	la		$t4,coeff_int
	la		$t5,coeff_flt
print_coeff:
	lw		$t2,0($t4)
	lw		$t3,0($t5)
	jal		print_float
stick1:
	jal		nxt_line
	subi	$t8,$t8,1
	bne		$t8,$zero,print_coeff
	
	li		$v0,10
	syscall	#stop running
	
	

# Multiply floating-point number with $t1
# $t2 : Integer part
# $t3 : Fraction part
# $t1 : To be multiplied with
mul_float:
	mult		$t2,$t1
	li		$t3,0
	jr		$ra
	
# Divide floating-point number with $t1
# $t2 : Integer part
# $t3 : Fraction part
# $t1 : To be divided by
div_float:
	div		$t2,$t1
	li		$t3,0
	jr		$ra
	
#prints integer in $a0 and fraction in $t3
print_float:
	#print integer part
	jal		print_num
	# if fraction part is zero no need to print																																																																											
	beq		$t3,$zero,done_pf
	#print dot
	li		$a0,'.'
	jal		write_char
	#print fraction part
	move	$a0,$t3
	jal		print_num
done_pf:
	j	stick1
	
	
	
	
#print char in $a0
write_char:
	move 	$s0,$v0	#push $v0
	li		$v0,11
	syscall
	move	$v0,$s0	#pop $v0
	jr	$ra #return
	
#print int in $a0
print_num:
	li	$v0,1
	syscall
	jr	$ra
	
# print string with address in $a0
puts:
	li	$v0,4
	syscall
	jr	$ra
	
#store input char in $v0	
read_char:
	li		$v0,12
	syscall
	jr		$ra	#return

#integer part in $t2, frac part in $t3	
scan_float:
	li		$t3,0
	jal		scan_int
	move	$t2,$t8
	jr		$ra

#store input in $t1
scan_int:
	li		$t1,0
	#negative flag
	sw		$zero,is_negative
	next_digit:
		jal		read_char
		#check if is negative
		li		$a2,'-'
		beq		$v0,$a2,set_minus
		#check if should stop input
		lw		$a2,cr
		beq		$v0,$a2,stop_input
		li		$a2,'.'
		beq		$v0,$a2,stop_input
		li		$a2,' '
		beq		$v0,$a2,stop_input
		
		#add digit to $t1
		lw		$t7,ten
		mult	$t7,$t1
		mflo	$t1
		subi	$v0,$v0,48 #convert from ascii
		add		$t1,$t1,$v0
		j		next_digit
set_minus:
		li		$a3,1
		sw		$a3,is_negative
		j		next_digit
		
stop_input:
		lw		$a3,is_negative
		beq		$a3,$zero,not_negative
		mul		$t1,$t1,-1
not_negative:
		jr		$ra
		
	
	
nxt_line:
	move 	$s0,$a0	#push $a0
	move 	$s1,$v0	#push $v0
	la	$a0,new_line
	li	$v0,4
	syscall
	move	$a0,$s0	#pop $a0
	move	$v0,$s1	#pop $v0
	jr	$ra #return	
		
				
