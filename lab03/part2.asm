##
## part2.asm - Recursive division function with simple user interface
##
#################################
#					 	#
#		text segment		#
#						#
#################################

	.text		
	.globl main 
	
main:			# execution starts here

	la $a0, welcomestr
	li $v0, 4
	syscall
	
	loop:
		la $a0, entertwo
		li $v0, 4
		syscall
		
		la $a0, endl
		syscall
		
		la $a0, numberone
		syscall
		li $v0, 5 # get the first number from user
		syscall
		blt $v0, $0, terminate # if negative terminate
		move $t0, $v0
		la $a0, endl
		li $v0, 4
		syscall
		
		la $a0, numbertwo
		li $v0, 4
		syscall
		li $v0, 5 # get the first number from user
		syscall
		
		bne $v0, $0, notzero # if the divider is zero
		la $a0, undefined
		li $v0, 4
		syscall
		j loop
		
		notzero:
		blt $v0, $0, terminate # if negative terminate
		move $a1, $v0
		
		move $a0, $t0
		addi $v0, $0, 0
		jal RecursiveDivision
		move $t0, $v0
		
		la $a0, endl
		li $v0, 4
		syscall
		
		la $a0, result
		li $v0, 4
		syscall
		
		move $a0, $t0
		li $v0, 1
		syscall
		
		la $a0, endl
		li $v0, 4
		syscall
		
		j loop
	terminate:
	
	li $v0,10	# end the program
	syscall
	
# Calculation is done by a0 / a1
RecursiveDivision:
	addi $sp, $sp, -4 # make space on stack to store 1 register
	sw $ra, 0($sp)	# save $ra on stack
	
	beq $a1, $0, done # if divider is 0
	
	sub $a0, $a0, $a1 # a0 = a0 - a1
	
	bge $a0, $0, continue # if a >= 0 continue
	j done
	
	continue:
	addi $v0, $v0, 1 # add 1 to result
	jal RecursiveDivision # recursive call
	
	done:
	lw $ra, 0($sp)	# restore $ra from stack
	addi $sp, $sp, 4 # deallocate stack space
	jr $ra # return to caller
	
#################################
#					 	#
#     	 data segment		#
#						#
#################################
.data
	welcomestr: .asciiz "Welcome, this program divides two numbers. "
	numberone: .asciiz "Enter the first number: "
	numbertwo: .asciiz "Enter the second number: "
	entertwo: .asciiz "Enter two positive integers, negative to stop. "
	result: .asciiz "Result of first/second: "
	comma: .asciiz ", "
	endl: .asciiz "\n"
	undefined: .asciiz "Result is undefined.\n"

##
## end of file part2.asm

	
