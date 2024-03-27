`default_nettype none

module tt_um_vc32_cpu #( parameter MAX_COUNT = 24'd10_000_000 ) (
    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

	parameter RV=16;
	parameter VA=16;
	parameter PA=18;
	parameter MMU=1;
	parameter NMMU=8;
	

	wire [RV-1:0]rdata, wdata;
	wire [PA-1:RV/16]raddr, waddr;
	wire rdone, wdone;
	wire [1:0]rreq;
	wire [(RV/8)-1:0]wmask;

	wire [(RV/8)-1:0]all_on = ~0;

	
	reg [7:0]w_out;
	generate	
		if (RV==16) begin
			always @(*)
				w_out = wmask[0]?wdata[7:0]:wdata[15:8];
		end else begin
			always @(*)
			if (wmask[0]) begin
				w_out = wdata[7:0];
			end else 
			casez (wmask[3:1]) // synthesis full_case parallel_case
			3'b??1: w_out = wdata[15:8];
			3'b?1?: w_out = wdata[23:16];
			3'b1??: w_out = wdata[31:24];
			endcase
		end
	endgenerate

	reg r_reset;
	always @(posedge clk)
		r_reset <= ~rst_n;
	reg [3:0]r_state;
	reg [7:0]r_out;
	assign uo_out = r_out;
	reg [15:0]r_in;
	assign rdata = r_in;
	reg r_rdone;
	assign rdone = r_rdone;
	reg r_wdone;
	assign wdone = r_wdone;
	reg r_latch_lo, r_latch_hi, r_write, r_ind;
	assign uio_oe=8'h7f;
	assign uio_out = {4'b0000, r_latch_lo, r_latch_hi, r_write, r_ind};
	wire interrupt = uio_in[7]; 
	always @(posedge clk)
	if (r_reset) begin
		r_state <= 0;		
		r_latch_lo <= 0;
		r_latch_hi <= 0;
		r_write <= 0;
		r_rdone <= 0;
		r_wdone <= 0;
	end else
	if (ena) 
	case (r_state) 
	0:	begin
			r_write <= 0;
			r_ind <= 0;
			r_rdone <= 0;
			r_wdone <= 0;
			if (|wmask) begin
				r_out <= waddr[PA-1:16];
				r_latch_hi <= 1;
				r_state <= 1;
			end else
			if (|rreq) begin
				r_out <= raddr[PA-1:16];
				r_latch_hi <= 1;
				r_state <= 5;
			end
		end
	1:	begin
			r_out <= waddr[15:8];
			r_latch_hi <= 1;
			r_latch_lo <= 1;
			r_state <= 2;
		end
	2:	begin
			r_out <= (RV==16 ? {waddr[7:1], 1'bx} : {waddr[7:2], 2'bxx});
			r_latch_hi <= 0;
			r_latch_lo <= 1;
			r_ind <= ~wmask[0];
			r_state <= 3;
		end
	3:	begin
			r_out <= w_out;
			r_latch_lo <= 0;
			r_write <= 1;
			r_state <= (wmask!=all_on ?4:9);
			r_wdone <= (wmask!=all_on);
		end
	4:	begin
			r_out <= wdata[15:8];
			r_ind <= 1;
			r_write <= 1;
			r_wdone <= 1;
			r_state <= 9;
		end
	5:	begin
			r_out <= raddr[15:8];
			r_latch_hi <= 1;
			r_latch_lo <= 1;
			r_state <= 6;
		end
	6:	begin
			r_ind <= !rreq[0];
			r_out <= (RV==16 ? {raddr[7:1], 1'bx} : {raddr[7:2], 2'bxx});
			r_latch_hi <= 0;
			r_latch_lo <= 1;
			r_state <= 7;
		end
	7:	begin
			r_in[7:0] <= ui_in;
			r_latch_lo <= 0;
			r_ind <= 1;
			r_rdone <= ~(&rreq);
			r_state <= ~(&rreq)? 9:8;
		end
	8:	begin
			r_in[15:8] <= ui_in;
			r_rdone <= 1;
			r_state <= 9;
		end
	9:	begin
			r_rdone <= 0;
			r_wdone <= 0;
			r_write <= 0;
			r_state <= 0;
		end
	endcase


	cpu   #(.RV(RV), .VA(VA), .PA(PA), .MMU(MMU), .NMMU(NMMU))cpu(.clk(clk), .reset_in(r_reset|!ena), 
			.interrupt(interrupt),
			.raddr(raddr),
			.rdata(rdata),
			.rreq(rreq),
			.rdone(rdone),
			.waddr(waddr),
			.wmask(wmask),
			.wdata(wdata),
			.wdone(wdone));

	

		


endmodule
