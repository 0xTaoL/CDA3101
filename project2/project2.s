.data
	msgX: 		.asciiz 	"Enter the first integer x: "
	msgK:  		.asciiz 	"Enter the second integer k: "
	msgN:  		.asciiz 	"Enter the third integer n: "
	msgResult:	.asciiz		"The result of x^k mod n = "
	x:			.word		0
	k:			.word		0
	n:			.word		0

.text
.globl main
main:				
	la $a0, msgX		# printf("Enter the first integer x: ");
	li $v0, 4
	syscall

	li $v0, 5			# scanf("%d", &x);
	syscall
	sw $v0, x

	la $a0, msgK		# printf("Enter the second integer k: ");
	li $v0, 4
	syscall

	li $v0, 5			# scanf("%d", &k);
	syscall
	sw $v0, k

	la $a0, msgN		# printf("Enter the third integer n: ")
	li $v0, 4
	syscall

	li $v0, 5			# scanf("%d", &n);
	syscall
	sw $v0, n

	lw $a0, x 			# load x, k , n
	lw $a1, k
	lw $a2, n

	jal fme
						
	li $v0, 4			# printf("The result of x^k mod n = ")
	la $a0, msgResult
	syscall
						
	li $v0, 1			# print answer
	la $a0, ($t2)
	syscall
						
	li $v0, 10			# exit program
	syscall

.globl fme
fme:
	subu $sp, $sp, 8    	# subtract 8 from stack	for 2 words
	sw 	 $ra, ($sp)       	# store return address value
	sw 	 $a1, 4($sp)		
	li 	 $t0, 1           	# int result = 1;	

	# base case
	blez $a1, expZero			# if (k <= 0) branch to expZero
	li 	 $t5, 2        		
	div	 $a1, $t5     		# k = k / 2
	mflo $a1         		

	# recursive case
	jal fme

	div  $a1, $t5			
	mfhi $t1                # if (k % 2 == 1)
	beq  $t1, $zero, even 	# jump to even if even

	div  $a0, $a2			# else
	mfhi $t0         		# result = x % n 
	j fin 					# skip even to fin

	even:					
	    li $t0, 1			

	fin:
	    mult $t0, $v0		# result = result * temp
	    mflo $t3			
	    mult $t3, $v0  		# result = result * temp * temp
	    mflo $t3			
	    div $t3, $a2        # result = (result * temp * temp) % n
	    mfhi $v0  			
	    move $t2, $v0       

	result:
	    lw $ra, ($sp)		# final iteration
	    lw $a1, 4($sp)		
	    addu $sp, $sp, 8	# deletes stack
		div $a1, $t5
		mfhi $t1
		beq $t1, $zero, even1  # if (k % 2 == 0)
		div $a0, $a2     
		mfhi $t0         	# result = x % n
		j fin1				#if odd then skip even1
		even1:
		    li $t0, 1
		fin1:
		    mult $t0, $v0   # result * temp
		    mflo $t4       
		    mult $t4, $v0   # result * temp * temp
		    mflo $t4       
		    div $t4, $a2    # (result * temp * temp) % n
		    mfhi $t2        
	    jr $ra 				# jump to return address (back to main)

	expZero:
	  	li $v0, 1			# case when exponent is zero
	  	j result