# Assignment 2: Classify

TODO: Add your own descriptions here.

## abs.s

### RISC-V Code Section
```assembly
.globl abs

.text
abs:
    # Prologue
    ebreak
    # Load number from memory
    lw t0 0(a0)
    bge t0, zero, done

    neg t0, t0
    sw t0, 0(a0)
    
    # TODO: Add your own implementation

done:
    # Epilogue
    jr ra
```
###  Description
This RISC-V assembly program calculates the absolute value of a number stored in memory. It reads the value, checks if it is negative, and if so, negates it before storing it back in memory. The program concludes by returning control to the caller.
### Program Steps

1.Load Number from Memory

The value at the address specified by a0 is loaded into the temporary register t0.

2.Check if the Value is Negative

Using the bge (branch if greater or equal) instruction, the program checks if the value in t0 is greater than or equal to zero. If true, it jumps to the done label, skipping the negation logic.

3.Negate the Value

If the value in t0 is negative, the neg instruction negates it.
The updated value is stored back into memory at the address specified by a0.

4.Return to Caller

The done label represents the end of the program's logic.
The jr ra instruction is used to return to the calling function.

## relu.s

### RISC-V Code Section
```assembly
.globl relu

.text
relu:
    li t0, 1             
    blt a1, t0, error     
    li t1, 0    

    mv t3, a0
loop_start:
    # TODO: Add your own implementation
    bge t1, a1, end

    lw t4, 0(t3)
    blez t4, set_zero

    j next_element
set_zero:
    sw x0, 0(t3)
next_element:
    addi t1, t1, 1
    addi t3, t3, 4
    j loop_start
end:
    ret

error:
    li a0, 36          
    j exit          

```
### Description
The ReLU function sets all negative values in an array to 0 while keeping non-negative values unchanged. It processes an array element by element.
### Program Steps
1.Error Check

2.Initialize Registers

3.Processing Loop

Load Current Element: Load the value at the address in t3 into t4.

Check Value: If t4 <= 0, set it to 0 by storing x0 at t3.

Move to Next Element: Increment t3 to the next array element and increment the loop counter t1.

Repeat: Continue until all elements are processed (t1 == a1).

4.End Processing

Exit the function

5.Error Handling

if a1 < 1, set a0 = 36 and jump to exit.

## argmax.s

### RISC-V Code Section
```assembly
.globl argmax

.text
argmax:
    li t6, 1
    blt a1, t6, handle_error

    lw t0, 0(a0)

    li t1, 0
    li t2, 1
loop_start:
    # TODO: Add your own implementation
    beq t2, a1, end
    
    lw t3, 0(a0)
    slli t4, t2, 2
    add t5, a0, t4
    lw t3, 0(t5)

    bgt t3, t0, update_max

    addi t2, t2, 1
    j loop_start
update_max:
    mv t0, t3
    mv t1, t2
    addi t2, t2, 1
    j loop_start
    
end:
    mv a0, t1
    ret    

handle_error:
    li a0, 36
    j exit
```
###  Description
This RISC-V assembly program implements the argmax function, which identifies the index of the largest value in an array of integers. The array is passed via a pointer (a0), and the number of elements in the array is passed in a1. If the input is invalid (e.g., a1 < 1), the program will handle the error gracefully.
###  Program Steps
1.Error Handling

If the number of elements (a1) is less than 1, the program jumps to the handle_error label.
In handle_error, it sets a0 to a predefined error code (36) and exits.

2.Initialization

The first element of the array is loaded into t0 as the initial maximum value.
t1 is set to 0, representing the current index of the maximum value.
t2 is initialized to 1, representing the loop iterator.

3.Main Loop

The loop iterates through the array, comparing each element with the current maximum value (t0).
If a larger value is found, it updates the maximum value (t0) and its index (t1).

4.Completion

When the loop ends, the index of the maximum value (t1) is stored in a0.
The program returns to the caller.
## dot.s

### RISC-V Code Section
```
.globl dot

.text

dot:
    li t0, 1                
    blt a2, t0, error_terminate 
    blt a3, t0, error_terminate 
    blt a4, t0, error_terminate  

    li t0, 0                  
    li t1, 0  

    mv t6, a0
    mv t5, a1

loop_start:
    bge t1, a2, end

    lw t2, 0(t6)

    lw t3, 0(t5)

    addi sp, sp, -20
    sw ra, 0(sp)
    sw a0, 4(sp)
    sw a1, 8(sp)
    sw t2, 12(sp)
    sw t3, 16(sp)
    
    mv a0, t2
    mv a1, t3

    # mul a0, a0, a1

    jal ra, multiply
    add t0, t0, a0
    lw ra, 0(sp)
    lw a0, 4(sp)
    lw a1, 8(sp)
    lw t2, 12(sp)
    lw t3, 16(sp)
    addi sp, sp, 20

    addi t1, t1, 1

    mv t3, a3
mul_loop0:
    addi t6, t6, 4
    addi t3, t3, -1
    bnez t3, mul_loop0

    mv t4, a4
mul_loop1:
    addi t5, t5, 4
    addi t4, t4, -1
    bnez t4, mul_loop1

    j loop_start
     
error_terminate:
    blt a2, t0, set_error_36
    li a0, 37
    j exit

set_error_36:
    li a0, 36
    j exit

end:
    mv a0, t0
    ret

multiply:
    li t2, 0
    li t3, 0
    bge a0, zero, multiply_loop2
    bge a1, zero, multiply_loop1
    neg a0, a0
    neg a1, a1


multiply_loop1:
    beq a1,zero, equal_zero
    add t2, t2, a0
    addi t3, t3, 1
    blt t3, a1, multiply_loop1
    mv a0, t2
    ret

multiply_loop2:
    beq a0,zero, equal_zero
    add t2, t2, a1
    addi t3, t3, 1
    blt t3, a0, multiply_loop2
    mv a0, t2
    ret
equal_zero:
    mv a0, zero
    ret
```
###  Description
This RISC-V assembly program calculates the dot product of two arrays with customizable strides.
###  Program Steps
1.Input Validation:

Validate a2 (element count) and strides (a3, a4).
Exit with an error code if inputs are invalid.

2.Main Calculation Loop:

For each element in the arrays:
Load the values from memory.
Compute their product using multiply.
Accumulate the product into t0.
Adjust pointers based on strides.
Increment the loop counter.

3.Final Return:

Store the result in a0 and return.

4.Error Handling:

Set a0 to the appropriate error code and terminate the program.
## matmul.s

### RISC-V Code Section
```
.globl matmul

.text

matmul:
    # Error checks
    li t0 1
    blt a1, t0, error
    blt a2, t0, error
    blt a4, t0, error
    blt a5, t0, error
    bne a2, a4, error

    # Prologue
    addi sp, sp, -28
    sw ra, 0(sp)
    
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    
    li s0, 0 # outer loop counter
    li s1, 0 # inner loop counter
    mv s2, a6 # incrementing result matrix pointer
    mv s3, a0 # incrementing matrix A pointer, increments durring outer loop
    mv s4, a3 # incrementing matrix B pointer, increments during inner loop 
    
outer_loop_start:
    #s0 is going to be the loop counter for the rows in A
    li s1, 0
    mv s4, a3
    blt s0, a1, inner_loop_start

    j outer_loop_end
    
inner_loop_start:

    beq s1, a5, inner_loop_end

    addi sp, sp, -24
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw a3, 12(sp)
    sw a4, 16(sp)
    sw a5, 20(sp)
    
    mv a0, s3 # setting pointer for matrix A into the correct argument value
    mv a1, s4 # setting pointer for Matrix B into the correct argument value
    mv a2, a2 # setting the number of elements to use to the columns of A
    li a3, 1 # stride for matrix A
    mv a4, a5 # stride for matrix B
    
    jal dot
    
    mv t0, a0 # storing result of the dot product into t0
    
    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw a3, 12(sp)
    lw a4, 16(sp)
    lw a5, 20(sp)
    addi sp, sp, 24
    
    sw t0, 0(s2)
    addi s2, s2, 4 # Incrememtning pointer for result matrix
    
    li t1, 4
    add s4, s4, t1 # incrememtning the column on Matrix B
    
    addi s1, s1, 1
    j inner_loop_start
    
inner_loop_end:
    li t1, 4
    slli t1 ,a4 ,2
    add s3, s3, t1
    mv s4, a3 
    addi s0, s0, 1
    j outer_loop_start
    
outer_loop_end:
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    addi sp, sp, 28
    ret   
error:
    li a0, 38
    j exit

```
###  Description
This RISC-V assembly program performs matrix multiplication. It computes the product of two matrices, A (dimensions: a1 x a2) and B (dimensions: a4 x a5), and stores the resulting matrix in the location specified by a6.
###  Program Steps
1.Error Check

Ensure matrix dimensions are valid, and jump to erro if checks faila

2.Prologue

Save ra and s0-s5 on the stack

3.Outer Loop

Loop over rows of Matrix A

4.Inner Loop

Loop over columns of Matrix B 

5.Post Inner Loop

After processing all columns of Matrix B:
Move s3 to the next row of A.
Reset s4 to the base of Matrix B.
Increment the outer loop counter (s0).

6.Epilogue

Restore saved registers (ra, s0–s5) from the stack.
Return to the caller.

7.Error Handling

Jump to error if dimension checks fail
Set a0=38 and terminate

## read_matrix.s / write_matrix.s / classify.s

### Description
Since the mul instruction cannot be used directly, an alternative multiplication function must be implemented manually