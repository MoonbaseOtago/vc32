`define MULT 1
//
//	(C) Paul Campbell Moonbase Otago 2023-2024
//	All Rights Reserved
//

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
	reg [VA-1: UNTOUCHED]r_fault_address;
	reg				     r_fault_valid;
	reg				     r_fault_write;
	reg				     r_fault_ins;
	assign reg_read =  {r_fault_address, {(RV-(VA-UNTOUCHED)-3){1'b0}}, r_fault_ins, r_fault_write, r_fault_valid};

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
		r_fault_address <= taddr[VA-1: UNTOUCHED];
	end

//
//	mmu reg
//
//	upper bits address
//
//	6 - I=1, D=0
//  5 - S-1, U=0
//	4:2	address map
//  1 - writeable
//	0 - valid

	reg [4*NMMU-1:0]r_valid;
	reg [2*NMMU-1:0]r_writeable;
	wire [$clog2(NMMU)+1:0]sel = {is_pc|(supmode&mmu_i_proxy), supmode&~mmu_d_proxy, taddr[VA-1:UNTOUCHED]};

	assign mmu_miss_fault = mmu_enable && !r_valid[sel];
	assign mmu_prot_fault = mmu_enable && is_write && !r_writeable[sel[VA-UNTOUCHED:0]];
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
		if (!reg_addr[$clog2(NMMU)+1])
			r_writeable[reg_addr[$clog2(NMMU):0]] <= reg_data[1];
	end
	
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

