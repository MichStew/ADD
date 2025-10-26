.text
.globl main 

main: 
	#set system to listening mode and then do the listening 
	li a7, 5
	ecall 
	#move our input to t0 for operations
	mv t0, a0
	# if our input is 0 then we print 0
	beqz t0, print_result
	# set guess to 0 and store in t1
	li t1, 0
	# add given number into t2
	li t2, 4194304
	
loop: 
	
	#branch if equal to 0 
	beqz t2, print_result 
	# square the step and store in t4 high bits
	mulhu t4, t1, t1
	# square the step and get the low bits
	mul t5, t1, t1
	#shifting the bits by 14, both the high and the low 
	srli t5, t5, 14
	slli t4, t4, 18
	or t3, t5, t4
	beq t3, t0 ,print_result
	bgeu t3, t0, subtract 
	bltu t3, t0, ard
	
subtract: 
	sub t1, t1,t2
	srli t2, t2, 1
	beqz t2, print_result
	j loop
ard: 
	add t1,t1,t2
	srli t2, t2, 1
	beqz t2, print_result
	j loop
	
print_result: 
	#move 
	mv a0,t1 
	li a7, 1
	ecall 
	
	#write letter to exit and then send it off to system 
	li a7, 10
	ecall 