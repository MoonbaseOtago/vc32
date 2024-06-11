	.=0	
	j	start
	.=4	
	j	trap
	.=8
	j 	intr
	.=12
	j	sys_trap
	.=16
	j	mmu_trap
mmu_vector:
	.word	0
mmu_trap:
	la	a2, mmu_vector
	lw	a2, (a2)
	jr	a2
intr:	j	intr
trap:	j	trap
syscall_vector:
	.word	0
sys_trap:
	la	a2, syscall_vector
	lw	a2, (a2)
	jr	a2

start:
	li	a0, 5
	li 	a1, 6
	li	a5, 0xfffe	// fffe - address for tests
l:		add a1, -1
		bnez a1, l
	add	a1, a0
	la	a2, loc
	lw	a3, (a2)	// 0099	
	sw	a3, (a5)
	lb	a3, (a2)	// ff99
	sw	a3, (a5)
	sw	a3, 2(a2)	// ff99
	lw	a4, 2(a2)	// ff99
	sw	a4, (a5)

	li 	a0, 0x55
	sb 	a0, 3(a2)	
	lw	a4, 2(a2)	// 5599
	sw	a4, (a5)
	lb	a1, 3(a2)	// 0055
	sw	a1, (a5)

	li	a0, 0x33
	li	a2, 0x55
	or	a2, a0		// 0077
	sw	a2, (a5)
	li	a2, 0x55
	and	a2, a0		// 0011
	sw	a2, (a5)
	li	a2, 0x55
	xor	a2, a0		// 0066
	sw	a2, (a5)
	li	a2, 0x5
	and	a2, 0x3		// 0001
	sw	a2, (a5)

	li	a2, 0x5
	li	a0, 0x3
	sub	a2, a0		// 0002
	sw	a2, (a5)

	li	a2, 1
	jal	subr
	add	a2, 1
	sw	a2, (a5)	// 4

	la	a0, subr
	jalr	a0
	add	a2, 1
	sw	a2, (a5)	// 7

	la	a0, loc
	mv	sp, a0
	lw	a1, 2(sp)	// 5599
	sw	a1, (a5)	
	add	sp, 2
	lw	a2, (sp)	// 5599
	sw	a1, (a5)	
	add	a2, 1
	sw	a2, 2(sp)	// 559a
	add	sp, -2
	lea	a1, 4(sp)	// loc+4
	lw	a1, (a1)	// 559a
	sw	a1, (a5)	
	
	li 	a0, 0
	li 	a1, 0
	bgez	a0, b1
		li a1, 1
b1:				// should be 0
	sw	a1, (a5)	
	li 	a0, -1
	bgez	a0, b2
		li a1, 2
b2:				// should be 2
	sw	a1, (a5)	
	li 	a1, 0
	li 	a0, 1
	bgez	a0, b3
		li a1, 3
b3:				// should be 0
	sw	a1, (a5)	
	li 	a1, 0
	li	a0, 0
	bltz	a0, b4
		li a1, 4
b4:				// should be 4
	sw	a1, (a5)	
	li 	a1, 0
	li	a0, -1
	bltz	a0, b5
		li a1, 5
b5:				// should be 0
	sw	a1, (a5)	
	li 	a1, 0
	li	a0, 1
	bltz	a0, b6
		li a1, 6
b6:				// should be 6
	sw	a1, (a5)	
	li 	a1, 0
	li	a0, 1
	bnez	a0, b7
		li a1, 7
b7:				// should be 0
	sw	a1, (a5)	
	li 	a1, 0
	li	a0, 0
	bnez	a0, b8
		li a1, 8
b8:				// should be 8
	sw	a1, (a5)	
	li 	a1, 0
	li	a0, -1
	bnez	a0, b9
		li a1, 9
b9:				// should be 0
	sw	a1, (a5)	
	li 	a1, 0
	li	a0, 1
	beqz	a0, b10
		li a1, 10
b10:				// should be 10
	sw	a1, (a5)	
	li 	a1, 0
	li	a0, 0
	beqz	a0, b11
		li a1, 11
b11:				// should be 0
	sw	a1, (a5)	
	li 	a1, 0
	li	a0, -1
	beqz	a0, b12
		li a1, 12
b12:				// should be 12
	sw	a1, (a5)	

	li 	s0, -3
	sra	s0
	sw	s0, (a5)	// fffe
	li 	s0, -3
	srl	s0
	sw	s0, (a5)	// 7ffe
	li 	s0, -3
	sll	s0
	sw	s0, (a5)	// fffa
	li	s0, 3
	li	s1, 8
	mul	s0, s1
	sw      s0, (a5)        // 24
	mv	s0, mulhi
	sw      s0, (a5)        // 0
	li	s0, -1
	mv	s1, s0
	mul	s0, s1
	sw      s0, (a5)        // 0001
	mv	s0, mulhi
	sw      s0, (a5)        // 0xfffe
	li	s0, 0
	mv	s1, s0
	mul	s0, s1
	sw      s0, (a5)        // 0
	mv	s0, mulhi
	sw      s0, (a5)        // 0
	li	s0, 0x15
	mv	stmp, s0
	mv 	s1, stmp
	sw      s1, (a5)        // 0x15
// turn off mmu
	li	a0, 32
lp1:
		add 	a0, -1
		mv	a1, a0
		sll	a1
		sll	a1
		mv	mmu, a1
		bnez	a0, lp1
//
	li 	s1, 0x14
	li	a0, 1
	la	s0, r1
	or	s0, a0
	mv	epc, s0
	jr	epc
xx1:	j	xx1
r1:
	sw      s1, (a5)	// 0x14
	mv	s1, csr
	sw	s1, (a5)        // 0x4
	
	la      s0, r2
	mv	epc, s0
	jr	epc
	j	xx1

syscall1:
	li 	a0, 0x19
	sw      a0, (a5)        // 0x19
	mv	s1, csr
	sw	s1, (a5)        // 0x4
	jr	epc


r2:
	la	a0, syscall1
	la	a1, syscall_vector
	sw	a0, (a1)

	mv	s1, csr
	sw	s1, (a5)        // 0x9
sc:	syscall					// goes to syscall1
r3:	li	a0, 0x1a	
	sw      a0, (a5)        // 0x1a
	mv	s1, csr
	sw	s1, (a5)        // 0x0
	
	la	a0, syscall2
	la	a1, syscall_vector
	sw	a0, (a1)
	syscall					// goes to syscall2
syscall2:		
	li	a0, 0x1b	
	sw      a0, (a5)        // 0x1b
	mv	s1, csr
	sw	s1, (a5)        // 0x4
	mv	s1, epc
	li	a2, 1
	and	s1, a2
	sw	s1, (a5)        // 0x0
	mv	s1, epc
	la	a2, syscall2
	sub	s1, a2
	sw	s1, (a5)        // 0x0
//
//	mmu tests
//

//	map I/D sup pages 1:1
//
//
	li	a0, 0x60	// S I #0
	mv	mmu, a0
	li	a0, 0x3		// V ->0 
	mv	mmu, a0
	sw	a0, (a5)        // 0x3 #0

	li	a0, 0x20	// S D #0
	mv	mmu, a0
	li	a0, 0x07	// V W ->0 
	mv	mmu, a0
	sw	a0, (a5)        // 0x7

	li	a0, 0x3e	// S D #f
	mv	mmu, a0

	lui	a0, 0x0300
	li	a1, 0xffc7	// V W ->0xf
	zext	a1
	or	a0, a1
	mv	mmu, a0
	sw	a0, (a5)        // 0x3c7
// turn on MMU
	mv	a0, csr
	or	a0, 0x8
	mv	csr, a0
xx:
	sw	a0, (a5)        // 0xc

	li	a0, 0xffdf
	sext	a0
	sw	a0, (a5)        // 0xffdf
	zext	a0
	sw	a0, (a5)        // 0xdf
	li	a0, 8
	mv	sp, a0
	li	a0, 16
	mv	stmp, a0
	swapsp
	mv	a0, sp
	sw	a0, (a5)        // 16
	mv	a0, stmp
	sw	a0, (a5)        // 8

	lui	a0, 0xff00	// tests for the new lui
	sw	a0, (a5)        // ff00
	lui	a0, 0x8000
	sw	a0, (a5)        // 8000
	lui	a0, 0x7f00
	sw	a0, (a5)        // 7f00

	la	a0, loc
	li	a1, 0x65
	sb	a1, (a0)
	lb	a2, (a0)	// ck that load/store work thru mmu
	sw	a2, (a5)        // 0x65
	

	li	a1, 0x20	// S D #0
	mv	mmu, a1
	li	a1, 0x21	// V S D  #0->0 
	mv	mmu, a1
	sw	a1, (a5)        // 0x21
	lb	a1, (a0)	// ck that load works thru mmu read only
	sw	a1, (a5)        // 0x65

	la	a1, mmu_vector
	la	a2, wrt
	sw	a2, (a1)
	li	a1, 0x55
uu1:	sb	a1, (a0)
uuu:	sw	a1, (a5)        // this is to force a fail

wrt:
	li	a1, 0xffaa	// did we take a write trap?
	sw	a1, (a5)        // 0xffaa
	

	ebreak

loc:	.word	0x99
	.word	0x55
	.word	0x0
	.word	0x0
	.word	0x0
	.word	0x0
	.word	0x0

subr:	add	a2, 2
	jr	lr
