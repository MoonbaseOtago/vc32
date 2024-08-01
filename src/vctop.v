`default_nettype wire

module vcxx #( parameter MAX_COUNT = 24'd10_000_000 ) (
    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    inout  wire [7:0] uio_io,   // IOs: Bidirectional Input path
//    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
//    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

	wire clk_out;
	clk_wiz_0 clks(.clock_in1(clk), .reset(~rst_n), .clock_out1(clk_out));

	wire [7:0]uio_out;
	wire [7:0]uio_oe;
	tt_um_vc32_cpu   tt_um_vc32_cpu(.clk(clk_out), .rst_n(rst_n), .ena(ena),
			.ui_in      (ui_in),    // Dedicated inputs
        		.uo_out     (uo_out),   // Dedicated outputs
        		.uio_in     (uio_io),   // IOs: Input path
        		.uio_out    (uio_out),  // IOs: Output path
        		.uio_oe     (uio_oe));   // IOs: Enable path (active high: 0=input, 1=output)

	genvar I;
	generate
		for (I = 0; I < 8; I=I+1) begin
			assign uio_io[I] = (uio_oe[I]?uio_out[I]: 1'bz);
		end
	endgenerate

endmodule
