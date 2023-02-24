.data
image: 	
	.word 0x53a14e
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
beginLoop1:
	li s0, 0x10000000
	la s1, image
	li s2, 64

loop1: 
	lw s3, 0(s1)
	sw s3, 0(s0)
	addi s1, s1, 4
	addi s0, s0, 4
	addi s2, s2, -1
	beqz s2, beginLoop2
	j loop1
	
beginLoop2:
	li s0, 0x10000000
	li s2, 64
	li s3, 0

loop2: 
	sw s3, 0(s0)
	addi s0, s0, 4
	addi s2, s2, -1
	beqz s2, beginLoop1
	j loop2

