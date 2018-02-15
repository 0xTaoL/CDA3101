# define main program
.globl main
main:

.data
#array with all 12 numbers
A:	.word -89, 19, 91, -23, -31, -96, 3, 67, 17, 13,-43, -74
str1: .asciiz "Average of positive array elements: "

.text

la $s4, A        #Let $s4 = address of A

addi $s0, $zero, 0 #sum=0
addi $s1, $zero, 0 #i=0

STARTLOOP:
addi $s2, $s1, -12
bgez $s2, ENDLOOP  #branch if i>=12
add $s6,$s1,$s1    #tmp=2i
add $s6,$s6,$s6    #tmp=4i
add $s5,$s4,$s6    #compute addr 
                   #of A[i]
lw $s3, 0($s5)     #load A[i]
bltz $s3, E			#if positive then
add $s0, $s0, $s3  #add to a
E:
addi $s1, $s1, 1   #inc i
j STARTLOOP
ENDLOOP:

#compute average (divide by 6)
addi $s7, 6
div $s0, $s7

#print answer
la $a0, str1	#print str1
li $v0, 4	      
syscall

li $v0, 1		#print average
mflo $a0
syscall 

# Exit program
li $v0, 10
syscall