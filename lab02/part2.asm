##
## part2.asm - Tests if an array is symmetric, finds the maximum and minimum element
##
#################################
#					 	#
#		text segment		#
#						#
#################################

	.text		
	.globl main 
	
main:
	la $a0, welcomestr # print welcomestr
	li $v0,4
	syscall
	
	li $v0,5 # read the integer and put it into v0
	syscall
	
	move $a0, $v0 # move the integer to a0
	jal ReverseBitsOfANumber
	
	move $t1, $v0 # hold the result temporarily in t1
	
	la $a0, endstr # print ending string
	li $v0, 4
	syscall
	
	move $a0, $t1 # move the result that was hold in a1 to a0
	li $v0,34	# print the result in hexadecimal
	syscall
	
	li $v0,10	# end the program
	syscall

# a0 = input decimal number
ReverseBitsOfANumber:
	addi $sp, $sp, -16 # make space on stack to store 4 registers
	sw $s0, 0($sp)	# save $s0 on stack
	sw $s1, 4($sp)	# save $s1 on stack
	sw $s2, 8($sp)	# save $s2 on stack
	sw $s3, 12($sp)	# save $s3 on stack

	addi $s0, $0, 0   # i = 0
	addi $s1, $0, 0   # sum = 0
	addi $s3, $0, 31  
		
	loop:
		beq $s0, 32, done
		
		srlv $s2,$a0,$s0 # shift the number i times to right
		
		and $s2,1 # get the last bit
		
		sllv $s2, $s2, $s3 # shift the number 3- i times to left
		
		add $s1, $s1, $s2
		
		addi $s3, $s3, -1 # s3 = 31 - i
		addi $s0, $s0, 1 # i = i + 1
		j loop
	done:
	move $v0, $s1	# result is put into v0
	lw $s0, 0($sp)	# save $s0 on stack
	lw $s1, 4($sp)	# save $s1 on stack
	lw $s2, 8($sp)	# save $s2 on stack
	lw $s3, 12($sp)	# save $s3 on stack
	jr $ra # return to caller
	
#################################
#					 	#
#     	 data segment		#
#						#
#################################
.data
	welcomestr: .asciiz "Welcome to this program. Please enter an integer to reverse its bits: "
	endstr: .asciiz "The number with reversed bits is: "

##
## end of file part2.asm
	
