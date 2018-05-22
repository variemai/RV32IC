/*********************************************************************
 *                                                                   *
 *  University of Crete                                              *
 *  Department of Computer Science                                   *
 *  CS-523: Digital Circuits Design Lab Using EDA Tools              *
 *  Spring 2018                                                      *
 *                                                                   *
 *                                                                   *
 *  Author:       Antonios Psistakis (psistakis@csd.uoc.gr)          *
 *  Date:         May 22th, 2018                                     *
 *  Description:  Data memory test for a 32-bit RISC-V               *  
 *                                                                   *
 *********************************************************************/


program Dmem_test(
	input 			i_clk,
    	input logic [31:0] 	i_rdata,
    	output logic [31:0] 	o_addr,
    	output logic [31:0] 	o_wdata,
	output logic		o_we

    );
	
	task checkWrite(bit [31:0] data, bit [8:0] addr);
		o_wdata =	data;
		o_addr	=	addr;
		o_we    =       1'b1;
		@(posedge i_clk) $write("Writing DATA: %h, to ADDR: %d \n", o_wdata, o_addr);
	endtask

	task checkRead(bit [31:0] addr);
		@(posedge i_clk) $write("DATA: %h, ADDR: %d \n", i_rdata, addr);
	endtask

	initial begin

		$write("\nInitial Read...\n\n");
                for(int i=0; i<10; i++) begin
                        o_addr 	= i;
			o_we 	= 1'b0;
                        checkRead(o_addr);
                end

		$write("\nWriting...\n\n");
		for(int i=0; i<10; i++) begin
                        checkWrite(32'hDADADADA, i+10);
                end
        
		$write("\nFinal read...\n\n");
		for(int i=0; i<20; i++) begin
                        o_addr  = i;
                        o_we    = 1'b0;
                        checkRead(o_addr);
                end
	end

endprogram
