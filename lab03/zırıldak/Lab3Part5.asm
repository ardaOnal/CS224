##
## Part 5 - Duplicates a linked list recursively
##
##	a0 - holds the copy list head
##	
##

#################################
#					 	#
#		text segment		#
#						#
#################################

	.text
	.globl __start
	
__start:

# CS224 Spring 2021, Program to be used in Lab3
# February 23, 2021
# 
	li	$a0, 10 	# create a linked list with 10 nodes
	jal	createLinkedList
	
	move $t1, $v0
	
	la	$a0, prompt1
	li	$v0, 4
	syscall
	
	move $a0, $t1
	
	jal printLinkedList
	
# Linked list is pointed by $v0
	move	$a0, $t1	# Pass the linked list address in $a0
	jal 	copyListRecursive
	
	move $t2, $v0
	
	la	$a0, prompt2
	li	$v0, 4
	syscall
	
	move $a0, $t2

	jal printLinkedList
# Stop. 
	li	$v0, 10
	syscall

copyListRecursive:
	beq	$a0, 0, recursionDone
	addi	$sp, $sp, -24
	sw 	$ra, 20($sp)
	sw	$s0, 16($sp)
	sw	$s1, 12($sp)
	sw	$s2, 8($sp)
	sw	$s3, 4($sp)
	sw	$s4, 0($sp)
	
	move $s0, $a0		# copy the address of the node in $s0
	
	lw $s1, 4($s0)		# $s1 = contents of the original node
	
	# dynamic allocation
	li	$a0, 8
	li	$v0, 9
	syscall
	
	move $s2, $v0		# get the address of the new node in $s2
	
	sw $s1, 4($s2)		# store the value of the node
	
	lw $a0, 0($s0)		# put the address of the next node in $a0
	jal copyListRecursive
	
	sw $v0, 0($s2)		# put the next node address
	
	move $v0, $s2
	
	# Restore the register values
	lw	$s4, 0($sp)
	lw	$s3, 4($sp)
	lw	$s2, 8($sp)
	lw	$s1, 12($sp)
	lw	$s0, 16($sp)
	lw	$ra, 20($sp)
	addi	$sp, $sp, 24
	jr $ra
	
recursionDone:
	addi $v0, $0, 0 # empty v0 so that it holds the head after the line jal copyListRecursive
	jr	$ra
	
createLinkedList:
# $a0: No. of nodes to be created ($a0 >= 1)
# $v0: returns list head
# Node 1 contains 1 in the data field, node i contains the value i in the data field.
# when we print linked list we can differentiate the node content from the node sequence no (1, 2, ...).
	addi	$sp, $sp, -24
	sw	$s0, 20($sp)
	sw	$s1, 16($sp)
	sw	$s2, 12($sp)
	sw	$s3, 8($sp)
	sw	$s4, 4($sp)
	sw	$ra, 0($sp) 	# Save $ra just in case we may want to call a subprogram
	
	move	$s0, $a0	# $s0: no. of nodes to be created.
	li	$s1, 1		# $s1: Node counter
# Create the first node: header.
# Each node is 8 bytes: link field then data field.
	li	$a0, 8
	li	$v0, 9
	syscall
# OK now we have the list head. Save list head pointer 
	move	$s2, $v0	# $s2 points to the first and last node of the linked list.
	move	$s3, $v0	# $s3 now points to the list head.
	add	$s4, $s1, $0	

	sw	$s4, 4($s2)	# Store the data value.
	
addNode:
# Are we done?
# No. of nodes created compared with the number of nodes to be created.
	beq	$s1, $s0, allDone
	addi	$s1, $s1, 1	# Increment node counter.
	add	$s4, $s1, $0
	li	$a0, 8 		# Remember: Node size is 8 bytes.
	li	$v0, 9
	syscall
# Connect the this node to the lst node pointed by $s2.
	sw	$v0, 0($s2)
# Now make $s2 pointing to the newly created node.
	move	$s2, $v0	# $s2 now points to the new node.	

	sw	$s4, 4($s2)	# Store the data value.
	j	addNode
allDone:
# Make sure that the link field of the last node cotains 0.
# The last node is pointed by $s2.
	sw	$zero, 0($s2)
	move	$v0, $s3	# Now $v0 points to the list head ($s3).
	
# Restore the register values
	lw	$ra, 0($sp)
	lw	$s4, 4($sp)
	lw	$s3, 8($sp)
	lw	$s2, 12($sp)
	lw	$s1, 16($sp)
	lw	$s0, 20($sp)
	addi	$sp, $sp, 24
	
	jr	$ra
#=========================================================
printLinkedList:
# Print linked list nodes in the following format
# --------------------------------------
# Node No: xxxx (dec)
# Address of Current Node: xxxx (hex)
# Address of Next Node: xxxx (hex)
# Data Value of Current Node: xxx (dec)
# --------------------------------------

# Save $s registers used
	addi	$sp, $sp, -20
	sw	$s0, 16($sp)
	sw	$s1, 12($sp)
	sw	$s2, 8($sp)
	sw	$s3, 4($sp)
	sw	$ra, 0($sp) 	# Save $ra just in case we may want to call a subprogram

# $a0: points to the linked list.
# $s0: Address of current
# s1: Address of next
# $2: Data of current
# $s3: Node counter: 1, 2, ...
	move $s0, $a0	# $s0: points to the current node.
	li   $s3, 0
printNextNode:
	beq	$s0, $zero, printedAll
				# $s0: Address of current node
	lw	$s1, 0($s0)	# $s1: Address of  next node
	lw	$s2, 4($s0)	# $s2: Data of current node
	addi	$s3, $s3, 1
# $s0: address of current node: print in hex.
# $s1: address of next node: print in hex.
# $s2: data field value of current node: print in decimal.
	la	$a0, line
	li	$v0, 4
	syscall		# Print line seperator
	
	la	$a0, nodeNumberLabel
	li	$v0, 4
	syscall
	
	move	$a0, $s3	# $s3: Node number (position) of current node
	li	$v0, 1
	syscall
	
	la	$a0, addressOfCurrentNodeLabel
	li	$v0, 4
	syscall
	
	move	$a0, $s0	# $s0: Address of current node
	li	$v0, 34
	syscall

	la	$a0, addressOfNextNodeLabel
	li	$v0, 4
	syscall
	move	$a0, $s1	# $s0: Address of next node
	li	$v0, 34
	syscall	
	
	la	$a0, dataValueOfCurrentNode
	li	$v0, 4
	syscall
		
	move	$a0, $s2	# $s2: Data of current node
	li	$v0, 1		
	syscall	

# Now consider next node.
	move	$s0, $s1	# Consider next node.
	j	printNextNode
printedAll:
# Restore the register values
	lw	$ra, 0($sp)
	lw	$s3, 4($sp)
	lw	$s2, 8($sp)
	lw	$s1, 12($sp)
	lw	$s0, 16($sp)
	addi	$sp, $sp, 20
	jr	$ra
#=========================================================		
	.data
prompt1:
	.asciiz "The original list: \n"
	
prompt2:
	.asciiz "\n\n Recursively copied list: \n"
line:	
	.asciiz "\n --------------------------------------"

nodeNumberLabel:
	.asciiz	"\n Node No.: "
	
addressOfCurrentNodeLabel:
	.asciiz	"\n Address of Current Node: "
	
addressOfNextNodeLabel:
	.asciiz	"\n Address of Next Node: "
	
dataValueOfCurrentNode:
	.asciiz	"\n Data Value of Current Node: "
