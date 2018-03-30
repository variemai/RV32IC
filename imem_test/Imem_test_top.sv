
module Imem_test_top;
    parameter clock_cycle = 200;
    bit clk;
    wire [9:0] addr;
    wire [31:0] data;
    wire we;

    Imem dut(
        .clk(clk),
        .address(addr),
        .data(data),
        .we(we)
    );

    Imem_test testbench(
        .clk(clk)
        .address(addr),
        .data(data),
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
