##
## part4.asm -  Counts the number of occurrences of the bit
## 		pattern stored in $a0 in $a1. The bit pattern to be searched is stored in the least significant bit positions
## 		of $a0, the bit pattern length is given in $a2.
##
#################################
#					 	#
#		text segment		#
#						#
#################################

	.text		
	.globl main 
	
main:			# execution starts here

	la, $a0, welcomestr # print first str
	li $v0, 4
	syscall
	
	la, $a0, firststr # print first str
	li $v0, 4
	syscall
	
	li $v0, 5 # get the first value
	syscall
	
	move $t0, $v0 # move the first value to t0
	
	la, $a0, secondstr # print first str
	li $v0, 4
	syscall
	
	li $v0, 5 # get the first value
	syscall
	
	move $t1, $v0 # move the first value to t1
	
	la, $a0, bitpatternlength
	li $v0, 4
	syscall
	
	li $v0, 5 # get the bitpatternlength value
	syscall
	
	move $t2, $v0 # move the bitpatternlength value to t2
	
	la $a0, valuesarestr
	li $v0, 4
	syscall

	move $a0, $t0
	li $v0, 34
	syscall
	
	la $a0, endl
	li $v0, 4
	syscall
	
	move $a0, $t1
	li $v0, 34
	syscall
	
	la $a0, endl
	li $v0, 4
	syscall
	
	move $a0, $t0
	move $a1, $t1
	move $a2, $t2
	
	li $v0, 34
	
	
	# function call
	jal CountBitPattern
	
	move $t0, $v0
	
	la $a0, occurancestr
	li $v0, 4
	syscall
	
	move $a0, $t0
	li $v0, 1
	syscall
	
	li $v0,10	# end the program
	syscall

# Count the number of occurrences of the bit pattern stored in $a0 in $a1. The bit pattern length is in $a2.
CountBitPattern:
	addi $sp, $sp, -20 # make space on stack to store 5 registers
	sw $s0, 0($sp)	# save $s0 on stack
	sw $s1, 4($sp)	# save $s1 on stack
	sw $s2, 8($sp)	# save $s2 on stack
	sw $s3, 12($sp)	# save $s3 on stack
	sw $s4, 16($sp)	# save $s3 on stack
	
	addi $s0, $0, 0
	addi $s1, $0, 1 # i = 1
	
	generatenumloop:
		beq $s1, $a2, numgenerated
		addi $s0, $s0, 1
		sll $s0, $s0, 1
		
		addi $s1, $s1, 1
		j generatenumloop
	numgenerated: addi $s0, $s0, 1
	
	and $s0, $s0, $a0 # number that we are going to use is generated
	
	addi $s1, $0, 0 # count = 0
	
	addi $s4, $0, 32
	sub $s4, $s4, $a2 # s4 = 32 - a2
	
	loop:
		beq $a1, $0, done
		
		move $s3, $a1
		sllv $s3, $s3, $s4 # get the 4 lsb of a1
		srlv $s3, $s3, $s4 # shift amount is s4 = 32 - a2
		
		bne $s3, $s0, dontincreasecount
		addi $s1, $s1, 1 # count = count + 1
		srlv $a1, $a1, $a2
		j loop
		
		dontincreasecount:
		#srl $a1, $a1, 1
		srlv $a1, $a1, $a2
		j loop
	done:
	
	move $v0, $s1
	
	lw $s0, 0($sp)	# restore $s0 
	lw $s1, 4($sp)	# restore $s1 
	lw $s2, 8($sp)	# restore $s2 
	lw $s3, 12($sp)	# restore $s3 
	lw $s4, 16($sp)	# restore $s4
	addi $sp, $sp, 20
	
	jr $ra

#################################
#					 	#
#     	 data segment		#
#						#
#################################
.data
	arraysizeiszero: .asciiz "Array size is zero.\n"
	welcomestr: .asciiz "Welcome to this program. It counts the number of same bits in the specified amount of lsb of another integer.\n"
	firststr: .asciiz "Enter first value: \n"
	secondstr: .asciiz "Enter second value: \n"
	bitpatternlength: .asciiz "Enter the bit pattern length: \n"
	occurancestr: .asciiz "The number of occurances is "
	valuesarestr: .asciiz "The values in hexadecimal are: \n"
	endl: .asciiz "\n"
##
## end of file part4.asm
