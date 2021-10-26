# Write a procedure that ROT13 encodes a string 


.data #declares global variables
prompt: .asciiz "Enter a string: "
str1:   .asciiz "Result is: "
newline: .asciiz    "\n"
buffer: .space 20

.globl  main  
.globl  encode 
.text
main: 
    li  $v0, 4     
    la  $a0, prompt 
    syscall    # prompt for input 

    
    li  $v0, 8       
    la  $a0, buffer  
    li  $a1, 20      
    syscall          # read in the value
    move    $s0, $v0

    #encode string
    jal encode     

    #print result
    li  $v0, 4      
    la  $a0, str1  
    syscall         
    li  $v0, 4      
    la  $a0, buffer 
    syscall       

    # exit program
    j  exit

exit:
    li $v0, 10 
    syscall

encode: #invalid input exits this procedure
    li      $t0, 0     #puts '0' in $t0 (this will be incremented)
    move    $s0, $a0   

Loop: 
    lb     $t5, 0($s0)  
    sltiu  $t1, $t0, 20 
    beq    $t1, $zero, Finish 
    sltiu  $t1, $t5, 64 
    bne    $t1, $zero, Inc 
    sltiu  $t1, $t5, 91 
    beq    $t1, $zero, Inc
    #I know that the input is within a valid range now
    sltiu  $t1, $t5, 78 #ensures char is between 'A' and 'N'
    beq    $t1, $zero, Sub 
    j      Add

    addi   $s0, $s0, 1 
    addi   $t0, $t0, 1 
    j      Loop #goes back to the top

Add:
    addi   $t5, $t5, 13 
    sb     $t5, 0($s0)  
    j Inc

Sub: 
    sub    $t5, $t5, 13
    sb     $t5, 0($s0)  
    j Inc

Inc:
    addi   $t0, $t0, 1 
    addi   $s0, $s0, 1
    j Loop

Finish:
    jr      $ra