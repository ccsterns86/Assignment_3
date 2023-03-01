# Cassandra Sterns      SID: 22209739
# Ethan Doyle           SID: 22210635

.data
image: 	.word 0x53a14e
	.word 0x208618
	.word 0x53a14e
	.word 0x208618
	.word 0x22c0db
	.word 0x4da8d0
	.word 0x0e94cf
	.word 0xcfe9f5
	.word 0x208618
	.word 0x23681d
	.word 0x208618
	.word 0x4da8d0
	.word 0x3a82a2
	.word 0x0e94cf
	.word 0xeef5f8
	.word 0xd8e2e6
	.word 0x23681d
	.word 0x14510f
	.word 0x22c0db
	.word 0x0e94cf
	.word 0x22c0db
	.word 0x3a82a2
	.word 0x4da8d0
	.word 0x0e94cf
	.word 0x40361b
	.word 0x0e94cf
	.word 0x4da8d0
	.word 0xdb22a6
	.word 0x4da8d0
	.word 0x0e94cf
	.word 0x3a82a2
	.word 0x22c0db
	.word 0x4a422c
	.word 0x4da8d0
	.word 0xdb22a6
	.word 0xbdd348
	.word 0xdb22a6
	.word 0x22c0db
	.word 0x4da8d0
	.word 0x0e94cf
	.word 0x40361b
	.word 0x3a82a2
	.word 0x48a2d3
	.word 0xdb22a6
	.word 0x0e94cf
	.word 0x46644e
	.word 0x375941
	.word 0x256d39
	.word 0x598966
	.word 0x346b43
	.word 0x598966
	.word 0x5b7d64
	.word 0x598966
	.word 0x144f24
	.word 0x598966
	.word 0x346b43
	.word 0x144f24
	.word 0x5b7d64
	.word 0x144f24
	.word 0x375941
	.word 0x346b43
	.word 0x375941
	.word 0x5b7d64
	.word 0x144f24
                
        .text
main:
	# set-up trap handler
 	la s0,trap_handler
 	csrw s0,utvec       # set utvec = address of the handler
 	
 	# enable processing of interrup requests from timer
 	li s1,0x10        
 	csrw s1,uie         # set uie = 0x10 

 	# enable interrupts in CPU
 	csrsi ustatus,1    # set interrupt enable bit in ustatus (0) 
 	
 	# ask timer, which is part of Digital Lab Sim tool,
 	# to generate interrupts every 30 instructions
 	# (see Digital Lab Sim help file for detail)
 	li s1, 0xffff0013
 	li s0, 1
 	sb s0, 0(s1)       
	
	j process_1        # start running process_1
	
	
# only registers s0-s3 are saved as process context 
# and can be used by the process code.

# ---------------------------------------

		
process_1:
	li s1,0xffff0010
loop_1:
	li s0,0x3f
	sb s0,0(s1)
	li s0,0x06
	sb s0,0(s1)
	li s0,0x5B
	sb s0,0(s1)
	li s0,0x4F
	sb s0,0(s1)
	j loop_1
	
# ---------------------------------------
	
process_2:
	li s1,0xffff0011
loop_2:
	li s0,0x3f
	sb s0,0(s1)
	li s0,0x06
	sb s0,0(s1)
	li s0,0x5B
	sb s0,0(s1)
	li s0,0x4F
	sb s0,0(s1)
	j loop_2
	
# ---------------------------------------
process_3:

beginLoop1: #set beginning point of loop
	li s0, 0x10000000
	la s1, image
	li s2, 64

loop1: #display the image
	lw s3, 0(s1) #load word for the image
	sw s3, 0(s0) #set value in the display
	addi s1, s1, 4 #increment image location
	addi s0, s0, 4 #increment display location
	addi s2, s2, -1 #keep track of number of pixels left
	beqz s2, beginLoop2 #if s2 is 0, image done
	j loop1
	
beginLoop2: #set beginning point of loop
	li s0, 0x10000000
	li s2, 64
	li s3, 0

loop2: #blank the display
	sw s3, 0(s0) #set value in display to black
	addi s0, s0, 4 #increment display location
	addi s2, s2, -1 #keep track of pixels left
	beqz s2, beginLoop1 #if s2 is 0, image cleared
	j loop2


# ---------------------------------------

trap_handler: 

	# save process context (i.e. CPU registers) into the current trap frame
	
	csrw s0,uscratch    # copy value of s0 into uscratch temporarily
	la s0, current_process_trap_frame
	lw s0, 0(s0)        # load address of the current trap_frame into s0
	sw s1, 8(s0)        # save value of s1 into the trap frame
	sw s2,12(s0)        # save value of s2 into the trap frame
	sw s3,16(s0)        # save value of s3 into the trap frame
	csrr s1, uscratch   # get value of s0 from uscratch into s1
	sw s1, 4(s0)        # save value of s0 into the trap frame
	csrr s1, uepc       # get value of pc from uepc into s1
	sw s1, 0(s0)        # save value of pc into the trap frame

	# switch to the next process
	
	lw s1, 20(s0)       # load address of the next trap frame to run
	la s0, current_process_trap_frame
        sw s1, 0(s0)        # save it into the currernt trap frame pointer  

	# restore process context (CPU registers) from the selected trap frame 
	# and continue running
	
	mv s0,s1            # address of selected process trap frame in s0
	lw s1,0(s0)         # saved value of pc in s1
	csrw s1,uepc        # we put it to uepc for uret to consume
	lw s1,4(s0)         # load saved value of s0
	csrw s1,uscratch    # put it to uscratch temporarily
	lw s1,8(s0)         # restore saved value of s1
	lw s2,12(s0)        # restore saved value of s2
	lw s3,16(s0)        # restore saved value of s3
        csrr s0,uscratch    # restore s0 from uscratch
        
	uret                # restore pc from uepc and continue running
	                    # selected process
		
	.data

# Pointer to the trap frame corresponding to the currently running process

current_process_trap_frame:
	.word	trap_frame_1
	
# Different trap frames are used for storing contexts of
# individual processes

trap_frame_1:
	.word process_1    # pc    (trap_frame + 0)  - initialise to the starting address
	.word 0            # s0    (trap_frame + 4)
	.word 0            # s1    (trap_frame + 8) 
	.word 0            # s2    (trap_frame + 12) 
	.word 0            # s3    (trap_frame + 16) 
	.word trap_frame_2 # next  (trap_frame + 20)
	
trap_frame_2:
	.word process_2    # pc    (trap_frame + 0)  - initialise to the starting address
	.word 0            # s0    (trap_frame + 4)
	.word 0            # s1    (trap_frame + 8)
	.word 0            # s2    (trap_frame + 12) 
	.word 0            # s3    (trap_frame + 16) 
	.word trap_frame_3 # next  (trap_frame + 20)
	
trap_frame_3:
	.word process_3    # pc    (trap_frame + 0)  - initialise to the starting address
	.word 0            # s0    (trap_frame + 4)
	.word 0            # s1    (trap_frame + 8)
	.word 0            # s2    (trap_frame + 12) 
	.word 0            # s3    (trap_frame + 16) 
	.word trap_frame_1 # next  (trap_frame + 20)

