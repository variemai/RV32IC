
module Imem_test_top;
    parameter clock_cycle = 200;
    bit clk;
    logic [7:0] addr;
    logic [7:0] din;
	logic [7:0] dout;
    logic we;
	logic oe;
	logic rst;

    Imem dut(
		.clk(clk),
		.reset(rst),
        .address(addr),
        .data_in(din),
        .data_out(dout),
        .we(we),
		.oe(oe)
    );

    Imem_test testbench(
        .clk(clk),
		.reset(rst),
        .address(addr),
        .data_in(dout),
        .data_out(din),
        .we(we),
		.oe(oe)
    );


    initial begin
        clk = 1'b0;
        forever begin
            #(clock_cycle/2)
            clk = ~clk;
        end
    end
endmodule
