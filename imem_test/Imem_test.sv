program Imem_test(
    input clk,
    input logic [31:0] data_in,
    output logic [9:0] address,
    output logic we,
    output logic [31:0] data_out
    );
    wire [9:0] addr = 10'b0000011111;
    //wire [31:0] data_to_write = 32'h0000ffff;
    initial begin
        WriteOP(addr,32'h0000ffff);
        ReadOP(addr);
    end
task ReadOP(bit [9:0] addr);
    @(posedge clk)
    address <= addr;
    we = 0;
    @(posedge clk)
    $display("DATA: %h",data);
endtask


task WriteOP(bit [9:0] addr_write, bit [31:0] data_write);
    @(posedge clk)
    address <= addr_write;
    data <= data_write;
    we = 1;
    @(posedge clk)
    we = 0;
endtask

endprogram
