`define MULT 1
//
//	(C) Paul Campbell Moonbase Otago 2023-2024
//	All Rights Reserved
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

module execute(input clk, input reset,
		input interrupt,
		input [3:0]rd, 
		input [3:0]rs1, 
		input [3:0]rs2, 
		input needs_rs2,
		input [RV-1:0]imm,
		input	load,
		input	store,
		input	io,
		input	trap,
		input	sys_call,
		input	swapsp,
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
		output			io_access,
		input			rdone,
		input	[RV-1:0]rdata,
		output		    fault,
		output			rom_enable,

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
	parameter NMMU = 16;

	assign pc = r_pc[VA-1:1];
	assign rstrobe = {r_read_stall&(~cond[0]|r_wb[0]), r_read_stall&(~cond[0]|~r_wb[0])};
	assign ifetch = r_fetch;
	assign wdata = r_wdata;
	assign addr = r_wb[VA-1:RV/16];
	assign  wmask = r_wmask;
	assign  io_access = r_io_access;
	reg [(RV/8)-1:0]r_wmask;
	reg [RV-1:0]r_wdata;
	reg		r_io_access;

	wire link = ((br&&cond[2])||jmp)&cond[0];


	reg [RV-1:0]r1, r2, r1reg, r2reg;
	reg [RV-1:0]r_8, r_9, r_10, r_11, r_12, r_13, r_14, r_15, r_stmp;
	reg [RV-1:1]r_lr, r_sp, r_epc;
	wire prev_supmode;
`ifdef MULT
	reg [2*RV-1:0]r_mult, c_mult;
`endif

	wire	mmu_trap;
	wire  sys_trap = trap|mmu_trap;

	assign fault = sys_trap|(interrupt&r_ie?sup_enabled:1'b0);

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

	wire [RV-1:0]csr = {{(RV-7){1'b0}}, r_rom_enable, mmu_i_proxy, mmu_d_proxy, mmu_enable, sup_enabled, r_prev_ie, r_ie};

	always @(*)
	if (rs1 == r_wb_addr && r_wb_addr!=0) begin
		r1reg = r_wb;
	end else
	case (rs1) // synthesis full_case parallel_case
	4'b0000:	r1reg = 0;
	4'b0001:	r1reg = {r_lr, 1'b0};
	4'b0010:	r1reg = {r_sp, 1'b0};
	4'b0011:	r1reg = {r_epc, prev_supmode}; 
	4'b0100:	r1reg = csr;
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
	4'b0011:	r2reg = {r_epc, prev_supmode};
	4'b0100:	r2reg = csr;
	4'b0101:	r2reg = mmu_read; 
	4'b0110:	r2reg = r_stmp; 
`ifdef MULT
	4'b0111:	r2reg = r_mult[2*RV-1:RV];
`endif
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
	wire valid = !reset && !r_branch_stall && iready
`ifdef MULT
		&& !r_mult_running
`endif
		;

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
				mult_stall|r_mult_running ? mdone :
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
	reg r_rom_enable;
	assign rom_enable = r_rom_enable;
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
	assign mult_stall = c_mult_running;
	assign mdone = ~c_mult_running&r_mult_running;
	reg	[$clog2(RV)-1:0]r_mult_off, c_mult_off;
	always @(*) begin
		c_mult_off = start_mult?~0:r_mult_off-1;
		if (r_wb_valid && r_wb_addr == 4'b0111) begin
			c_mult = {r_wb, r_mult[RV-1:0]};
		end else begin
			c_mult = start_mult||r_mult_running ? ((start_mult ? {2*RV{1'b0}} : {r_mult[2*RV-2:0], 1'b0}) + (r1[c_mult_off]?{{RV{1'b0}},r2}:{2*RV{1'b0}})):r_mult;
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
	if (!reset && ((valid && !((br|jmp)&!link) && !r_read_stall && !mult_stall) || mdone)) begin
		r_wb_valid <= !(load&!r_read_stall || store);
		r_wb_addr <= (reset ?0 : sys_trap||(interrupt&r_ie) ? 3 : store? 0 : rd);
		r_wb <= link||sys_trap||(interrupt&r_ie)?{pc_plus_1, supmode}: c_wb;
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
	4'b0010:	begin
					r_sp <= r_wb[RV-1:1];
					if (swapsp) r_stmp <= {r_sp, 1'b0};
				end
	4'b0011:	if (sup_enabled) r_epc <= r_wb[RV-1:1];
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
			reg		r_prev_supmode, c_prev_supmode;
			assign prev_supmode = r_prev_supmode;
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
				if (valid && jmp && rs1==3 && sup_enabled) begin
					c_supmode = r_prev_supmode;
				end 
			end


			always @(*) begin
				c_prev_supmode = r_prev_supmode;
				if (reset) begin
					c_prev_supmode = 1;
				end else
				if (r_wb_valid && r_wb_addr == 4'b0011 && c_supmode)
					c_prev_supmode = r_wb[0];
			end


			always @(posedge clk) begin
				r_supmode <= c_supmode;
				r_prev_supmode <= c_prev_supmode;
			end

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

			assign mmu_trap = ((mmu_miss_fault)&r_read_stall) | ((mmu_miss_fault|mmu_prot_fault)&(|wmask));
			assign mmu_fault = mmu_trap;
		end else begin
			assign prev_supmode = 1;
			assign sup_enabled = 1;
			assign mmu_enable = 0;
			assign mmu_trap = 0;
			assign mmu_fault = 0;
		end
	endgenerate

	reg		r_prev_ie, c_prev_ie;
	always @(*) begin
		c_prev_ie = r_prev_ie;
		if (reset) begin
			c_prev_ie = 0;
		end else
		if (valid && !r_read_stall && (sys_trap ||  interrupt&r_ie)) begin
			c_prev_ie = r_ie;
		end else
		if (r_wb_valid && r_wb_addr == 4'b0100 && sup_enabled)
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
		r_ie <= reset ? 0 : valid && (sys_trap || interrupt&&r_ie) ? 0: r_wb_valid && (r_wb_addr == 4) && sup_enabled ? r_wb[0] : valid&&jmp&&rs1==3&&sup_enabled?r_prev_ie : r_ie; 
		r_rom_enable <= reset ? 1 : r_wb_valid && (r_wb_addr == 4) && sup_enabled ? r_wb[6] : r_rom_enable; 
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
	always @(posedge clk) 
		r_io_access <= valid ? io : r_io_access;

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

