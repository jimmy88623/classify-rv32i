.globl relu

.text
# ==============================================================================
# FUNCTION: Array ReLU Activation
#
# Applies ReLU (Rectified Linear Unit) operation in-place:
# For each element x in array: x = max(0, x)
#
# Arguments:
#   a0: Pointer to integer array to be modified
#   a1: Number of elements in array
#
# Returns:
#   None - Original array is modified directly
#
# Validation:
#   Requires non-empty array (length ≥ 1)
#   Terminates (code 36) if validation fails
#
# Example:
#   Input:  [-2, 0, 3, -1, 5]
#   Result: [ 0, 0, 3,  0, 5]
# ==============================================================================
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
