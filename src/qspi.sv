`define MULT 1
//
//	(C) Paul Campbell Moonbase Otago 2023-2024
//	All Rights Reserved
//
module qspi(input clk, input reset,
			output [3:0]uio_oe,	
			output [3:0]uio_out,	
			output [1:0]cs,

			input	    req,
			input	    i_d,
			input		mem,
			input		write,
			input [PA-1:$clog2(LINE_LENGTH)]paddr,

			output	reg  wstrobe_d,
			output	reg  wstrobe_i,
			input	[3:0]dwrite,
			output	reg  rstrobe_d,
	
			input	[3:0]reg_addr,
			input   [7:0]reg_data,
			input	     reg_write);

	parameter LINE_LENGTH=4;  // cache line length (in bytes)
	parameter PA=24;
	parameter RV=16;

	reg [3:0]r_read_delay[0:1];
	wire      [1:0]r_quad = 2'b01;
	reg      [1:0]r_mask;

	reg		[1:0]r_cs, c_cs;	
	reg		[3:0]r_uio_out, c_uio_out;
	reg		[1:0]r_uio_oe, c_uio_oe;
	reg			 r_ind, c_ind;
	assign cs = r_cs;
	assign	uio_oe = {r_uio_oe[1], r_uio_oe[1], r_uio_oe};
	assign	uio_out = r_uio_out;
	
	generate

		always @(posedge clk)
		if (reset) begin
			r_read_delay[0] <= 7;	// 8 clocks for RAM 
			r_read_delay[1] <= 4;	// 5 clocks for ROM
			r_mask <= 2'b10;
		end else
		if (reg_write) begin
			r_read_delay[reg_addr[0]] <= reg_data[3:0];
			r_mask[reg_addr[0]] <= reg_data[7];
		end

		reg [4:0]r_state, c_state;
		reg [4:0]r_count, c_count;

		always @(posedge clk) begin
			r_state <= (reset? 0:c_state);
			r_cs <= (reset? 2'b11:c_cs);	
			r_uio_out <= c_uio_out;
			r_uio_oe <= (reset?0:c_uio_oe);
			r_count <= c_count;
			r_ind <= reset?0:c_ind;
		end

		wire [6:0]const_38 = 7'h38;
		wire [6:0]const_eb = 7'h6b;
		wire [6:0]const_35 = 7'h35;
		wire [6:0]const_ab = 7'h2b;

		always @(*) begin
			c_ind = r_ind;
			c_state = r_state;
			c_uio_oe = r_uio_oe;
			c_uio_out = r_uio_out;
			c_cs = r_cs;
			c_count = r_count;
			rstrobe_d = 0;
			wstrobe_i = 0;
			wstrobe_d = 0;
			case (r_state)	// synthesis full_case parallel_case
			31: if (req)
			   if (r_quad[mem]) begin
					c_state = 1;
					c_cs[mem] = 0;
					c_uio_oe = 2'b11;
					if (write) begin
						c_uio_out = 4'h3;
					end else begin
						c_uio_out = 4'he;
					end
			   end else begin
					c_state = 2;
					c_cs[mem] = 0;
					c_uio_oe = 2'b01;
					if (write) begin
						c_uio_out = 4'bxxx0;
					end else begin
						c_uio_out = 4'bxxx1;
					end
					c_count = 6;
			   end
			 1:begin
					c_state = 9;
					if (write) begin
						c_uio_out = 4'h8;
					end else begin
						c_uio_out = 4'hb;
					end
			   end
			2: begin
					if (r_count == 0) begin
						c_state = 9;
					end
					if (write) begin
						c_uio_out = {3'bxxx, const_38[r_count[2:0]]};
					end else begin
						c_uio_out = {3'bxxx, const_eb[r_count[2:0]]};
					end
					c_count = r_count-1;
			   end
			9: begin
					c_state = 10;
					c_uio_oe = 2'b11;
					c_uio_out = {{(24-PA){1'b0}}, paddr[PA-1:20]};
			   end
			10:begin
					c_state = 11;
					c_uio_out = paddr[19:16];
			   end
			11:begin
					c_state = 12;
					c_uio_out = paddr[15:12];
			   end
			12:begin
					c_state = 13;
					c_uio_out = paddr[11:8];
			   end
			13:begin
					c_state = 14;
					c_uio_out = paddr[7:4];
			   end
			14:begin
					c_state = (write? 15 : 17);
					c_count = 2*LINE_LENGTH-1;
					c_uio_out = {paddr[3:$clog2(LINE_LENGTH)], {$clog2(LINE_LENGTH){1'b0}}};
			   end
			15:begin		
					if (r_count == 0) begin
						c_state = 16;
					end
					rstrobe_d = 1;
					c_uio_out = dwrite;
					c_count = r_count-1;
			   end
			16:begin
					c_state = 31;
					c_cs = 2'b11;
					c_uio_oe = 2'b00;
			   end
			17:begin
					c_state = 18;
					if (r_mask[mem]) begin
						c_uio_out = 0;
					end else begin
						c_uio_oe = 2'b00;
					end
			   end
			18:begin
					c_state = 19;
					c_count = {1'b0, r_read_delay[mem]};
			   end
			19:begin
					if (r_count == 0) begin
						c_count = 2*LINE_LENGTH-1;
						c_state = 20;
					end else begin
						c_count = r_count - 1;
					end
					c_uio_oe = 2'b00;
			   end
			20:begin
					if (r_count == 0) begin
						c_cs = 2'b11;
						c_state = 31;
					end
					c_count = r_count - 1;
					wstrobe_i = i_d;
					wstrobe_d = ~i_d;
			   end

			0: begin
					c_cs = r_ind? 2'b10: 2'b00;	// send ab to power up then optionally 35 to 0 to go into quad mode
					c_uio_oe = 2'b01;
					c_uio_out = {3'bxxx, ~r_ind};
					c_count = 6;
					c_state = 21;
			   end
		    21:begin
					if (r_count == 0) begin
						c_state = 22;
					end
					c_count = r_count-1;
					c_uio_out = {3'bxxx, (r_ind?const_35[r_count[2:0]]:const_ab[r_count[2:0]])};
			   end
		    22:begin
					c_state = (r_ind?31:0);
					c_ind = 1;
					c_uio_oe = 2'b00;
					c_cs = 2'b11;
			   end
			endcase
		end
		

	endgenerate
	
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

