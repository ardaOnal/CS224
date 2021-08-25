# Dynamic array creation and accessing its elements
# All using subprograms
	.text
	li	$a0, 12
	li	$v0, 9
	syscall
# The beginning address of the allocated memory is in $v0.
# Beginning location of the array is in $v0.
	add	$t0, $v0,$zero
# Initialize array elements. 
	li	$t1, 2
	sw	$t1, 0($t0)
	
	li	$t1, 3
	sw	$t1, 4($t0)
	
	li	$t1, 5
	sw	$t1, 8($t0)
	
# Find sum of array elements.
	add	$t1, $zero, $zero		# $t1: sum
	lw	$t2, arraySize		# $t2: array size
next:	
	beq	$t2, $zero, done
	lw	$t3, 0($t0)
	add	$t1 $t1, $t3
	addi	$t0, $t0, 4		# increment array pointer
	addi	$t2, $t2, -1		# Processed one entry
	j	next	
done:
	
# Result is in $v0.
# Print array sum.
	add	$a0, $t1, $zero
	li	$v0, 1
	syscall
	
	li	$v0, 10
	syscall
	

#=====================================================
	.data
arraySize:
	.word	3
	

	