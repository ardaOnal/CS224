##
## part1.asm - Tests if an array is symmetric, finds the maximum and minimum element
##
#################################
#					 	#
#		text segment		#
#						#
#################################

	.text		
	.globl main 
	
main:			# execution starts here
	
	lw $a1, arraySize
	beq $a1, 0, sizeiszero
	
	la $a0, arraystr	# put string address into a0
	li $v0, 4		# system call to print
	syscall			#   out a string
	
	la $a0, array
	lw $a1, arraySize
	
	jal PrintArray
	
	la $a0, array
	lw $a1, arraySize
	
	jal CheckSymmetric
	
	beq $v0, 1, printsymmetric
	la $a0, notsymmetricstr	# put string address into a0
	li $v0, 4		# system call to print
	syscall			#   out a string
	j next
	
	printsymmetric:
	la $a0, symmetricstr	# put string address into a0
	li $v0, 4		# system call to print
	syscall			#   out a string
	
	next:
	
	la $a0, array
	lw $a1, arraySize
	
	jal FindMinMax
	move $a2, $v0 # a2 = min
	move $a3, $v1 # a3 = max
	
	la $a0, max
	li $v0, 4	# system call to print
	syscall	
	
	move $a0, $a3	
	li $v0, 1	# system call to print
	syscall	
	
	la $a0, endl	
	li $v0, 4	# system call to print
	syscall	
	
	la $a0, min
	li $v0, 4	# system call to print
	syscall	
	
	move $a0, $a2	
	li $v0, 1	# system call to print
	syscall	
	
	la $a0, endl	
	li $v0, 4	# system call to print
	syscall	
	
	j end
	
	
# a0 points to array, a1 has the arraySize
PrintArray:
	addi $sp, $sp, -8 # make space on stack to store 2 registers
	sw $s0, 4($sp)	# save $s0 on stack
	sw $s1, 0($sp)	# save $s1 on stack
	
	beq $a1,0,done
	
	move $s0, $a0 # address of array
	addi $s1, $0, 1   # i = 1
	
	printarrayloop:
		lw $a0, 0($s0) # $a0 = array[address]
 		li $v0, 1	# system call to print
 		syscall 
 		
 		beq $s1, $a1, done # if i == arrsize
 		
 		li $v0, 4	# system call to print
 		la $a0, comma	# put string address into a0
 		syscall 
 		
 		addi $s1, $s1, 1	# i = i + 1
 		addi $s0, $s0, 4	# address = addres + 4
 		j printarrayloop
	done:
	
	lw $s0, 4($sp)	# restore $s0 from stack
	lw $s1, 0($sp)	# restore $s1 from stack
	addi $sp, $sp, 8 # deallocate stack space
	jr $ra # return to caller
	
# a0 points to array, a1 has the arraySize
CheckSymmetric:
	addi $sp, $sp, -28 # make space on stack to store 7 registers
	sw $s0, 0($sp)	# save $s0 on stack
	sw $s1, 4($sp)	# save $s1 on stack
	sw $s2, 8($sp)	# save $s2 on stack
	sw $s3, 12($sp)	# save $s3 on stack
	sw $s4, 16($sp)	# save $s4 on stack
	sw $s5, 20($sp)	# save $s5 on stack
	sw $s6, 24($sp)	# save $s6 on stack
	
	beq $a1,0,symmetric
	
	add $s0, $s0, $a0 # address of array
	addi $s1, $0, 0   # i = 0
	add $s2, $0, $a1 # j = $s3 = arrsize
	addi $s2, $s2, -1 # j = j - 1
	
	srl $a1, $a1, 1 # $a1 = arrsize / 2
	
 	loop:
 		beq $s1, $a1, symmetric # if i == arrsize / 2
 		sll $s3, $s1, 2 # $s3 = i * 4 (byte offset)
 		add $s3, $s3, $s0 # address of array[i]
 		lw $s4, 0($s3) # $s4 = array[i]
 	
 		sll $s5, $s2, 2 # $s5 = j * 4 (byte offset)
 		add $s5, $s5, $s0 # address of array[j]
 		lw $s6, 0($s5) # $s6 = array[j]
 	
 		bne $s4, $s6, notsymmetric
 	
 		addi $s1, $s1, 1    # i = i + 1
    		addi $s2, $s2, -1   # j = j - 1
    		j loop              #repeat
    		
    	symmetric:			# array is symmetric
		li $v0,1		# system call to print
 		j checkSymmetricDone
 	
	notsymmetric: 			#array is notsymmetric
		li $v0,0		# system call to print
		
	checkSymmetricDone: 
	lw $s0, 0($sp)	# save $s0 on stack
	lw $s1, 4($sp)	# save $s1 on stack
	lw $s2, 8($sp)	# save $s2 on stack
	lw $s3, 12($sp)	# save $s3 on stack
	lw $s4, 16($sp)	# save $s4 on stack
	lw $s5, 20($sp)	# save $s5 on stack
	lw $s6, 24($sp)	# save $s6 on stack
	jr $ra # return to caller
	
# a0 points to array, a1 has the arraySize
FindMinMax:
	addi $sp, $sp, -16 # make space on stack to store 4 registers
	sw $s0, 0($sp)	# save $s0 on stack
	sw $s1, 4($sp)	# save $s1 on stack
	sw $s2, 8($sp)	# save $s2 on stack
	sw $s3, 12($sp)	# save $s3 on stack
	
	beq $a1,0,exitMinMaxloop

	add $s0, $s0, $a0 # address of array
	addi $s1, $0, 0   # i = 0
	lw $s2, 0($s0) # min = s2 = array[i]
	lw $s3, 0($s0) # max = s3 = array[i]
	
	findMinMaxloop: 
		beq $s1, $a1, exitMinMaxloop
		
		lw $a0, 0($s0) # $a0 = array[i]
		
		blt $s2, $a0, dontsetmin # if min < array[i]
		move $s2, $a0 # setting the new min
		dontsetmin: 
		
		bgt $s3, $a0, dontsetmax # if max > array[i]
		move $s3, $a0 # setting the new max
		dontsetmax: 
		
		addi $s0, $s0, 4 # address = address + 4
		addi $s1, $s1, 1 # i = i + 1
		
		j findMinMaxloop
	exitMinMaxloop:
	move $v0, $s2
	move $v1, $s3
	
	lw $s0, 0($sp)	# save $s0 on stack
	lw $s1, 4($sp)	# save $s1 on stack
	lw $s2, 8($sp)	# save $s2 on stack
	lw $s3, 12($sp)	# save $s3 on stack

	jr $ra # return to caller


sizeiszero:
	la $a0, arraysizeiszero
	li $v0, 4	# system call to print
	syscall	
end:
#################################
#					 	#
#     	 data segment		#
#						#
#################################
.data
	array: .word 8,1
	arraySize: .word 2
	notsymmetricstr:.asciiz " is not symmetric.\n"
	symmetricstr:	.asciiz " is symmetric.\n"
	comma: .asciiz ", "
	arraystr: .asciiz "Array "
	min: .asciiz "Min: "
	max: .asciiz "Max: "
	endl: .asciiz "\n"
	arraysizeiszero: .asciiz "Array size is zero.\n"

##
## end of file part1.asm

	
