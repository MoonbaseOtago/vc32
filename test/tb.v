`default_nettype none
`timescale 1ns/1ps

/*
this testbench just instantiates the module and makes some convenient wires
that can be driven / tested by the cocotb test.py
*/

// testbench is controlled by test.py
module tb ();

    // this part dumps the trace to a vcd file that can be viewed with GTKWave
    initial begin
        $dumpfile ("tb.vcd");
        $dumpvars (0, tb);
        #1;
    end

    // wire up the inputs and outputs
    reg  clk;
    reg  rst_n;
    wire  ena=1;
    wire  [7:0] ui_in;
    wire  [7:0] uio_in;

    wire [7:0] uo_out;
    wire [7:0] uio_out;
    wire [7:0] uio_oe;

    wire [3:0]b;

    tt_um_vc32_cpu tt_um_vc32_cpu (
    // include power ports for the Gate Level test
    `ifdef GL_TEST
        .VPWR( 1'b1),
        .VGND( 1'b0),
    `endif
        .ui_in      (ui_in),    // Dedicated inputs
        .uo_out     (uo_out),   // Dedicated outputs
        .uio_in     ({4'b0, b}),   // IOs: Input path
        .uio_out    (uio_out),  // IOs: Output path
        .uio_oe     (uio_oe),   // IOs: Enable path (active high: 0=input, 1=output)
        .ena        (ena),      // enable - goes high when design is selected
        .clk        (clk),      // clock
        .rst_n      (rst_n)     // not reset
        );

	assign b[0] = uio_oe[0]?uio_out[0]:1'bz;
	assign b[1] = uio_oe[1]?uio_out[1]:1'bz;
	assign b[2] = uio_oe[2]?uio_out[2]:1'bz;
	assign b[3] = uio_oe[3]?uio_out[3]:1'bz;


	spiflash #(.FILENAME(""))ram(.csb(uo_out[1]),
			           .clk(uo_out[2]),
				   .io0(b[0]),
				   .io1(b[1]),
				   .io2(b[2]),
				   .io3(b[3]));

	spiflash #(.FILENAME("init.hex"))rom(.csb(uo_out[0]),
			           .clk(uo_out[2]),
				   .io0(b[0]),
				   .io1(b[1]),
				   .io2(b[2]),
				   .io3(b[3]));


`ifdef XTEST
	initial begin
		rst_n = 0;
		clk=0; #5 clk=1; #5;
		clk=0; #5 clk=1; #5;
		rst_n = 1;
		forever begin clk=0; #5 clk=1; #5; end
	end
	initial begin
		#10000;$finish;
	end
`endif

endmodule
