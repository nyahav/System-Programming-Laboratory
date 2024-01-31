# Title:Question 4
# Author: yahav nir
# Input: pair of digits in base 8,seperated by a '$'
# Output: two print,one after convert,and one after sort
############################################

.data
stringocta: .space 31
NUM: .space 10
prompt: .asciiz "Enter a string of numbers in base 8: "
error_msg: .asciiz "Invalid string."
space: .asciiz "  "   # String containing two spaces
newline: .asciiz "\n"
############################################
.text
.globl main
main:
    # Print a prompt to the user.
    li $v0, 4
    la $a0, prompt
    syscall

    # Read the string from the user.
    li $v0, 8
    la $a0, stringocta
    li $a1, 31
    syscall

    # Check if the user entered the "ENTER" character.
    lb $t0, stringocta+30
    bne $t0, 0, end_main

    # Check if the string is valid.
    jal is_valid
    beqz $v0, end_main

   # Convert the string to a number.
   jal convert

   #Print the converted numbers.
   jal print

   # Call the sort procedure.
   la $a0, NUM
   move $a1, $v0
   jal sort

   # Print the sorted number to the user.
   jal print

    # Exit the program.
    li $v0, 10
    syscall

is_valid:
    # Check if the string is empty.
    lb $t0, stringocta
    beqz $t0, end_is_valid

    # Check if the string contains only digits and ' characters.
    li $t1, 0
loop_is_valid:
    lb $t2, stringocta($t1)
    beqz $t2, end_loop_is_valid
    blt $t2, '0', end_is_valid
    bgt $t2, '7', end_is_valid
    li $t4, 39        # ASCII value of the ' character
    beq $t2, $t4, not_invalid
    addi $t1, $t1, 1
    j loop_is_valid

not_invalid:
    # Check if the string contains only one ' character.
    lb $t0, stringocta($t1)
    beqz $t0, end_is_valid

    # Return the number of pairs of digits in the string.
    move $v0, $t1
    jr $ra

end_loop_is_valid:
    # Check if the string contains only one ' character.
    lb $t0, stringocta($t1)
    beqz $t0, end_is_valid

end_is_valid:
    # Return 0 to indicate valid string.
    li $v0, 0
    jr $ra

end_main:
    li $v0, 4
    la $a0, error_msg
    syscall

    li $v0, 10
    syscall
    
 
convert:
    # Convert the string to a number.
    li $t0, 0
    li $t1, 0
    li $t2, 8

loop_convert:
    lb $t3, stringocta($t1)
    beqz $t3, end_convert_loop

    beqz $t3, end_convert  # Check if current character is zero
    sll $t0, $t0, 3
    add $t0, $t0, $t3  # Convert ASCII to number
    addi $t1, $t1, 1   # Increment index
    j loop_convert

end_convert_loop:
    move $v0, $t0
    jr $ra

end_convert:
    move $v0, $t0
    jr $ra
    
    
print:
    # Print the sorted numbers from the array.
    li $t0, 0      # Initialize loop counter

print_loop:
    bge $t0, $a1, end_print_loop   # Check if loop counter exceeds number of elements

    lw $t1, 0($a0)   # Load the current element

    # Print the number
    li $v0, 1       # Print integer
    move $a0, $t1   # Move number to print to $a0
    syscall

    # Print a space
    li $v0, 4       # Print string
    la $a0, space
    syscall

    addi $a0, $a0, 4   # Move to the next element
    addi $t0, $t0, 1   # Increment the loop counter
    j print_loop

end_print_loop:
    # Print a newline
    li $v0, 4
    la $a0, newline
    syscall

    jr $ra
    
    
    
sort:
    # Sort the array.
    li $t0, 0
loop_sort:
    beq $t0, $a1, end_sort

    # Load the two elements to be swapped.
    lw $t1, 0($a0)   # Load the current element
    lw $t2, 4($a0)   # Load the next element

    # Compare the two elements
    ble $t2, $t1, no_swap

    # Swap the two elements.
    sw $t2, 0($a0)   # Store the greater element in the current position
    sw $t1, 4($a0)   # Store the smaller element in the next position

no_swap:
    addi $a0, $a0, 4   # Move to the next pair of elements
    addi $t0, $t0, 1   # Increment the loop counter
    j loop_sort

end_sort:
    jr $ra
