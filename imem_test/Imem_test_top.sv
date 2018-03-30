
module Imem_test_top;
    parameter clock_cycle = 200;
    bit clk;
    wire [9:0] addr;
    wire [31:0] din;
    wire [31:0] dout
    wire we;

    Imem dut(
        .address(addr),
        .data_in(din),
        .data_out(dout),
        .we(we)
    );

    Imem_test testbench(
        .clk(clk),
        .address(addr),
        .data_in(dout),
        .data_out(din),
        .we(we)
    );


    initial begin
        clk = 1'b0;
        forever begin
            #(clock_cycle/2)
            clk = ~clk;
        end
    end
endmodule
