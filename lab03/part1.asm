##
## part1.asm - Counts the add and load word instructions in a program
##
#################################
#					 	#
#		text segment		#
#						#
#################################

	.text		
	.globl main 
	
main:			# execution starts here
L1:	la $a0, welcomestr
	li $v0, 4
	syscall
	
	la $a0, endl
	li $v0, 4
	syscall
	
	la $a0, L1 # Calling the subprogram for main
	la $a1, L2
	addi $v0, $0, 0
	addi $v1, $0, 0
	jal instructionCount
	
	move $t0, $v0
	move $t1, $v1
	
	la $a0, mainadd # printing the add count of main
	li $v0, 4
	syscall
	move $a0, $t0
	li $v0, 1
	syscall
	
	la $a0, endl # printing endl
	li $v0, 4
	syscall
	
	la $a0, mainlw # printing the lw count of main
	syscall
	move $a0, $t1
	li $v0, 1
	syscall
	
	la $a0, endl # printing endl
	li $v0, 4
	syscall
	
	la $a0, L3 # Calling the subprogram for subprogram
	la $a1, L4
	addi $v0, $0, 0
	addi $v1, $0, 0
	jal instructionCount
	
	move $t0, $v0
	move $t1, $v1
	
	la $a0, subadd # printing the add count of main
	li $v0, 4
	syscall
	move $a0, $t0
	li $v0, 1
	syscall
	
	la $a0, endl # printing endl
	li $v0, 4
	syscall
	
	la $a0, sublw # printing the lw count of main
	syscall
	move $a0, $t1
	li $v0, 1
	syscall
	
	li $v0,10	# end the program
L2:	syscall
	
# a0 has the address of the first instruction, a1 has the address of the last instruction
instructionCount:
L3:	addi $sp, $sp, -12 # make space on stack to store 3 registers
	sw $s0, 0($sp)	# save $s0 on stack
	sw $s1, 4($sp)	# save $s1 on stack
	sw $s2, 8($sp)	# save $s2 on stack
	
	lw $s1, 0($a1) # last instruction is put into s1
	
	loop:
		lw $s0, 0($a0) # current instruction is put into s0
		
		srl $s2, $s0, 26 # getting the first 6 bits of the instruction
		
		bne $s2, 35, notlw # Checking if the opcode equals the opcode of lw 
		addi $v1, $v1, 1 # increase the count of lw ins by 1
		j notadd
		
		notlw: 
		bne $s2, 0, notadd # Checking the opcode is 0
		sll $s2, $s0, 26 # getting the last 6 bits of the instruction
		srl $s2, $s2, 26
		bne $s2, 32, notadd # Checking if the function part of instruction is 100000
		addi $v0, $v0, 1 # increase the count of add ins by 1
		
		notadd:
		addi $a0, $a0, 4 # increase address by 4
		beq $a0, $a1, loopend
		j loop
	loopend:
	
	
	lw $s0, 0($sp)	# restore $s0 from stack
	lw $s1, 4($sp)	# restore $s1 from stack
	lw $s2, 8($sp)	# restore $s1 from stack
	addi $sp, $sp, 12 # deallocate stack space
L4:	jr $ra # return to caller
	
#################################
#					 	#
#     	 data segment		#
#						#
#################################
.data
	welcomestr: .asciiz "Welcome, this program counts the number of add and lw instructions in main and subprogram. "
	mainadd: .asciiz "The number of add instructions in main: "
	mainlw: .asciiz "The number of lw instructions in main: "
	subadd: .asciiz "The number of add instructions in subprogram: "
	sublw: .asciiz "The number of lw instructions in subprogram: "
	comma: .asciiz ", "
	endl: .asciiz "\n"

##
## end of file part1.asm

	
