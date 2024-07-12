//	(C) Paul Campbell Moonbase Otago 2023-2024
//	All Rights Reserved

module intr(input clk, input reset, 
		output interrupt,

		input uart_intr,
		input sd_intr,
	
		input io_write,
		input [3:0]io_addr,
		input [15:0]io_wdata,
		output reg[15:0]io_rdata);


	//
	//	0 - interrupt
	//  1 - clock
	//  2 - timer
	//	3 - swi
	//	4 - sd
	//

	reg [4:0]r_enable;
	reg		 r_swi, r_timer, r_clock;

	wire [4:0]status = {sd_intr, r_swi, r_timer, r_clock, uart_intr};
	wire [4:0]pending = r_enable&status;
	assign interrupt = |pending;

	always @(*) begin
		case (io_addr) 
		0:	io_rdata = {13'h0, pending};
		1:	io_rdata = {13'h0, status};
		2:	io_rdata = {13'h0, r_enable};

		8:	io_rdata = r_clock_count[15:0];
		9:	io_rdata = r_clock_count[31:16];
		10:	io_rdata = r_clock_cmp[15:0];
		11:	io_rdata = r_clock_cmp[31:16];
		default:	io_rdata = 16'hx;
		endcase
	end

	always @(posedge clk) begin
		if (reset) begin
			r_clock <= 0;
		end else
		if (r_clock_count == r_clock_cmp) begin
			r_clock <= 1;
		end else 
		if (io_write && io_addr == 4) begin
			r_clock <= r_clock|io_wdata[1];
		end else
		if (io_write && io_addr == 5) begin
			r_clock <= r_clock&~io_wdata[1];
		end 
	end

	always @(posedge clk) begin
		if (reset) begin
			r_timer <= 0;
		end else
		if (r_timer_count == 0) begin
			r_timer <= 1;
			r_timer_count <= r_timer_reload;
		end else begin
			r_timer_count <= r_timer_count-1;
			if (io_write && io_addr == 4) begin
				r_timer <= r_timer|io_wdata[2];
			end else
			if (io_write && io_addr == 5) begin
				r_timer <= r_timer&~io_wdata[2];
			end 
		end
	end

	always @(posedge clk) begin
		if (reset) begin
			r_swi <= 0;
		end else
		if (io_write && io_addr == 4) begin
			r_swi <= r_swi|io_wdata[4];
		end else
		if (io_write && io_addr == 5) begin
			r_swi <= r_swi&~io_wdata[4];
		end 
	end

	always @(posedge clk) begin
		if (reset) begin
			r_enable <= 0;
		end else
		if (io_write && io_addr == 8) begin
			r_enable <= io_wdata[4:0];
		end 
	end

	always @(posedge clk) begin
		if (io_write && io_addr == 8) begin
			r_clock_count[15:0] <= io_wdata;
		end else
		if (io_write && io_addr == 9) begin
			r_clock_count[31:16] <= io_wdata;
		end else begin
			r_clock_count <= r_clock_count+1;
		end
		if (io_write && io_addr == 10) begin
			r_clock_cmp[15:0] <= io_wdata;
		end else
		if (io_write && io_addr == 11) begin
			r_clock_cmp[31:16] <= io_wdata;
		end 
	end
	
		
	reg [31:0]r_clock_count;
	reg [31:0]r_clock_cmp;

	reg [15:0]r_timer_reload;
	reg [23:0]r_timer_count;




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

