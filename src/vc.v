`define MULT 1
//
//	VC - minimal 32-bit C-only riscv - only has 8 regs
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
//
//	** extra bits
//		


`define OP_ADD	0
`define OP_SUB	1
`define OP_XOR	2
`define OP_OR	3
`define OP_AND	4
`define OP_SLL	5
`define OP_SRA	6
`define OP_SRL	7
`define OP_ADDB	8
`define OP_ADDBU 9

module decode(input clk, input reset,
	    input [15:0]ins, 
		input rdone,

		output iready,
		output jmp,
		output br, 
		output [2:0]cond,
		output trap,
		output sys_call,
		output load,
		output store, 
`ifdef MULT
		output mult,
`endif
		output [3:0]op,
		output [3:0]rs1, output[3:0]rs2, output [3:0]rd,
		output needs_rs2, 
		output [RV-1:0]imm);

	parameter RV=32;	// register width

	reg		r_ready; assign iready = r_ready;
	always @(posedge clk)
		r_ready <= rdone&!reset;
	reg		r_trap, c_trap; assign trap = r_trap;
	reg		r_sys_call, c_sys_call; assign sys_call = r_sys_call;
	reg		r_load, c_load; assign load = r_load;
	reg		r_store, c_store; assign store = r_store;
	reg[2:0]r_cond, c_cond; assign cond = r_cond;
	reg		r_jmp, c_jmp; assign jmp = r_jmp;
	reg		r_br, c_br; assign br = r_br;
	reg[3:0]r_op, c_op; assign op = r_op;
	reg[3:0]r_rs1, c_rs1; assign rs1 = r_rs1;
	reg[3:0]r_rs2, c_rs2; assign rs2 = r_rs2;
	reg[3:0]r_rd, c_rd; assign rd = r_rd;
	reg		r_needs_rs2, c_needs_rs2; assign needs_rs2 = r_needs_rs2;
	reg[RV-1:0]r_imm, c_imm; assign imm = r_imm;
`ifdef MULT
	reg		r_mult, c_mult; assign mult = r_mult;
`endif

	always @(*) begin
		c_trap = 0;
		c_load = 0;
		c_store = 0;
		c_cond = 3'bx;
		c_needs_rs2 = 0;
		c_op = 4'bx;
		c_rs1 = 4'bx;
		c_rs2 = 4'bx;
		c_rd = 4'bx;
		c_imm = {RV{1'bx}};
		c_jmp = 0;
		c_br = 0;
		c_sys_call = 0;
`ifdef MULT
		c_mult = 0;
`endif
		case (ins[1:0])  // synthesis full_case parallel_case
		2'b00:
			case (ins[15:13]) // synthesis full_case parallel_case
			3'b000: begin	// addi4sp
						c_op = `OP_ADD;
						c_trap = ins[11:2]==0;
						if (RV == 16) begin
							c_imm = {{(RV-9){1'b0}}, ins[9:7],ins[5],ins[12:10],ins[6],1'b0};
						end else begin
							c_imm = {{(RV-10){1'b0}}, ins[9:7],ins[5],ins[12:10],ins[6],2'b0};
						end
						c_rd = {1'b1, ins[4:2]};
						c_rs1 = 2;
					end
			3'b010: begin 	// lw
						c_load = 1;
						c_op = `OP_ADD;
						c_cond = 3'bxx0;
						c_rd = {1'b1, ins[4:2]};
						c_rs1 = {1'b1, ins[9:7]};
						if (RV==16) begin
							c_imm = {{(RV-6){1'b0}}, ins[5], ins[12:10],ins[6], 1'b0};
						end else begin
							c_imm = {{(RV-7){1'b0}}, ins[5], ins[12:10],ins[6], 2'b0};
						end
				    end
			3'b011: begin 	// lb
						c_load = 1;
						c_op = `OP_ADD;
						c_cond = 3'bxx1;
						c_rd = {1'b1, ins[4:2]};
						c_rs1 = {1'b1, ins[9:7]};
						if (RV==16) begin
							c_imm = {{(RV-5){1'b0}},         ins[12:10],ins[6], ins[5]};
						end else begin
							c_imm = {{(RV-5){1'b0}},         ins[11:10],ins[6], ins[12], ins[5]};
						end
					end
			3'b110: begin 	// sw
						c_store = 1;
						c_cond = 3'bxx0;
						c_op = `OP_ADD;
						c_rs2 = {1'b1, ins[4:2]};
						c_rs1 = {1'b1, ins[9:7]};
						if (RV==16) begin
							c_imm = {{(RV-6){1'b0}}, ins[5], ins[12:10],ins[6], 1'b0};
						end else begin
							c_imm = {{(RV-7){1'b0}}, ins[5], ins[12:10],ins[6], 2'b0};
						end
					end
			3'b111: begin 	// sb
						c_store = 1;
						c_cond = 3'bxx1;
						c_op = `OP_ADD;
						c_rs2 = {1'b1, ins[4:2]};
						c_rs1 = {1'b1, ins[9:7]};
						if (RV==16) begin
							c_imm = {{(RV-5){1'b0}},         ins[12:10],ins[6], ins[5]};
						end else begin
							c_imm = {{(RV-5){1'b0}},         ins[11:10],ins[6], ins[12], ins[5]};
						end
					end
			default: c_trap = 1;
			endcase
		2'b01:casez (ins[15:13]) // synthesis full_case parallel_case
			3'b000:	begin	// addi **
						c_op = `OP_ADD;
						c_rs1 = {1'b1, ins[9:7]};
						c_rd = {1'b1, ins[9:7]};
						c_imm = {{(RV-7){ins[4]}}, ins[3:2],  ins[12:10], ins[6:5]};
					end
			3'b001:	begin	// jal
						c_br = 1;
						c_cond = 3'b1x1;
						c_op = `OP_ADD;
						c_imm = {{(RV-11){ins[12]}}, ins[8], ins[10:9], ins[6],ins[7],ins[2],ins[11],ins[5:3],1'b0};			
						c_rd = 1;
					end
			3'b010:	begin	// li
						c_op = `OP_ADD;
						c_rs1 = 0;
						c_rd = {1'b1, ins[9:7]};
						c_imm = {{(RV-7){ins[4]}}, ins[3:2],  ins[12:10], ins[6:5]};
					end
			3'b011:	if (ins[10:7] == 2) begin	// addi4sp  ** 
						c_op = `OP_ADD;
						c_rd = 2;
						c_rs1 = 2;
						if (RV==16) begin
							c_imm = {{(RV-7){ins[4]}},ins[3:2],ins[12:11],ins[5],ins[6],1'b0};
						end else begin
							c_imm = {{(RV-8){ins[4]}},ins[3:2],ins[12:11],ins[5],ins[6],2'b00};
						end
					end else begin				// lui **
						c_op = `OP_ADD;
						c_rd = {1'b1, ins[9:7]};
						c_rs1 = 0;
						c_imm = {{(RV-14){ins[11]}}, ins[12], ins[6:2],8'b0};
					end
			3'b100:	begin
						c_rd = {1'b1, ins[9:7]};
						c_rs1 = {1'b1, ins[9:7]};
						c_rs2 = {1'b1, ins[4:2]};
						c_imm = {{(RV-6){1'b0}}, ins[2], ins[12], ins[4:3], ins[6:5]};
						case (ins[11:10]) // synthesis full_case parallel_case
						2'b00: c_op = `OP_SRL;
						2'b01: c_op = `OP_SRA;
						2'b10: c_op = `OP_AND;
						2'b11: begin
								c_needs_rs2 = 1;
								case ({ins[12],ins[6:5]}) // synthesis full_case parallel_case
								3'b0_00:	c_op = `OP_SUB;
								3'b0_01:	c_op = `OP_XOR;
								3'b0_10:	c_op = `OP_OR;
								3'b0_11:	c_op = `OP_AND;
								default: c_trap = 1;
								endcase
							   end
						endcase
					end
			3'b101:	begin	// j
						c_br = 1;
						c_cond = 3'b1x0;
						c_op = `OP_ADD;
						c_imm = {{(RV-11){ins[12]}}, ins[8], ins[10:9], ins[6],ins[7],ins[2],ins[11],ins[5:3],1'b0};
					end
			3'b11?:	begin	//  beqz/bnez
						c_br = 1;
						c_cond = {2'b00, ins[13]};	// beqz/bnez
						c_op = `OP_ADD;
						c_rs1 = {1'b1, ins[9:7]};
						c_imm =  {{(RV-8){ins[12]}},ins[6:5],ins[2],ins[11:10],ins[4:3],1'b0};
					end
			default: c_trap = 1;
			endcase
		2'b10:
			casez (ins[15:13])  // synthesis full_case parallel_case
			3'b000:	begin	// slli
						c_op = `OP_SLL;
						c_rd = {1'b1, ins[9:7]};
						c_rs1 = {1'b1, ins[9:7]};
					end
			3'b010:	begin	// lwsp  **
						c_load = 1;
						c_cond = 3'bxx0;
						c_op = `OP_ADD;
						c_rd = ins[10:7];
						c_rs1 = 2;
						if (RV == 16) begin
							c_imm = {{(RV-8){1'b0}}, ins[4:2], ins[12:11], ins[5],ins[6], 1'b0};
						end else begin
							c_imm = {{(RV-9){1'b0}}, ins[4:2], ins[12:11], ins[5],ins[6], 2'b0};
						end
					end
			3'b011:	begin	// lbsp  **
						c_load = 1;
						c_cond = 3'bxx1;
						c_op = `OP_ADD;
						c_rd = ins[10:7];
						c_rs1 = 2;
						if (RV == 16) begin
							c_imm = {{(RV-7){1'b0}},          ins[3:2], ins[12:11],ins[5], ins[6], ins[4]};
						end else begin
							c_imm = {{(RV-7){1'b0}},          ins[2],   ins[12],ins[6:4], ins[11], ins[3]};
						end
					end
			3'b100:	if (!ins[12]) begin
						if (ins[6:2] == 0) begin	// jr
							c_jmp = 1;
							c_op = `OP_ADD;
							c_cond = 3'bxx0;
							c_rs1 = ins[10:7];
							c_rs2 = 0;
							c_needs_rs2 = 1;
						end else begin	// mv
							c_op = `OP_ADD;
							c_rd = ins[10:7];
							c_rs1 = 0;
							c_rs2 = ins[5:2];
							c_needs_rs2 = 1;
						end
					end else begin
						if (ins[6:2] == 0) begin	// jalr
							c_trap = ins[10:7]==0; 
							c_jmp = 1;
							c_cond = 3'bxx1;
							c_op = `OP_ADD;
							c_rd = 1;
							c_rs1 = ins[10:7];
							c_rs2 = 0;
							c_needs_rs2 = 1;
						end else begin	// ad
							c_op = `OP_ADD;
							c_rd = ins[10:7];
							c_rs1 = ins[10:7];
							c_rs2 = ins[5:2];
							c_needs_rs2 = 1;
						end
					end
			3'b110:	begin	// swsp  **
						c_store = 1;
						c_cond = 3'bxx0;
						c_rs2 = ins[10:7];
						c_op = `OP_ADD;
						c_rs1 = 2;
						if (RV == 16) begin
							c_imm = {{(RV-8){1'b0}}, ins[4:2], ins[12:11], ins[5],ins[6], 1'b0};
						end else begin
							c_imm = {{(RV-9){1'b0}}, ins[4:2], ins[12:11], ins[5],ins[6], 2'b0};
						end
					end
			3'b111:	begin	// sbsp  **
						c_store = 1;
						c_cond = 3'bxx1;
						c_rs2 = ins[10:7];
						c_rs1 = 2;
						c_op = `OP_ADD;
						if (RV == 16) begin
							c_imm = {{(RV-7){1'b0}},          ins[3:2], ins[12:11],ins[5], ins[6], ins[4]};
						end else begin
							c_imm = {{(RV-7){1'b0}},          ins[2],   ins[12],ins[6:4], ins[11], ins[3]};
						end
					end
			default: c_trap = 1;
			endcase
		2'b11:	casez (ins[15:13]) // synthesis full_case parallel_case
			3'b000:	begin	//  
						casez (ins[12:2]) // synthesis full_case parallel_case
						11'b0??: begin				// trap instructions (use 01 for break)
									c_sys_call = 0;
									c_trap = 1;
							   end
						11'b0101:begin				// syscall
									c_sys_call = 1;
									c_trap = 1;
							   end
						default: c_trap = 1;
						endcase
				    end
			3'b100:	begin
						c_rd = {1'b1, ins[9:7]};
						c_rs1 = {1'b1, ins[9:7]};
						c_rs2 = {1'b1, ins[4:2]};
						c_imm = {{(RV-6){1'b0}}, ins[2], ins[12], ins[4:3], ins[6:5]};
						case (ins[11:10]) // synthesis full_case parallel_case
						2'b11: begin
								c_needs_rs2 = 1;
								case ({ins[12],ins[6:5]}) // synthesis full_case parallel_case
`ifdef MULT
								3'b0_00:	c_mult = 1;
`endif
								3'b0_01:	c_op = `OP_ADDB;
								3'b0_10:	c_op = `OP_ADDBU;
								default:	c_trap = 1;
								endcase
							   end
						default: c_trap = 1;
						endcase
					end
			3'b11?:	begin	//  bltz/bgez
						c_br = 1;
						c_cond = {2'b01, ins[13]};	// bltz/bgez
						c_rs1 = {1'b1, ins[9:7]};
						c_op = `OP_ADD;
						c_imm =  {{(RV-8){ins[12]}},ins[6:5],ins[2],ins[11:10],ins[4:3],1'b0};
					end
			default: c_trap = 1;
		    endcase
		endcase
	end

	always @(posedge clk) 
	if (rdone) begin
		r_trap <= c_trap;
		r_sys_call <= c_sys_call;
		r_rs1 <= c_rs1;
		r_rs2 <= c_rs2;
		r_needs_rs2 <= c_needs_rs2;
		r_rd <= c_rd;
		r_imm <= c_imm;
		r_store <= c_store;
		r_load <= c_load;
`ifdef MULT
		r_mult <= c_mult;
`endif
		r_op <= c_op;
		r_br <= c_br;
		r_cond <= c_cond;
		r_jmp <= c_jmp;
	end


endmodule

module execute(input clk, input reset,
		input interrupt,
		input [3:0]rd, 
		input [3:0]rs1, 
		input [3:0]rs2, 
		input needs_rs2,
		input [RV-1:0]imm,
		input	load,
		input	store,
		input	trap,
		input	sys_call,
`ifdef MULT
		input	mult,
`endif
		input	[3:0]op,
		input   jmp, 
		input br, input [2:0]cond,
		
		input	iready,
		output	[VA-1:1]pc,
		output	[VA-1:RV/16]addr,
		output	[RV-1:0]wdata,
		input			wdone,
		output	[(RV/8)-1:0]wmask,
		output	[1:0]	rstrobe,	
		output			ifetch,	
		input			rdone,
		input	[RV-1:0]rdata,

		output		mmu_reg_write,
		output[RV-1:0]mmu_reg_data,
		input[RV-1:0]mmu_read,
		output		supmode,
		output		mmu_enable,
		output		mmu_fault,
		output		mmu_i_proxy,
		output		mmu_d_proxy,
		input		mmu_miss_fault, mmu_prot_fault
	);
	parameter RV=32;
	parameter VA=RV;
	parameter MMU = 0;

	assign pc = r_pc[VA-1:1];
	assign rstrobe = {r_read_stall&(~cond[0]|r_wb[0]), r_read_stall&(~cond[0]|~r_wb[0])};
	assign ifetch = r_fetch;
	assign wdata = r_wdata;
	assign addr = r_wb[VA-1:RV/16];
	assign  wmask = r_wmask;
	reg [(RV/8)-1:0]r_wmask;
	reg [RV-1:0]r_wdata;

	wire link = ((br&&cond[2])||jmp)&cond[0];


	reg [RV-1:0]r1, r2, r1reg, r2reg;
	reg [RV-1:0]r_8, r_9, r_10, r_11, r_12, r_13, r_14, r_15, r_epc, r_stmp;
	reg [RV-1:1]r_lr, r_sp;
`ifdef MULT
	reg [2*RV-1:0]r_mult, c_mult;
`endif

	wire	mmu_trap;
	wire  sys_trap = trap|mmu_trap;

	generate 

		if (VA < RV) begin

			always @(*) 
			if (br) begin
				r1 = {{(RV-VA){1'b0}}, r_pc, sys_trap||interrupt&r_ie?sup_enabled:1'b0};
			end else begin
				r1 = r1reg;
			end

		end else begin

			always @(*) 
			if (br) begin
				r1 = {r_pc, sys_trap||interrupt&r_ie?sup_enabled:1'b0};
			end else begin
				r1 = r1reg;
			end

		end
	endgenerate

	wire sup_enabled;

	always @(*)
	if (rs1 == r_wb_addr && r_wb_addr!=0) begin
		r1reg = r_wb;
	end else
	case (rs1) // synthesis full_case parallel_case
	4'b0000:	r1reg = 0;
	4'b0001:	r1reg = {r_lr, 1'b0};
	4'b0010:	r1reg = {r_sp, 1'b0};
	4'b0011:	r1reg = r_epc; 
	4'b0100:	r1reg = {{(RV-6){1'b0}}, mmu_i_proxy, mmu_d_proxy, mmu_enable, sup_enabled, r_prev_ie, r_ie};
	4'b0101:	r1reg = mmu_read; 
	4'b0110:	r1reg = r_stmp; 
`ifdef MULT
	4'b0111:	r1reg = r_mult[2*RV-1:RV];
`endif
	4'b1000:	r1reg = r_8;
	4'b1001:	r1reg = r_9;
	4'b1010:	r1reg = r_10;
	4'b1011:	r1reg = r_11;
	4'b1100:	r1reg = r_12;
	4'b1101:	r1reg = r_13;
	4'b1110:	r1reg = r_14;
	4'b1111:	r1reg = r_15;
	default:	r1reg = {RV{1'bx}};
	endcase

	reg br_taken;
	always @(*) begin
		casez (cond)  // synthesis full_case parallel_case
		3'b0_00:	br_taken = r1reg == 0;	// beqz
		3'b0_01:	br_taken = r1reg != 0;	// bnez
		3'b0_10:	br_taken = !r1reg[RV-1];// bgez
		3'b0_11:	br_taken = r1reg[RV-1]; // bltz
		3'b1_??:	br_taken = 1;
		endcase
	end

	always @(*) 
	if (!needs_rs2) begin
		r2 = imm;
	end else begin
		r2 = r2reg;
	end
	
	always @(*) 
	if (rs2 == r_wb_addr && r_wb_addr !=0) begin
		r2reg = r_wb;
	end else
	case (rs2) // synthesis full_case parallel_case
	4'b0000:	r2reg = 0;
	4'b0001:	r2reg = {r_lr, 1'b0};
	4'b0010:	r2reg = {r_sp, 1'b0};
	4'b0011:	r2reg = r_epc;
	4'b1000:	r2reg = r_8;
	4'b1001:	r2reg = r_9;
	4'b1010:	r2reg = r_10;
	4'b1011:	r2reg = r_11;
	4'b1100:	r2reg = r_12;
	4'b1101:	r2reg = r_13;
	4'b1110:	r2reg = r_14;
	4'b1111:	r2reg = r_15;
	default: r2reg = {RV{1'bx}};
	endcase
	
	reg r_branch_stall;
	wire valid = !reset && !r_branch_stall && iready;

	reg r_read_stall;
	always @(posedge clk)
		r_read_stall <= reset ? 0 : valid && load ? 1 : r_read_stall&rdone ? 0 : r_read_stall;

`ifdef MULT
	wire mult_stall, mdone;
`endif
	reg r_fetch;
	always @(posedge clk)
		r_fetch <= reset ? 1 : (r_fetch ? !rdone : r_read_stall) ? rdone :
`ifdef MULT
				mult_stall ? !mdone :
`endif
				|r_wmask?wdone : (valid && !load && !r_branch_stall && !store
`ifdef MULT
								 && !mult_stall
`endif
							     );

	wire [RV-1:0]added = r1 + r2;
	reg [RV-1:0]r_wb, c_wb;
	reg [3:0]r_wb_addr;
	reg r_ie;
	reg r_wb_valid;
	always @(*)
`ifdef MULT
	if (mdone) begin
		c_wb = c_mult[RV-1:0];
	end else
`endif
	case (op) // synthesis full_case parallel_case
	`OP_ADD:	c_wb = added;
	`OP_SUB:	c_wb = r1 - r2;
	`OP_XOR:	c_wb = r1 ^ r2;
	`OP_OR:		c_wb = r1 | r2;
	`OP_AND:	c_wb = r1 & r2;
	`OP_SLL:	c_wb = {r1[RV-2:0], 1'b0};
	`OP_SRA:	c_wb = {{1{r1[RV-1]}}, r1[RV-1:1]};
	`OP_SRL:	c_wb = {1'b0, r1[RV-1:1]};
	`OP_ADDB:	c_wb = {{(RV-8){added[7]}}, added[7:0]};
	`OP_ADDBU:	c_wb = {{(RV-8){1'b0}}, added[7:0]};
	endcase

`ifdef MULT
	wire start_mult = valid&mult;
	reg r_mult_running, c_mult_running;
	assign mult_stall = r_mult_running;
	assign mdone = ~c_mult_running&r_mult_running;
	reg	[$clog2(RV)-1:0]r_mult_off, c_mult_off;
	always @(*) begin
		c_mult_off = start_mult?~0:r_mult_off-1;
		if (r_wb_valid && r_wb_addr == 4'b0111) begin
			c_mult = {r_wb, r_mult[RV-1:0]};
		end else begin
			c_mult = start_mult||r_mult_running ? ((start_mult ? {2*RV{1'b0}} : {r_mult[2*RV-2:0], 1'b0}) + (r1[c_mult_off]?{r2,{RV{1'b0}}}:{2*RV{1'b0}})):r_mult;
		end
		c_mult_running = (reset|| r_mult_running&&c_mult_off==0 ? 0 : start_mult ? 1 : r_mult_running);
	end

	always @(posedge clk) begin
		r_mult_off <= c_mult_off;
		r_mult_running <= c_mult_running;
		r_mult <= c_mult;
	end
`endif
	

	always @(posedge clk)
	if (!reset && valid && !((br|jmp)&!link) && !r_read_stall) begin
		r_wb_valid <= !(load&!r_read_stall || store);
		r_wb_addr <= (reset ?0 : sys_trap||(interrupt&r_ie) ? 3 : store? 0 : rd);
		r_wb <= link||sys_trap||(interrupt&r_ie)?{pc_plus_1, r_ie}: c_wb;
		r_wdata <= (cond[0]? {(RV/8){r2reg[7:0]}}:r2reg);
	end else
	if (r_read_stall && rdone) begin
		r_wb_valid <= 1;
		r_wb <= (cond[0] ?{{(RV-8){rdata[7]}}, rdata[7:0]}:rdata);
	end else begin
		r_wb_valid <= 0;
	end

	always @(posedge clk)
	if (r_wb_valid)
	case (r_wb_addr) // synthesis full_case parallel_case
	4'b0001:	r_lr <= r_wb[RV-1:1];
	4'b0010:	r_sp <= r_wb[RV-1:1];
	4'b0011:	if (sup_enabled) r_epc <= r_wb;
	//4'b0100: csr regs (not readable)
	//4'b0101: MMU regs (not readable)
	4'b0110:	if (sup_enabled) r_stmp <= r_wb;
	//4'b0111: multiplier
	4'b1000:	r_8 <= r_wb;
	4'b1001:	r_9 <= r_wb;
	4'b1010:	r_10 <= r_wb;
	4'b1011:	r_11 <= r_wb;
	4'b1100:	r_12 <= r_wb;
	4'b1101:	r_13 <= r_wb;
	4'b1110:	r_14 <= r_wb;
	4'b1111:	r_15 <= r_wb;
	default:;
	endcase

	generate
		if (MMU) begin
			reg		r_supmode, c_supmode;
			assign sup_enabled = r_supmode;
			assign supmode = r_supmode;
			reg r_mmu_enable;
			assign mmu_enable = r_mmu_enable;
			reg r_mmu_i_proxy;
			assign mmu_i_proxy = r_mmu_i_proxy;
			reg r_mmu_d_proxy;
			assign mmu_d_proxy = r_mmu_d_proxy;
			
			assign mmu_reg_data = r_wb;
			assign mmu_reg_write = r_wb_valid && r_wb_addr == 4'b0101 && sup_enabled;

			always @(*) begin
				c_supmode = r_supmode;
				if (reset) begin
					c_supmode = 1;
				end else 
				if (valid && !r_read_stall && (sys_trap ||  interrupt&r_ie)) begin
					c_supmode = 1;
				end else
				if (r_wb_valid && r_wb_addr == 4'b0100 && sup_enabled)
					c_supmode = r_wb[2];
			end


			always @(posedge clk) 
				r_supmode <= c_supmode;

			always @(posedge clk) 
			if (reset) begin
				r_mmu_enable <= 0;
			end else 
			if (r_wb_valid && r_wb_addr == 4'b0100 && sup_enabled)
				r_mmu_enable <= r_wb[3];

			always @(posedge clk) 
			if (reset) begin
				r_mmu_d_proxy <= 0;
			end else 
			if (r_wb_valid && r_wb_addr == 4'b0100 && sup_enabled)
				r_mmu_d_proxy <= r_wb[5];

			always @(posedge clk) 
			if (reset) begin
				r_mmu_i_proxy <= 0;
			end else 
			if (r_wb_valid && r_wb_addr == 4'b0100 && sup_enabled)
				r_mmu_i_proxy <= r_wb[4];

			assign mmu_trap = ((mmu_miss_fault|mmu_prot_fault)&r_read_stall) | ((mmu_miss_fault|mmu_prot_fault)&(|wmask));
			assign mmu_fault = mmu_trap && valid && !r_read_stall;
		end else begin
			assign sup_enabled = 1;
			assign mmu_enable = 0;
			assign mmu_trap = 0;
			assign mmu_fault = 0;
		end
	endgenerate

	reg		r_prev_ie, c_prev_ie;
	always @(*) begin
		c_prev_ie = r_prev_ie;
		if (valid && !r_read_stall && (sys_trap ||  interrupt&r_ie)) begin
			c_prev_ie = r_ie;
		end else
		if (r_wb_valid && r_wb_addr == 4'b0011)
		if (sup_enabled)
				c_prev_ie = r_wb[1];
	end

	always @(posedge clk)
		r_prev_ie <= c_prev_ie;


	reg [VA-1:1 ]r_pc, c_pc;
	wire [VA-1:1 ]pc_plus_1 = r_pc+1;


	always @(*)
	casez ({reset, r_read_stall, valid, sys_trap, sys_call, mmu_trap, interrupt&r_ie, jmp, br&br_taken})  // synthesis full_case parallel_case
	9'b1????????:	c_pc = 0;	// 0	reset
	9'b001100???:	c_pc = 2;	// 4	trap
	9'b0010??1??:	c_pc = 4;	// 8	interruopt
	9'b001110???:	c_pc = 6;	// 12	syscall
	9'b0011?1???:	c_pc = 8;	// 16	mmu
	9'b0010??010:	c_pc = c_wb[VA-1:1];
	9'b0010??0?1:	c_pc = c_wb[VA-1:1];
	9'b0010??000:	c_pc = pc_plus_1;
	9'b01???????:	c_pc = r_pc;
	9'b000??????:	c_pc = r_pc;
	default:		c_pc = r_pc;
	endcase

	always @(posedge clk) begin
		//r_trap <= !reset && valid && (trap || interrupt&&r_ie);
		r_ie <= reset ? 0 : valid && (sys_trap || interrupt&&r_ie) ? 0: r_wb_valid && (r_wb_addr == 4) ? r_wb[0] : valid&&jmp&&rs1==3?r_prev_ie : r_ie; 
		r_pc <= c_pc;
		r_branch_stall <= !reset&valid&(jmp|br&br_taken);
	end


	generate
		if (RV == 16) begin
			wire [1:0]all_on = ~0;
			always @(posedge clk) 
				r_wmask <= reset||wdone ? 0 : |r_wmask? r_wmask : !valid||!store?0: !cond[0]? all_on: {c_wb[0], ~c_wb[0]};
		end else begin
			wire [3:0]all_on = ~0;
			always @(posedge clk) 
				r_wmask <= reset||wdone?0:|r_wmask? r_wmask :!valid||!store?0: !cond[0]? all_on: {c_wb[1:0]==3, c_wb[1:0]==2, c_wb[1:0]==1, c_wb[1:0]==0};
		end
	endgenerate

endmodule

module mmu(input clk,  input reset, input is_pc, input is_write, input mmu_enable, input mmu_i_proxy, input mmu_d_proxy, input supmode,
			input [VA-1:RV/16]pcv,
			input [VA-1:RV/16]addrv, 
			output [PA-1:RV/16]addrp,
			output		   mmu_miss_fault,
			output		   mmu_prot_fault,
			input reg_write, 
			input		   mmu_fault,
			output[RV-1:0]reg_read,
			input [RV-1:0]reg_data);

	parameter RV=16;
	parameter PA=RV;
	parameter VA=RV;
	parameter NMMU=8;

	parameter UNTOUCHED = VA-$clog2(NMMU);
	reg [RV-1: UNTOUCHED]r_fault_address;
	reg				     r_fault_valid;
	reg				     r_fault_write;
	reg				     r_fault_ins;
	assign reg_read =  {r_fault_address, {(RV-UNTOUCHED-3){1'b0}}, r_fault_ins, r_fault_write, r_fault_valid};

	wire  [VA-1:RV/16]taddr = (!is_write&&is_pc? pcv: addrv);

	always @(posedge clk)
	if (reset) begin
		r_fault_valid <= 0;
		r_fault_write <= 0;
		r_fault_ins <= 0;
	end else
	if (mmu_fault) begin
		r_fault_valid <= !mmu_miss_fault;
		r_fault_write <= is_write;
		r_fault_ins <= is_pc;
		r_fault_address <= taddr[RV-1: UNTOUCHED];
	end


	reg [4*NMMU-1:0]r_valid;
	reg [4*NMMU-1:0]r_writeable;
	wire [$clog2(NMMU)+1:0]sel = {supmode&~mmu_d_proxy, is_pc|(supmode&mmu_i_proxy), taddr[VA-1:UNTOUCHED]};

	assign mmu_miss_fault = mmu_enable && !r_valid[sel];
	assign mmu_prot_fault = mmu_enable && is_write && !r_writeable[sel];
	reg [PA-1:UNTOUCHED]r_vtop[0:4*NMMU-1];

	assign addrp = {(mmu_enable ? r_vtop[sel]:{{PA-RV{1'b0}}, taddr[VA-1:UNTOUCHED]}), taddr[UNTOUCHED-1:RV/16]};

	wire [$clog2(NMMU)+1:0]reg_addr = reg_data[$clog2(NMMU)+4-1:2];
	always @(posedge clk)
	if (reset) begin
		r_valid <= 0;
	end else
	if (reg_write) begin
		r_vtop[reg_addr] <= reg_data[RV-1:RV-(PA-UNTOUCHED)];
		r_valid[reg_addr] <= reg_data[0];
		r_writeable[reg_addr] <= reg_data[1];
	end
	
endmodule


module cpu(input clk, input reset_in,
		input interrupt,
		output [PA-1:RV/16]addrp,
		output	[1:0]rreq,
		input	rdone,
		input [RV-1:0]rdata,
		output [(RV/8)-1:0]wmask,
		output [RV-1:0]wdata,
		input wdone);

	parameter RV=16;
	parameter PA=RV;
	parameter VA=RV;
	parameter MMU=0;
	parameter NMMU=8;

	wire [ 1:0]rstrobe;

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
			assign addrp = |wmask||rstrobe?addr[VA-1:RV/16]:pc[VA-1:RV/16];
			assign mmu_read = 'bx;
		end else begin
			mmu   #(.VA(VA), .PA(PA), .RV(RV), .NMMU(NMMU))mmu(.clk(clk), .reset(reset), .supmode(supmode),
						.mmu_enable(mmu_enable),
						.mmu_i_proxy(mmu_i_proxy),
						.mmu_d_proxy(mmu_d_proxy),
						.is_pc(~|rstrobe),
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
	
	assign rreq={RV/8{ifetch}}|rstrobe;

	wire reset = reset_in;
	//wire reset = r_reset;
	//reg r_reset;
	//always @(posedge clk)
		//r_reset <= reset_in;

	wire		jmp;
	wire		br; 
	wire   [2:0]cond;
	wire		trap;
	wire		sys_call;
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

	decode #(.RV(RV))dec(.clk(clk), .reset(reset),
		.ins(ins),
		.iready(iready),
		.rdone(rdone&!(|rstrobe)),
		.jmp(jmp),
		.br(br),
		.cond(cond),
		.trap(trap),
		.sys_call(sys_call),
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
