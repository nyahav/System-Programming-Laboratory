# Title: Question 3
# Author: Yahav Nir
# Input: String, up to 30 characters
# Output: Same string, one less character every loop, then exit
############################################
.data
# Allocate space for the string
buf: .space 31
msg: .asciiz "\n Enter a String(30 chars max):\n"
############################################
.text
.globl main
main: # Main program entry
############################################
# Print string
li $v0,4
la $a0,msg
syscall
############################################
# Get input from the user
li $v0,8
la $a0,buf
li $a1,31
syscall

# Check if the string is longer than 30 characters
li $t0,-1
count:
addi $t0,$t0,1
lbu $t1,buf($t0)    # Load a byte from memory
bgt $t1,10,count
beq $t0,$t0,Exit

# Print the string one character at a time, decrementing the counter each time
outer_loop:
li $a0,'\n'
syscall
li $t0,30
inner_loop:
lbu $a0,buf($t0)   # Char to print
syscall
beq $t0,$zero,Exit
addi $t0,$t0,-1
bne $t0,$zero,inner_loop

# Exit the program
Exit:
li $v0,10 	# Exit program
syscall
