/*****************************************************************************
 * The Instruction Memory module, reads the instruction from the IMemory     *
 * and increases the PC writes the instruction to the PC pipeline register   *
 * Authors: Vardas Ioannis                                                   *
 * created for the purposes of CS-523 RISC-V 32 bit implementation project   *
 * Computer Science Department University of Crete 27/03/2018                *
 *****************************************************************************/

 module Imem (
     input [9:0] address,
     input we,
     inout [31:0] data
     );

     logic[31:0] memory[9:0];

     assign data = we==0 ? memory[address] : 8'hzzzzzzzz;
     always @ ( we ) begin
         memory[address] = data;
	 end
endmodule
