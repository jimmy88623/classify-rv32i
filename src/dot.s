.globl dot

.text
# =======================================================
# FUNCTION: Strided Dot Product Calculator
#
# Calculates sum(arr0[i * stride0] * arr1[i * stride1])
# where i ranges from 0 to (element_count - 1)
#
# Args:
#   a0 (int *): Pointer to first input array
#   a1 (int *): Pointer to second input array
#   a2 (int):   Number of elements to process
#   a3 (int):   Skip distance in first array
#   a4 (int):   Skip distance in second array
#
# Returns:
#   a0 (int):   Resulting dot product value
#
# Preconditions:
#   - Element count must be positive (>= 1)
#   - Both strides must be positive (>= 1)
#
# Error Handling:
#   - Exits with code 36 if element count < 1
#   - Exits with code 37 if any stride < 1
# =======================================================
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
    add t2, t2, a0
    addi t3, t3, 1
    blt t3, a1, multiply_loop1
    mv a0, t2
    ret

multiply_loop2:
    add t2, t2, a1
    addi t3, t3, 1
    blt t3, a0, multiply_loop2
    mv a0, t2
    ret


