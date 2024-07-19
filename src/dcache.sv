// 
//  (C) Paul Campbell Moonbase Otago 2023-2024
//  All Rights Reserved
//
module dcache(input clk, input reset,
		input  [PA-1:0]paddr,
		input	is_byte,
		input	write,
		input	fault,
		input  [RV-1:0]wdata,

		input		 flush_all,
		input		 flush_write,

		input	[3:0]dread,	
		input		 wstrobe_d,
		output	reg[3:0]dwrite,
		input		 rstrobe_d,

		output  reg hit,
		output  reg push,	// if not hit we need to write a line
		output  reg pull,	// if not hit we need to read a line
		output  reg [PA-1:$clog2(LINE_LENGTH)]tag,
		output  reg[RV-1:0]rdata);

	parameter LINE_LENGTH=4;  // cache line length (in bytes)
	parameter NLINES=4;  // cache line length (in bytes)
	parameter RV=16;
	parameter PA=22;

	generate
		reg [LINE_LENGTH*8-1:0]r_data[0:NLINES-1];
//wire [LINE_LENGTH*8-1:0]r0=r_data[0];
		reg [PA-1:$clog2(LINE_LENGTH*NLINES)]r_tag[0:NLINES-1];
		reg [NLINES-1:0]r_dirty;
		reg [NLINES-1:0]r_valid;

		reg [$clog2(LINE_LENGTH*2)-1:0]r_offset, c_offset;
		genvar L, N; 

		reg match, valid, dirty;

		wire [$clog2(NLINES)-1:0]pindex = paddr[$clog2(LINE_LENGTH*NLINES)-1:$clog2(LINE_LENGTH)];
		wire [PA-1:$clog2(LINE_LENGTH*NLINES)]ptag = paddr[PA-1:$clog2(LINE_LENGTH*NLINES)];

		always @(*) begin 
			match = r_tag[pindex] == ptag;
			valid = r_valid[pindex];
			dirty = r_dirty[pindex];
			hit = valid && match;
			push = valid && dirty && !fault && (flush_write ? 1 : !match);
			pull = !hit && !push;
			tag = {pull?ptag:r_tag[pindex], pindex};
			c_offset = wstrobe_d|rstrobe_d ? r_offset+1 : 0;
		end

		wire [LINE_LENGTH*8-1:0]r = r_data[pindex];
		if (LINE_LENGTH == 4) begin
			always @(*)
			case (r_offset)
			0: dwrite = r[7:4];
			1: dwrite = r[3:0];
			2: dwrite = r[15:12];
			3: dwrite = r[11:8];
			4: dwrite = r[23:20];
			5: dwrite = r[19:16];
			6: dwrite = r[31:28];
			7: dwrite = r[27:24];
			endcase
		end
		
	
		if (RV == 16) begin
			if (LINE_LENGTH == 4) begin
				always @(*)
				if (is_byte) begin
					case(paddr[1:0])
					0: rdata = {8'bx, r_data[pindex][7:0]};
					1: rdata = {8'bx, r_data[pindex][15:8]};
					2: rdata = {8'bx, r_data[pindex][23:16]};
					3: rdata = {8'bx, r_data[pindex][31:24]};
					endcase
				end else begin
					if (paddr[1]) begin
						rdata = r_data[pindex][31:16];
					end else begin
						rdata = r_data[pindex][15:0];
					end
				end
			end
		end

		always @(posedge clk)
			r_offset <= c_offset;

		for (L = 0; L < NLINES; L=L+1) begin
			always @(posedge clk)
			if (pindex == L && wstrobe_d && r_offset == (LINE_LENGTH*2-1))
				r_tag[L] <= ptag;

			always @(posedge clk)
			if (reset || flush_all) begin
				r_valid[L] <= 0;
			end else
			if (((write && !valid && !fault) || wstrobe_d&&r_offset == (LINE_LENGTH*2-1)) && pindex == L)
				r_valid[L] <= 1;

			always @(posedge clk)
			if (pindex == L) 
			if (write && hit && !fault) begin
				r_dirty[L] <= 1;
			end else
			if (rstrobe_d&&(r_offset == (LINE_LENGTH*2-1))) begin
				r_dirty[L] <= 0;
			end

			for (N = 0; N < LINE_LENGTH*2; N=N+1) begin
				always @(posedge clk)
				if (pindex == L) 
				if (write && hit && !fault && r_offset == (2*LINE_LENGTH-1)) begin
					casez ({is_byte, paddr[1:0]}) // synthesis full_case parallel_case
					3'b1_?0: r_data[L][N*4+3:N*4] <= wdata[3:0];
					3'b1_?1: r_data[L][N*4+3:N*4] <= wdata[7:4];
					3'b0_00: r_data[L][N*4+3:N*4] <= wdata[3:0];
					3'b0_01: r_data[L][N*4+3:N*4] <= wdata[7:4];
					3'b0_10: r_data[L][N*4+3:N*4] <= wdata[11:8];
					3'b0_11: r_data[L][N*4+3:N*4] <= wdata[15:12];
					endcase
				end else
				if (wstrobe_d && r_offset == (N^1)) begin
					r_data[L][N*4+3:N*4] <= dread;
				end
			end
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

