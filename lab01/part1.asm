##
## part1.asm - Tests if an array is symmetric
##	
##	a0 - points to the string or integer that we want to print
##	s0 - points to the array
##	s1 - points to the arrsize
##	s2 - holds "i" the index of array starting from 0
##	s3 - holds "j" the index of array starting from arrsize - 1
##	s4 - holds "k" the index of array starting from 0
##	t0 - holds the addresss of arrsize
##	t1 - holds the arrsize
##	t2 - holds the arrsize / 2
##	t3 - holds the address of array[i]
##	t4 - holds the integer in array[i]
##	t5 - holds the address of array[j]
##	t6 - holds the integer in array[i]
##	t7 - holds the address of array[k]
##	v0 - reads the string
##
##

#################################
#					 	#
#		text segment		#
#						#
#################################

	.text		
	.globl __start 
	
__start:		# execution starts here
	la $s0, array	# s0 points to the array
	la $s1, arrsize	# s1 points to the array

	add $t0, $t0, $s1 # address of arrsize
	lw $t1, 0($t0) # $t1 = arrsize[0]

	srl $t2, $t1, 1 # $t2 = arrsize / 2

	addi $s2, $0, 0 # i = 0
	add $s3, $0, $t1 # j = $s3 = arrsize
	addi $s3, $s3, -1 # j = j - 1
	
	addi $s4, $0, 0 # k = 0
	la $a0, arraystr	# put string address into a0
	li $v0, 4		# system call to print
	syscall			#   out a string
	
	printarrayloop:
	
 		sll $t7, $s4, 2 # $t7 = i * 4 (byte offset)
 		add $t7, $t7, $s0 # address of array[k]
 		lw $a0, 0($t7) # $a0 = array[k]
 		li $v0, 1	# system call to print
 		syscall 
 		
 		beq $s4, $s3, done # if k == arrsize
 		
 		li $v0, 4	# system call to print
 		la $a0, comma	# put string address into a0
 		syscall 
 		
 		addi $s4, $s4, 1	# k = k + 1
 		j printarrayloop
 	done:

	beq $t1, 1, symmetric # array is symmetric if arrsize is one

	loop:
 		beq $s2, $t2, symmetric # if i == arrsize / 2
 	
 		sll $t3, $s2, 2 # $t3 = i * 4 (byte offset)
 		add $t3, $t3, $s0 # address of array[i]
 		lw $t4, 0($t3) # $t4 = array[i]
 	
 		sll $t5, $s3, 2 # $t5 = j * 4 (byte offset)
 		add $t5, $t5, $s0 # address of array[j]
 		lw $t6, 0($t5) # $t6 = array[j]
 	
 		bne $t4, $t6, notsymmetric
 	
 		addi $s2, $s2, 1    # i = i + 1
    		addi $s3, $s3, -1   # j = j - 1
    		j loop              #repeat
 	
	symmetric:			#print array is not symmetric
		la $a0,symmetricstr	# put string address into a0
		li $v0,4		# system call to print
		syscall			#   out a string
 		j exit
 	
	notsymmetric: 			#print array is symmetric
		la $a0,notsymmetricstr	# put string address into a0
		li $v0,4		# system call to print
		syscall			#   out a string
	exit:

#################################
#					 	#
#     	 data segment		#
#						#
#################################
.data
	array: .word 777,888,999,888,777
	arrsize: .word 5
	notsymmetricstr:.asciiz " is not symmetric.\n"
	symmetricstr:	.asciiz " is symmetric.\n"
	comma: .asciiz ", "
	arraystr: .asciiz "Array "

##
## end of file part1.asm


