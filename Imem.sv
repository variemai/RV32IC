/*****************************************************************************
 * The Instruction Memory module, reads the instruction from the IMemory     *
 * and increases the PC writes the instruction to the PC pipeline register   *
 * Authors: Vardas Ioannis                                                   *
 * created for the purposes of CS-523 RISC-V 32 bit implementation project   *
 * Computer Science Department University of Crete 27/03/2018                *
 *****************************************************************************/

 module Imem(
    clk,
    rst,
    read_rq,
    write_rq,
    rw_address,
    write_data,
    read_data
);
input           clk;
input           rst;
input           read_rq;
input           write_rq;
input[5:0]      rw_address;
input[7:0]      write_data;
output[7:0]     read_data;

reg[7:0]     read_data;

integer out, i;

// Declare memory 64x8 bits = 512 bits or 64 bytes
reg [7:0] memory_ram_d [63:0];
reg [7:0] memory_ram_q [63:0];

// Use positive edge of clock to read the memory
// Implement cyclic shift right
always @(posedge clk or
    negedge rst)
begin
    if (!rst)
    begin
        for (i=0;i<64; i=i+1)
            memory_ram_q[i] <= 0;
    end
    else
    begin
        for (i=0;i<64; i=i+1)
             memory_ram_q[i] <= memory_ram_d[i];
    end
end


always @(*)
begin
    for (i=0;i<64; i=i+1)
        memory_ram_d[i] = memory_ram_q[i];
    if (write_rq && !read_rq)
        memory_ram_d[rw_address] = write_data;
    if (!write_rq && read_rq)
        read_data = memory_ram_q[rw_address];
end

endmodule
