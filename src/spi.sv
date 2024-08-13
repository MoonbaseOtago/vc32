`define MULT 1
//
//	(C) Paul Campbell Moonbase Otago 2023-2024
//	All Rights Reserved
//
module spi(input clk, input reset,
			input  [1:0]miso,	
			output [1:0]mosi,
			output [1:0]spi_clk, 	
			output [2:0]cs,

			output      interrupt,

			input	[2:0]reg_addr,
			input   [7:0]reg_data_in,
			output  reg[7:0]reg_data_out,
			input	[1:0]reg_sel,
			input	     reg_read,
			input	     reg_write);

	reg [3:0]r_state;
	reg [7:0]r_out;
	reg [7:0]r_in;

	reg  [1:0]r_sel;
	reg  [2:0]r_src;
	reg  [2:0]r_bits;
	reg	      r_interrupt, r_ready;
	assign	interrupt = r_interrupt;
	reg  [4:0]r_clk_count[0:2];
	reg  [4:0]r_count;
	reg  [1:0]r_mode[0:2];
	reg	 [1:0]r_clk;
	reg	 [1:0]r_mosi;
	reg	 [2:0]r_cs;
	assign spi_clk = r_clk;
	assign mosi = r_mosi;
	assign cs = r_cs;

	generate
		genvar I;
	
		for (I = 0; I < 3; I = I+1) begin
			always @(posedge clk)
			if (reg_write && reg_sel == I && reg_addr == 4) begin
				r_clk_count[I] <= reg_data_in[4:0];
				r_mode[I] <= reg_data_in[6:5];
				r_src[I] <= reg_data_in[7];
			end
		end

	endgenerate

	always @(*) begin
		reg_data_out = 8'bx;
		casez ({reg_sel, reg_addr}) // synthesis full_case parallel_case
		5'b??_00?: reg_data_out = r_in;
		5'b??_010: reg_data_out = {7'b0, r_ready};
		5'b??_011: reg_data_out = {7'b0, r_interrupt};
		5'b00_100: reg_data_out = {r_src[0], r_mode[0], r_clk_count[0]};
		5'b01_100: reg_data_out = {r_src[1], r_mode[1], r_clk_count[1]};
		5'b10_100: reg_data_out = {r_src[2], r_mode[2], r_clk_count[2]};
		default:   reg_data_out = 8'bx;
		endcase
	end

	reg [4:0]clk_count;
	reg [1:0]mode;
	always @(*) begin
		case (r_sel) // synthesis full_case parallel_case
		0: clk_count = r_clk_count[0];
		1: clk_count = r_clk_count[1];
		2: clk_count = r_clk_count[2];
		3: clk_count = r_clk_count[0];
		endcase
		case (r_sel) // synthesis full_case parallel_case
		0: mode = r_mode[0];
		1: mode = r_mode[1];
		2: mode = r_mode[2];
		3: mode = 0;
		endcase
	end

	//
	//	addresses:
	//
	//		0: write starts a transaction
	//		0: read last data ends a transaction
	//
	//		1: sends next data
	//		1: reads last data
	//

	wire sel = r_src[r_sel];

	always @(posedge clk)
	if (reset) begin
		r_state <= 0;
		r_cs <= 3'b111;
		r_ready <= 1;
		r_interrupt <= 0;
	end else
	case (r_state)
	0:	if (reg_write && reg_addr == 0) begin
			r_out <= reg_data_in;
			r_bits <= 7;
			r_count <= reg_sel==3?r_clk_count[0]:r_clk_count[reg_sel];
			r_state <= 1;
			r_sel <= reg_sel;
			r_ready <= 0;
			r_interrupt <= 0;
		end
	1:	begin
			r_clk[sel] <= mode[1];
			r_mosi[sel] <= r_out[0];
			if (r_count == 0) begin
				r_count <= clk_count;
				if (r_sel != 3)
					r_cs[r_sel] <= 0;
				r_state <= 2;
			end else begin
				r_count <= r_count-1;
			end
		end
	2:	begin
			if (r_count == 0) begin
				r_count <= clk_count;
				r_clk[sel] <= ~mode[1];
				if (mode[0]) begin
					r_mosi[sel] <= r_out[0];
					r_out <= {1'bx, r_out[7:1]};
				end else begin
					r_in <= {miso[sel], r_in[7:1]};
				end
				r_state <= 3;
			end else begin
				r_count <= r_count-1;
			end
		end
	3:	begin
			if (r_count == 0) begin
				r_count <= clk_count;
				r_clk[sel] <= mode[1];
				if (~mode[0]) begin
					if (r_bits != 0) begin
						r_mosi[sel] <= r_out[0];
						r_out <= {1'bx, r_out[7:1]};
					end
				end else begin
					r_in <= {miso[sel], r_in[7:1]};
				end
				r_bits <= r_bits - 1;
				if (r_bits == 0) begin
					r_ready <= 1;
					r_interrupt <= 1;
					r_state <= 4;
				end else begin
					r_state <= 2;
				end
			end else begin
				r_count <= r_count-1;
			end
		end
	4:	begin
			if (reg_write && reg_addr[2] == 0) begin
				r_count <= clk_count;
				r_out <= reg_data_in;
                r_bits <= 7;
                r_count <= 7;
                r_state <= 2;
                r_ready <= 0;
                r_interrupt <= 0;
			end else
			if (reg_read && reg_addr == 0) begin
				r_ready <= 1;
				r_interrupt <= 0;
				r_state <= 0;
				r_cs <= 3'b111;
			end
		end
	default:;
	endcase
	
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

