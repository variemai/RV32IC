/*****************************************************************************
 * The Instruction Memory module, reads the instruction from the IMemory     *
 * and increases the PC writes the instruction to the PC pipeline register   *
 * Authors: Vardas Ioannis                                                   *
 * created for the purposes of CS-523 RISC-V 32 bit implementation project   *
 * Computer Science Department University of Crete 27/03/2018                *
 *****************************************************************************/

 module Imem (
	 input clk,
	 input reset,
	 input [7:0] address,
     input we,
	 input oe,
     input [7:0] data_in,
     output logic [7:0] data_out
     );
	 integer out,i;
     logic [7:0] memory [7:0];
	 logic [7:0] memory_q [7:0];
     
	always @(posedge clk or negedge reset)
	begin
    	if (!reset)
    	begin
        	for (i=0;i<8; i=i+1)
            memory_q[i] <= 0;
   		end
		else
		begin
			for(i=0; i<8; i=i+1)
				memory_q[i]<=memory[i];
		end
	end
	
	always @(*)
	begin
		for(i=0; i<8; i=i+1)
			memory[i]=memory_q[i];
		if( we && !oe)
			memory[i] = data_in;
		if(!we && oe)
			data_out = memory[address];
	end
	 /*assign data_out = (oe && !we) ? memory[address] : 8'bzzzzzzzz;
	 always @( we or oe)
	 begin
		 if(we && oe) $display("ERROR BOTH OE and WE ENABLED");
		 if(we) begin
		 	memory[address] = data_in;
		 	$display("ADDR: %b, DATA: %b",address,data_in);
	 	end
	 end*/
endmodule
