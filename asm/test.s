	.=0	
begin:
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
	.word	fail
int_vector:
	.word	fail
trap_vector:
	.word	fail
mmu_trap:
	la	s1, mmu_vector
	lw	s1, (s1)
	jr	s1
intr:	la      s1, int_vector
	lw      s1, (s1)
	jr      s1
trap:	la      s1, trap_vector
	lw      s1, (s1)
	jr      s1
syscall_vector:
	.word	fail
sys_trap:
	la	a2, syscall_vector
	lw	a2, (a2)
	jr	a2

send:	stio	a0, 2(a5)
sn1:		ldio	a0, 4(a5)
		and	a0, 1
		beqz	a0, sn1
	ret

copyrom:	lw	a2, (a0)
		sw	a2, (a0)
		add	a0, 2
		add	a1, -1
	 	bnez 	a1, copyrom
	ret


start:
	li	a5, 0x20	// 0x20 - uart base
	la	a0, begin
	la	a1, end
	srl	a1, 1
// copy rom->ram
	jal	copyrom
	li	a0, 'A'
	jal	send

	li	a0, 8
	li	a1, 0
	li	a2, 4
fl:		flush	(a1)	// flush dcache data
		add	a1, a2
		add	a0, -1
		bnez	a0, fl	
	flush	dcache	// flush dcache tags

	li	a0, 0
	li	a1, 0x00 // spi base
	stio	a0, 6(a1) // turn off rom

	flush  icache	// flush icache tags

//switch to ram
	li	a0, 'B'
	jal	send






	li 	a1, 6
	li	a0, 'C'
l:		add a1, -1
		add a0, 1
		bnez a1, l
	jal	send		// C+6

	la	a2, loc

	lw	a0, (a2)	// 0099	
	jal	send		// 99

	lb	a0, (a2)	// ff99
	srl	a0, 1
	jal	send		// cc

	lb	a3, (a2)	// ff99
	sw	a3, 2(a2)	// ff99
	lw	a0, 2(a2)	// ff99
	srl	a0, 1
	jal	send		// cc

	li 	a0, 0x55
	sb 	a0, 3(a2)	
	lw	a4, 2(a2)	// 5599
	mv	a0, a4		// 99
	jal     send
	swap	a0, a4
	jal     send		// 55

	lb	a4, 3(a2)	// 0055
	mv	a0, a4		// 55
	jal     send
	swap	a0, a4
	jal     send		// 00

	li	a4, 0x33
	li	a0, 0x55
	or	a0, a4		// 0077
	jal	send		// 77

	li	a0, 0x55
	and	a0, a4		// 0011
	jal	send		// 11

	li	a0, 0x55
	xor	a0, a4		// 0066
	jal	send		// 66

	li	a0, 0x5
	and	a0, 0x3		// 0001
	jal	send		// 01

	li	a0, 0x5
	li	a2, 0x3
	sub	a0, a2		// 0002
	jal	send		// 02

	li	a0, 1
	jal	subr
	add	a0, 1
	jal	send		// 4

	li	a0, 4
	la	a4, subr
	jalr	a4
	add	a0, 1
	jal	send		// 7

	la	a0, loc
	mv	sp, a0
	lw	a1, 2(sp)	// 5599
	mv	a0, a1
	jal     send  		// 99
	swap	a0, a1
	jal     send  		// 55


	add	sp, 2
	lw	a1, (sp)	// 5599
	mv	a0, a1
	jal     send  		// 99
	swap	a0, a1
	jal     send  		// 55

	add	a1, 1
	sw	a1, 2(sp)	// 559a
	add	sp, -2
	lea	a1, 4(sp)	// loc+4
	lw	a1, (a1)	// 559a
	mv	a0, a1
	jal     send  		// 9a
	swap	a0, a1
	jal     send  		// 55
	
	li 	a1, 0
	li 	a0, 0
	bgez	a1, b1
		li a0, 1
b1:				// should be 0
	jal     send  		// 0


	li 	a1, -1
	bgez	a1, b2
		li a0, 2
b2:				// should be 2
	jal     send  		// 2

	li 	a0, 0
	li 	a1, 1
	bgez	a1, b3
		li a0, 3
b3:				// should be 0
	jal     send  		// 0

	li 	a0, 0
	li	a1, 0
	bltz	a1, b4
		li a0, 4
b4:				// should be 4
	jal     send  		// 4

	li 	a0, 0
	li	a1, -1
	bltz	a1, b5
		li a0, 5
b5:				// should be 0
	jal     send  		// 0

	li 	a0, 0
	li	a1, 1
	bltz	a1, b6
		li a0, 6
b6:				// should be 6
	jal     send  		// 6

	li 	a0, 0
	li	a1, 1
	bnez	a1, b7
		li a0, 7
b7:				// should be 0
	jal     send  		// 0

	li 	a0, 0
	li	a1, 0
	bnez	a1, b8
		li a0, 8
b8:				// should be 8
	jal     send  		// 8

	li 	a0, 0
	li	a1, -1
	bnez	a1, b9
		li a0, 9
b9:				// should be 0
	jal     send  		// 0

	li 	a0, 0
	li	a1, 1
	beqz	a1, b10
		li a0, 10
b10:				// should be 10
	jal     send  		// 10

	li 	a0, 0
	li	a1, 0
	beqz	a1, b11
		li a0, 11
b11:				// should be 0
	jal     send  		// 0

	li 	a0, 0
	li	a1, -1
	beqz	a1, b12
		li a0, 12
b12:				// should be 12
	jal     send  		// 12


	li 	s0, -3
	sra	s0, 1
	mv	a0, s0
	jal     send            // fe
	swap	a0, s0
	jal     send            // ff


	li 	s0, -3
	srl	s0, 1
	mv	a0, s0
	jal     send            // fe
	swap	a0, s0
	jal     send            // 7f

	li 	s0, -3
	sll	s0, 1
	mv	a0, s0
	jal     send            // fa
	swap	a0, s0
	jal     send            // ff

	li	s0, 3
	li	s1, 8
	mul	s0, s1
	mv	a0, s0
	jal     send            // 24
	swap	a0, s0
	jal     send            // 00

	mv	s0, mulhi
	mv	a0, s0
	jal     send            // 00
	swap	a0, s0
	jal     send            // 00



	li	s0, -1
	mv	s1, s0
	mul	s0, s1
	mv	a0, s0
	jal     send            // 01
	swap	a0, s0
	jal     send            // 00


	mv	s0, mulhi
	mv	a0, s0
	jal     send            // fe
	swap	a0, s0
	jal     send            // ff



	li	s0, 0
	mv	s1, s0
	mul	s0, s1
	mv	a0, s0
	jal     send            // 00
	swap	a0, s0
	jal     send            // 00

	mv	s0, mulhi
	mv	a0, s0
	jal     send            // 00
	swap	a0, s0
	jal     send            // 00


	li	s0, 0x15
	mv	stmp, s0
	mv 	s1, stmp
	mv	a0, s1
	jal     send            // 15
	swap	a0, s1
	jal     send            // 00


// turn off mmu
	li	a2, 1	// not valid
	li	a0, 0
	li	a1, 0
	li	a4, 4
	lui	a3, 0x1000
lp2:
		add	a4, -1
		li	a0, 16
lp1:
			add 	a0, -1
			mv	mmu, a1
			mv	mmu, a2
			add	a1, a3
			bnez	a0, lp1
		add	a1, 1<<2
		bnez    a4, lp2
//

	mv	a0, csr		// set user_io
	li	a1, 1<<6
	sll	a1, 1
	or	a0, a1
	mv	csr, a0

	li 	s1, 0x14
	li	a0, 1
	la	s0, r1
	or	s0, a0
	mv	epc, s0
	jr	epc
xx1:	j	xx1
r1:
	mv	a0, s1
	jal     send            // 14
	swap	a0, s1
	jal     send            // 00

	mv	s1, csr
	mv	a0, s1
	jal     send            // 84
	swap	a0, s1
	jal     send            // 00
	
	la      s0, r2
	mv	epc, s0
	jr	epc
	j	xx1

syscall1:
	li 	a0, 0x19
	jal     send            // 19

	mv	a0, csr
	jal     send            // 84
	jr	epc


r2:
	la	a0, syscall1
	la	a1, syscall_vector
	sw	a0, (a1)

sc:	syscall					// goes to syscall1
r3:	li	a0, 0x1a	
	jal     send            // 1a
	//mv	a0, csr
	//jal	send		// 80
	
	la	a0, syscall2
	la	a1, syscall_vector
	sw	a0, (a1)
	syscall					// goes to syscall2
syscall2:		
	li	a0, 0x1b	
	jal	send		// 0x1b
	mv	a0, csr
	jal	send		// 0x84
	mv	a0, epc
	li	a2, 1
	and	a0, a2
	jal	send		// 0x0
	mv	s1, epc
	la	a2, syscall2
	sub	s1, a2
	mv	a0, s1
	jal	send		// 0x0
	swap	a0, s1
	jal	send		// 0x0
//
//	mmu tests
//

//	map I/D sup pages 1:1
//
//
	li	a0, 0x0c	// S I #0
	mv	mmu, a0
	li	a0, 0x3		// V ->1 
	mv	mmu, a0
	jal	send		//0x3 #0

	li	a0, 0x04	// S D #0
	mv	mmu, a0
	li	a0, 0x07	// V W ->1 
	mv	mmu, a0
	jal	send		//0x7


// turn on MMU
	mv	a0, csr
	or	a0, 0x8
	mv	csr, a0
xx:
	jal	send		// 0x8c

	li	a2, 0xffdf
	sext	a2
	mv	a0, a2
	jal	send		// 0xdf
	swap	a0, a2
	jal	send		// 0xff

	zext	a2
	mv	a0, a2
	jal	send		// 0xdf
	swap	a0, a2
	jal	send		// 0x0

	li	a0, 8
	mv	sp, a0
	li	a0, 16
	mv	stmp, a0
	swapsp
	mv	a0, sp
	jal	send		// 16
	mv	a0, stmp
	jal	send		// 8


	lui	a2, 0xff00	// tests for the new lui
	mv	a0, a2
	jal	send		// 0x00
	swap	a0, a2
	jal	send		// 0xff
	lui	a2, 0x8000
	mv	a0, a2
	jal	send		// 0x00
	swap	a0, a2
	jal	send		// 0x60
	lui	a2, 0x7f00
	mv	a0, a2
	jal	send		// 0x00
	swap	a0, a2
	jal	send		// 0x7f


	la	a2, loc
	li	a1, 0x65
	sb	a1, (a2)
	lb	a0, (a2)	// ck that load/store work thru mmu
	jal	send		// 0x65

	la	a1, mmu_vector
	la	a0, wrt1
	sw	a0, (a1)

	li	a0, 0x04	// S D #0
	mv	mmu, a0
	li	a0, 0x03	// V  ->1 
	mv	mmu, a0
	jal	send		// 0x3

	lb	a0, (a2)	// ck that load works thru mmu read only
	jal	send		// 0x65

	li	a0, 0x55
uu1:	sb	a0, (a2)
	jal	send		// force fail

wrt1:
	mv	a2, mmu
	li	a0, 0xffaa	// did we take a write trap?
	jal	send		// 0xaa
	mv 	a0, a2
	jal	send		// 0x04

	li	a0, 0x04	// S D #0	// turn write back on
	mv	mmu, a0
	li	a0, 0x07	// VW  ->1 
	mv	mmu, a0

	la	a1, mmu_vector
	la	a0, wrt2
	sw	a0, (a1)

	li	a0, 0x1000
	sw	a0, (a0)
	j	fail

wrt2:	mv 	a1, mmu
	mv 	a0, a1
	jal	send		// 0x6
	swap 	a0, a1
	jal	send		// 0x10

	la	a1, mmu_vector
	la	a0, wrt3
	sw	a0, (a1)

	li	a0, 0x66
	jal     send            // 0x66

	li	a0, 0x1004	// S D #4000
	mv	mmu, a0
	li	a0, 0x0017	// V W -> 1000 
	mv	mmu, a0
	li	a0, 0x55
	jal	send		// 0x55


	li	a0, 0xffc4
	li	a1, 0x1000
	sw	a0, (a1)
	jal	send		// 0xc4

	li	a0, 0x0000	// S D #0
	mv	mmu, a0
	li	a0, 0x0017	// V W -> 1000 
	mv	mmu, a0
	li	a0, 0x33
	jal	send		// 0x33

	li	a4, 0x0
	mv	a2, csr
	li	a3, 0x10
	or	a3, a2
	mv	csr, a3
	lw	a1, (a4)
	mv	csr, a2
	mv	a0, a1
	jal	send		// 0xc4
	swap	a0, a1
	jal	send		// 0xff

	li	a0, 0x77
	mv	csr, a3
	sw	a0, (a4)
	mv	csr, a2
	jal	send		// 0x77

	li	a0, 0x1000
	lw 	a0, (a0)
	jal	send		// 0x77

	li	a0, 0x0000	// S D #0
	mv	mmu, a0
	li	a0, 0x0013	// V -> 1000 // turn off u mode write
	mv	mmu, a0
	li	a0, 0x33
	jal	send		// 0x33

	mv	csr, a3
	lw	a0, (a4)	// can still read
	mv	csr, a2
	jal     send             // 0x77


	li	a0, 0x11
	mv	csr, a3
ff1:	sw	a0, (a4)	// should fail
	mv	csr, a2
	j	fail

wrt3:	mv	a1, mmu
	mv	csr, a2
	mov	a0, a1
	jal	send 		// 0x00
	swap	a0, a1
	jal	send 		// 0x00

	li	a0, 0x1000
	lw	a0, (a0)
	jal	send 		// 0x77

// add later - run some mapped code in user mode

	la	a0, trap_vector
	la	a1, trapx
	sw	a1, (a0)
	ebreak
trapx:	li	a0, 0x67
	jal	send 		// 0x67

	la	a1, faddr	// test addpc
	li	a0, 9
faddr:	addpc	a0
	add	a0, -9
	sub	a1, a0
	mv	a0, a1
	jal	send 	// 0
	swap	a0, a1
	jal	send	// 0

//
//	test divide
//

	li	a1, 20
	li	a0, 3
	div	a1, a0
	jal	send 	// 3
	mov	a0, a1	
	jal	send 	// 6
	swap	a0, a1
	jal	send 	// 0
	mv	a1, mulhi
	mov	a0, a1	
	jal	send 	// 2
	swap	a0, a1
	jal	send 	// 0

	li	a1, 65534
	li	a0, 3
	div	a1, a0
	mov	a0, a1	
	jal	sendx 	// 0x54
	swap	a0, a1
	jal	sendx 	// 0x55
	mv	a1, mulhi
	mov	a0, a1	
	jal	sendx 	// 2
	swap	a0, a1
	jal	sendx 	// 0
	j	ffff

fail:	li a0,-1
	jal	sendx
ll:	j	ll
	
ffff:

	li	a0, 0
	div	a1, a0
	mov	a0, a1	
	jal	sendx 	// 0
	swap	a0, a1
	jal	sendx 	// 0


	li	a1, 65534
	li	a0, 0x5555
	div	a1, a0
	mov	a0, a1	
	jal	sendx 	// 0x02
	swap	a0, a1
	jal	sendx 	// 0x00
	mv	a1, mulhi
	mov	a0, a1	
	jal	sendx 	// 54
	swap	a0, a1
	jal	sendx 	// 55


	
	jal fail


	ebreak
sendx:	stio	a0, 2(a5)
snx1:		ldio	a0, 4(a5)
		and	a0, 1
		beqz	a0, snx1
	ret

loc:	.word	0x99
	.word	0x55
	.word	0x0
	.word	0x0
	.word	0x0
	.word	0x0
	.word	0x0

subr:	add	a0, 2
	jr	lr


end:
