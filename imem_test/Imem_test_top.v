interface mem_interface (input clk);


endinterface


module Imem_test_top;
    parameter clock_cycle = 200;
    bit clk;

    /* Top and test bench files
     */

    initial begin
        clk = 1'b0;
        forever begin
            #(clock_cycle/2)
            clk = ~clk;
        end
    end
endmodule
