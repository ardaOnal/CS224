##
## lab6.asm - Finding the average of the elements of a square matrix
##
#################################
#					 	#
#		text segment		#
#						#
#################################

	.text		
	.globl main 
	
main:			# execution starts here

	la $a0, welcomestr # print welcome text
	li $v0, 4
	syscall
	
	menuloop:
		la $a0, menu # print main menu text
		li $v0, 4
		syscall
		
		li $v0, 5 # get the option as input from user
		syscall
		
		beq $v0, 1, getmatrixdim # first case
		beq $v0, 2, initializematrix # second case
		beq $v0, 3, displayelement # third case
		beq $v0, 4, obtainaveragerow # fourth case
		beq $v0, 5, obtainaveragecol # fifth case
		# else, program ends
		
		li $v0,10	# end the program
		syscall
		
		
		
		
		
	# Case 1
	getmatrixdim:
	la $a0, enterarrsize # Ask the user for the matrix dimension
	li $v0, 4
	syscall 
	
	li $v0, 5 # get the input dimension from user
	syscall
	
	move $t0, $v0 # t0 = N
	
	la $a0, matrixdimstr # print matrix dimension is set text
	li $v0, 4
	syscall 
	move $a0, $t0 # print dimension
	li $v0, 1
	syscall 
	
	la $a0, endl # print endline
	li $v0, 4
	syscall
	j menuloop # jump back to the menu loop
	
	# Case 2
	initializematrix: 
	mulo $v0, $t0, $t0 # size is N*N
	
	move $s0, $v0 # size is now in s0
	sll $v0, $v0, 2
	
	move $a0, $v0  # The bytes size of the memory location to be allocated
	li $v0, 9 	# Used for dynamic storage allocation
	syscall 	# Perform storage allocation by using values stored in $a0 (memory size) and $v0 (action to be performed by syscall).
	add $s1, $zero, $v0 # $s1 <== $v0 # $s1 points to the beginning of the array.
	add $s3, $zero, $v0 # $s3 <== $v0 # $s1 points to the beginning of the array.
	move $t2, $s3
	addi $s1, $0, 1 # counter for the loop 
	addi $s2, $s0, 1 # holds size+1 for the beq
	
	# initialize the elements from 1 to N^2
	initializeelements:
		beq $s1, $s2, done # if counter = size+1 initialization is done
		sw $s1, 0($s3) # put the read integer to array
		
		addi $s1, $s1, 1 # i = i + 1
		addi $s3, $s3, 4 # address = address + 4
		
		j initializeelements
	done:
	
	la $a0, matrixcreated # print matrix created text
	li $v0, 4
	syscall 
	move $a0, $t0 # print the dimension of the matrix that was created
	li $v0, 1
	syscall 
	
	la $a0, endl # print endl
	li $v0, 4
	syscall
	j menuloop # jump back to the menu loop
	
	
	# Case 3
	displayelement:
	la $a0, enterrowandcolumnindexstr # ask the user for the row and column index
	li $v0, 4
	syscall
	li $v0, 5 # get row index as integer
	syscall
	move $t8, $v0 # t8 holds row index
	li $v0, 5 # get column index as integer
	syscall
	move $t9, $v0 # t9 holds column index
	
	la $a0, elementwith # print "Element with row index "
	li $v0, 4
	syscall
	move $a0, $t8 # print row index
	li $v0, 1
	syscall
	la $a0, andcolindex # print " and column index "
	li $v0, 4
	syscall
	move $a0, $t9 # print col index
	li $v0, 1
	syscall
	la $a0, is # print " is "
	li $v0, 4
	syscall
	
	# compute the address of element with specified row and col index
	addi $t8, $t8, -1 # i-1
	mul $t8, $t8, $t0 # i-1 * N
	mul $t8, $t8, 4 # i-1 * N * 4
	addi $t9, $t9, -1 # j-1
	mul $t9, $t9, 4 # j-1 * 4
	add $t8, $t8, $t9 # (i - 1) x N x 4 + (j - 1) x 4
	
	add $t7, $t2, $t8 # head address
	lw $a0, 0($t7) # get the item from array
	li $v0, 1
	syscall
	
	addi $t7, $0, 0 # reset $t7 because it is used in other parts of program
	j menuloop # jump back to the menu loop
	
	
	# Case 4
	obtainaveragerow:
	la $a0, rowaverages # print row averages text
	li $v0, 4
	syscall
	
	move $s3, $t2 # s3 holds head address
	addi $s2, $0, 0 # counter
	addi $t1, $0, 0 # holds sum of current row
	addi $t6, $0, 0 # holds all sum
	addi $t4, $t0, -1 # holds N - 1
	
	averagerowmajor:
		beq $s2, $s0, done2 # if counter equals size of matrix, loop ends
		
		lw $t3, 0($s3) # put the element into t3
		add $t1, $t1, $t3 # add the current element to t1
		add $t6, $t6, $t3 # add the current element to all sum
		
		bne $s2, $t4, dontprint # print when row is done
		div $t1, $t1, $t0 # sum of row / N
		
		move $a0, $t1 # print average block
		li $v0, 1
		syscall
		
		la $a0, endl # print endl
		li $v0, 4
		syscall
		
		addi $t1, $0, 0 # reset sum of row
		add $t4, $t4, $t0
		dontprint:
		
		addi $s3, $s3, 4 # address = address + 4
		addi $s2, $s2, 1 # i = i + 1
		j averagerowmajor
	done2:
	# print all average block
	la $a0,averagematrixstr # print average text
	li $v0, 4
	syscall
	div $t6, $t6, $s0 # sum of sum / N^2
	move $a0, $t6 # print average block
	li $v0, 1
	syscall
	la $a0,endl # print endl
	li $v0, 4
	syscall
	j menuloop # jump back to the menu loop
	
	# Case 5
	obtainaveragecol:
	la $a0, colaverages # print column average text
	li $v0, 4
	syscall
	
	move $s3, $t2 # s3 holds head address
	move $s4, $t2 # s4 holds head address
	addi $s2, $0, 1 # counter
	addi $t1, $0, 0 # sum of col
	addi $s7, $s0, 1 # holds size + 1
	move $t4, $t0 # holds matrix dimension
	addi $t6, $0, 0 # holds all sum
	
	averagecolmajor:
		beq $s2, $s7, done3 # if counter equals size+1 ( counter starts from 1)
		
		lw $t3, 0($s3) # put the element into t3
		add $t1, $t1, $t3 # add the current element to t1
		add $t6, $t6, $t3 # add the current element to all sum
		
		bne $s2, $t4, dontprint2
		div $t1, $t1, $t0 # sum of row / N
		
		move $a0, $t1 # print average block
		li $v0, 1
		syscall
		
		la $a0, space # print a space
		li $v0, 4
		syscall
		
		addi $t1, $0, 0 # reset sum of row
		add $t4, $t4, $t0
		dontprint2:
		
		div $s2, $t0 # mod operation
		mfhi $s5 # get the remainder
		
		beq $s5, $0, skip # if the remainder is 0 it is the last index of column
		mul $s6, $t0, 4  # N*4 is byte offset
		add $s3, $s3, $s6 # address = address + N*4
		j skip2
		skip:
		addi $s4, $s4, 4 
		move $s3, $s4
		skip2:
		addi $s2, $s2, 1 # i = i + 1
		j averagecolmajor 
	done3:
	# print all average block
	la $a0,endl # print endl
	li $v0, 4
	syscall
	la $a0,averagematrixstr # print average text
	li $v0, 4
	syscall
	div $t6, $t6, $s0 # sum of sum / N^2
	move $a0, $t6 # print average block
	li $v0, 1
	syscall
	la $a0,endl # print endl
	li $v0, 4
	syscall
	j menuloop # jump back to the menu loop
	
# end of main function
#################################
#					 	#
#     	 data segment		#
#						#
#################################
.data
	enterarrsize: .asciiz "Please enter matrix dimension: "
	welcomestr: .asciiz "Welcome to this program, please use the menu below to do the operations.\n"
	matrixdimstr: .asciiz "Matrix dimension is set as "
	matrixcreated: .asciiz "Matrix created with dimension "
	menu: .asciiz "\n(1)Enter matrix size in terms of its dimensions (N)\n(2)Create the matrix\n(3)Display desired elements of the matrix by specifying its row and column member\n(4)Display the average (arithmetic mean) of the matrix elements in a row-major (row by row) fashion\n(5)Display the average (arithmetic mean) of matrix elements in a column-major (column by column) fashion\n(Any other number) Exit\nSelect one of the above by entering integer:\n"
	endl: .asciiz "\n"
	space: .asciiz " "
	rowaverages: .asciiz "Row averages are (top to bottom): \n"
	colaverages: .asciiz "Column averages are (left to right): \n"
	enterrowandcolumnindexstr: .asciiz "Enter row and column index: \n"
	averagematrixstr: .asciiz "Average of the entire matrix is: "
	elementwith: .asciiz "Element with row index "
	andcolindex: .asciiz " and column index "
	is: .asciiz " is "
##
## end of file lab6.asm
