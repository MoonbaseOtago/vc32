`define MULT 1
//
//	(C) Paul Campbell Moonbase Otago 2023-2024
//	All Rights Reserved
//

module mmu(input clk,  input reset, input is_pc, input is_write, input is_read, input mmu_enable, input mmu_d_proxy, input supmode,
			input [VA-1:RV/16]pcv,
			input [VA-1:RV/16]addrv, 
			output [PA-1:RV/16]addrp,
			output		   mmu_miss_fault,
			output		   mmu_prot_fault,
			input		   mmu_fault,
			input		   reg_write, 
			output[RV-1:0]reg_read,
			input [RV-1:0]reg_data);

	parameter RV=16;
	parameter PA=RV;
	parameter VA=RV;
	parameter NMMU=8;

	parameter UNTOUCHED = VA-$clog2(NMMU);
	reg [VA-1: UNTOUCHED]r_fault_address;
	reg				     r_fault_type;
	reg				     r_fault_ins;
	reg				     r_fault_sup;
	assign reg_read =  {r_fault_address, {(RV-(VA-UNTOUCHED)-5){1'b0}}, r_fault_ins, r_fault_sup, r_fault_type, 1'b0};

	wire  [VA-1:RV/16]taddr = (!is_write&&is_pc? pcv: addrv);

//
//	mmu reg
//
//	write virt:
//
//	15-X upper bits phys address
//  2 - writeable
//	1 - valid
//  0 - 1
//
//	write phys:

//	15-X upper bits virtual fault address
//	3	fault_ins
//	2	fault_sup
//	1	fault_type	1 valid fault 0 write fault
//	0 - 0
//
//	read:
//
//	15-X upper bits virtual fault address
//	3	fault_ins
//	2	fault_sup
//	1	fault_type	1 valid fault 0 write fault
//	0   0
//
//	

	reg [4*NMMU-1:0]r_valid;
	reg [2*NMMU-1:0]r_writeable;
	wire [$clog2(NMMU)+1:0]sel = {is_pc, supmode&~(mmu_d_proxy&~is_pc), taddr[VA-1:UNTOUCHED]};

	assign mmu_miss_fault = mmu_enable && (is_pc | is_read | is_write) && !r_valid[sel];
	assign mmu_prot_fault = mmu_enable && is_write && !is_pc && !r_writeable[sel[VA-UNTOUCHED:0]];
	reg [PA-1:UNTOUCHED]r_vtop[0:4*NMMU-1];

	assign addrp = {(mmu_enable ? r_vtop[sel]:{{PA-RV{1'b0}}, taddr[VA-1:UNTOUCHED]}), taddr[UNTOUCHED-1:RV/16]};

	wire [$clog2(NMMU)+1:0]reg_addr = {r_fault_ins, r_fault_sup, r_fault_address[VA-1:UNTOUCHED]};;
wire [PA-1:UNTOUCHED]vtop = r_vtop[sel];
wire [PA-1:UNTOUCHED]vtop_3_00 = r_vtop['h30];
	always @(posedge clk)
	if (reset) begin
		r_valid <= 0;
		r_fault_type <= 0;
		r_fault_ins <= 0;
		r_fault_sup <= 0;
	end else
	if (mmu_fault) begin
		r_fault_address <= taddr[VA-1:UNTOUCHED];
		r_fault_type <= mmu_miss_fault;
		r_fault_ins <= is_pc;
		r_fault_sup <= supmode&~(mmu_d_proxy&~is_pc);
	end else
	if (reg_write) begin
		if (reg_data[0]) begin
			r_vtop[reg_addr] <= reg_data[RV-1:RV-(PA-UNTOUCHED)];
			r_valid[reg_addr] <= reg_data[1];
			if (!r_fault_ins)
				r_writeable[reg_addr[$clog2(NMMU):0]] <= reg_data[2];
		end else begin
			r_fault_address <= reg_data[VA-1:UNTOUCHED];
			r_fault_type <= reg_data[1];
			r_fault_sup <= reg_data[2];
			r_fault_ins <= reg_data[3];
		end
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

