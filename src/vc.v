`define MULT 1
//
//	VC - minimal 32-bit C-only riscv - only has 8 regs
//	(C) Paul Campbell Moonbase Otago 2023-2024
//	All Rights Reserved
//
//	registers
//		1 	- lr  *+
//		2	- sp  *+
//		3	- epc *+
//		4	- csr *+
//		5	- mmu *+
//		6   - kernel tmp *+
//		7	- mul_hi *
//		8	- s0
//		9	- s1
//		10 	- a0
//		11	- a1
//		12	- a2
//		13	- a3
//		14	- a4
//		15  - a5
//
//		(*) only accessable with lwsp/stsp and mv (and register specfic instructions), epc can be the source for an indirect jump
//		(+) only accessable from sup mode
//	
//
//	instructions:
//		C.LWSP
//		C.SWSP
//		C.LW
//		C.SW
//		C.J
//		C.JAL
//		C.JR
//		C.JALR
//		C.BEQZ
//		C.BNEZ
//		C.LI		**	constant is 8 bits sext
//		C.LUI		**  constant is 7 bits sext in 14:8
//		C.ADDI		**	constant is 8 bits sext
//		C.ADDIxSP	**  constant is 7 bits at 8:1 or 9:2 for 16/32 bits (aka "add sp, const")
//		C.ADDIxSPN	**  constant is 8 bits at 8:1 or 9:2 for 16/32 bits (aks "lea sp, const(sp)")
//		C.SLLI		(only by 1)
//		C.SRLI		(only by 1)
//		C.SRA		(only by 1)
//		C.ANDI	
//		C.MV
//		C.ADD		
//		C.AND
//		C.OR
//		C.XOR
//		C.SUB
//
//	new instructions
//		C.LB - replaces C.LD			
//		C.SB - replaces C.SD
//		C.LBSP - replaces C.LDSP		**
//		C.SBSP - replaces C.SDSP		**
//		C.LTZ 
//		C.GEZ
//		C.MUL		r, r
//		C.ADDB		r, r, r  sign extended
//		C.ADDBU		r, r, r  0 extended
//		C.SEXT
//		C.ZEXT
//		C.SYSCALL
//		C.SWAPSP
//		C.LUI		**  constant is 7 bits ~sext in 14:8
//
//	** extra bits
//		


module vc(input clk, input reset,
    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe    // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
		);

	parameter RV=16;
	parameter PA=22;
	parameter VA=RV;
	parameter MMU=1;
	parameter NMMU=16;

	wire [ 1:0]rstrobe;
	wire [(RV/8)-1:0]wmask;

	wire [PA-1:RV/16]addrp;
	wire		mmu_reg_write;
	wire[RV-1:0]mmu_reg_data;
	wire[RV-1:0]mmu_read;
	wire		supmode;
	wire		mmu_enable;
	wire		mmu_fault;
	wire		mmu_i_proxy, mmu_d_proxy;
	wire		mmu_miss_fault, mmu_prot_fault;
	generate
		if (MMU == 0) begin
			assign addrp = |wmask|| |rstrobe?addr[VA-1:RV/16]:pc[VA-1:RV/16];
			assign mmu_read = 'bx;
		end else begin
			mmu   #(.VA(VA), .PA(PA), .RV(RV), .NMMU(NMMU))mmu(.clk(clk), .reset(reset), .supmode(supmode),
						.mmu_enable(mmu_enable),
						.mmu_i_proxy(mmu_i_proxy),
						.mmu_d_proxy(mmu_d_proxy),
						.is_pc(~|rstrobe && ~|wmask),
						.is_write(|wmask),
						.pcv(pc[VA-1:RV/16]),
						.addrv(addr[VA-1:RV/16]),
						.addrp(addrp),
						.mmu_miss_fault(mmu_miss_fault),
						.mmu_prot_fault(mmu_prot_fault),
						.mmu_fault(mmu_fault),
						.reg_write(mmu_reg_write),
						.reg_data(mmu_reg_data),
						.reg_read(mmu_read));
		end
	endgenerate
	


	wire		jmp;
	wire		br; 
	wire   [2:0]cond;
	wire		trap;
	wire		sys_call;
	wire		swapsp;
	wire		load;
	wire		store; 
	wire   [3:0]op;
	wire   [3:0]rs1, rs2, rd;
	wire		needs_rs2; 
	wire [RV-1:0]imm;

	wire [VA-1:1]pc;
	wire [VA-1:RV/16]addr;
	wire [15:0]ins;
	wire		 iready;
	wire		 ifetch;
`ifdef MULT
	wire		 mult;
`endif
	generate 
		if (RV == 16) begin
			assign ins = rdata;
		end else begin
			assign ins = pc[1]?rdata[31:16]:rdata[15:0];
		end
	endgenerate

	wire interrupt=0;
	
	wire rdone, wdone;
	wire [RV-1:0]rdata, wdata;

	decode #(.RV(RV))dec(.clk(clk), .reset(reset),
		.supmode(supmode),
		.ins(ins),
		.iready(iready),
		.rdone(rdone&!(|rstrobe)),
		.jmp(jmp),
		.br(br),
		.cond(cond),
		.trap(trap),
		.sys_call(sys_call),
		.swapsp(swapsp),
		.load(load),
		.store(store), 
`ifdef MULT
		.mult(mult),
`endif
		.op(op),
		.rs1(rs1),
		.rs2(rs2),
		.rd(rd),
		.needs_rs2(needs_rs2), 
		.imm(imm));

	execute #(.VA(VA), .RV(RV), .MMU(MMU))ex(.clk(clk), .reset(reset),
		.interrupt(interrupt),
		.pc(pc),
		.ifetch(ifetch),
		.iready(iready),
		.rstrobe(rstrobe),
		.rdone(rdone),
		.wmask(wmask),
		.wdone(wdone),
		.addr(addr),
		.wdata(wdata),
		.rdata(rdata),
		.jmp(jmp),
		.br(br),
		.cond(cond),
		.trap(trap),
		.sys_call(sys_call),
		.swapsp(swapsp),
		.load(load),
		.store(store), 
`ifdef MULT
		.mult(mult),
`endif
		.mmu_reg_write(mmu_reg_write),
		.mmu_reg_data(mmu_reg_data),
		.mmu_read(mmu_read),
		.supmode(supmode),
		.mmu_enable(mmu_enable),
		.mmu_fault(mmu_fault),
		.mmu_i_proxy(mmu_i_proxy),
		.mmu_d_proxy(mmu_d_proxy),
		.mmu_miss_fault(mmu_miss_fault),
		.mmu_prot_fault(mmu_prot_fault),
		.op(op),
		.rs1(rs1),
		.rs2(rs2),
		.rd(rd),
		.needs_rs2(needs_rs2), 
		.imm(imm));

	
	parameter LINE_LENGTH=4;  // cache line length (in bytes)
	parameter I_NLINES=4;  // cache line length (in bytes)
	parameter D_NLINES=4;  // cache line length (in bytes)

	wire d_is_byte, d_write, fault;
	wire i_hit, i_pull;
	wire d_hit, d_push, d_pull;
	wire d_rstrobe_d, d_wstrobe_d, i_wstrobe_d;
	wire [PA-1:$clog2(LINE_LENGTH)]d_tag, i_tag;
	wire [3:0]dwrite;
	wire [PA-1:0]phys_addr = {addrp, |wmask|| |rstrobe? addr[$clog2(LINE_LENGTH)-1:0]: {pc[$clog2(LINE_LENGTH)-1],1'bx}};

	assign rdone = d_hit && |rstrobe && !(fault|d_pull|d_push);
	assign wdone = d_hit && |wmask && !(fault|d_pull|d_push);


	icache #(.PA(PA), .LINE_LENGTH(LINE_LENGTH), .RV(RV), .NLINES(I_NLINES))icache(.clk(clk), .reset(reset),
		.paddr(phys_addr),
		.fault(fault),

		.dread(uio_in[3:0]),	
		.wstrobe_d(i_wstrobe_d),

		.hit(i_hit),
		.pull(i_pull),	// if not hit we need to read a line
		.tag(i_tag),
		.rdata(ins));

	dcache #(.PA(PA), .LINE_LENGTH(LINE_LENGTH), .RV(RV), .NLINES(D_NLINES))dcache(.clk(clk), .reset(reset),
		.paddr(phys_addr),
		.is_byte(d_write),
		.write(d_write),
		.fault(fault),
		.wdata(wdata),

		.dread(uio_in[3:0]),	
		.wstrobe_d(d_wstrobe_d),
		.dwrite(dwrite),
		.rstrobe_d(d_rstrobe_d),

		.hit(d_hit),
		.push(d_push),	// if not hit we need to write a line
		.pull(d_pull),	// if not hit we need to read a line
		.tag(d_tag),
		.rdata(rdata));

	wire [PA-1:$clog2(LINE_LENGTH)]ctag = ifetch?i_tag:d_tag;

	wire	io_write = 0;
	wire [7:0]io_data=0;
	wire [7:0]io_addr=0;
	qspi  #(.RV(RV), .LINE_LENGTH(LINE_LENGTH), .PA(PA))qspi(.clk(clk), .reset(reset),
		    .uio_oe(uio_oe[3:0]),
            .uio_out(uio_out[3:0]),
            .cs(uo_out[1:0]),

            .req((ifetch&i_pull)|((|rstrobe| |wmask)&(d_pull|d_push))),
            .i_d(ifetch),
            .mem(ctag[PA-1:PA-8]=={(7){1'b1}}),  
            .write(|wmask && d_push),
            .paddr(ctag),

            .wstrobe_d(d_wstrobe_d),
            .wstrobe_i(i_wstrobe_d),
            .dwrite(dwrite),
            .rstrobe_d(d_rstrobe_d),

            .reg_addr(io_addr[3:0]),
            .reg_data(io_data[7:0]),
            .reg_write(io_write&&(io_addr[7:4]==0)));

 

endmodule



/* For Emacs:
 * Local Variables:
 * mode:c
 * indent-tabs-mode:t
 * tab-width:4
 * c-basic-offset:4
 * End:
 * For VIM:
 * vim:set softtabstop=4 shiftwidth=4 tabstop=4:
 */
