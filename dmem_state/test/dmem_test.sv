/********************************************************************
 *                                                                   *
 *  University of Crete                                              *
 *  Department of Computer Science                                   *
 *  CS-523: Digital Circuits Design Lab Using EDA Tools              *
 *  Spring 2018                                                      *
 *                                                                   *
 *                                                                   *
 *  Author:       Antonios Psistakis (psistakis@csd.uoc.gr)          *
 *  Date:         June 29th, 2018                                    *
 *  Description:  Data memory test for a 32-bit RISC-V               *  
 *                                                                   *
 *********************************************************************/


program dmem_test

#(
//------------------------------------------------
  parameter ADDR_WIDTH  = 32,
  parameter DATA_WIDTH  = 32,
  parameter DATA_BYTES  = DATA_WIDTH/8
//-----------------------------------------------
)(

	input 				i_clk,
    	input logic [DATA_WIDTH-1:0] 	i_rdata,
    	output logic [ADDR_WIDTH-1:0] 	o_addr,
    	output logic [DATA_WIDTH-1:0] 	o_wdata,
	output logic			o_we,
	output logic [DATA_BYTES-1:0] 	o_mem_type

);
	
	task checkWrite(bit [31:0] data, bit [8:0] addr, bit [3:0] m_type);
		o_wdata 	=	data;
		o_addr		=	addr;
		o_we    	=       1'b1;
		o_mem_type 	=	m_type;
		@(posedge i_clk) $write("Writing DATA: %h, to ADDR: %d \n", o_wdata, o_addr);
	endtask

	task checkRead(bit [31:0] addr);
		@(posedge i_clk) $write("DATA: %h, ADDR: %d \n", i_rdata, addr);
	endtask

	initial begin

		$write("\nInitial Read...\n\n");
                for(int i=0; i<10; i++) begin
                        o_addr 		= i;
			o_we 		= 1'b0;
			o_mem_type 	= 4'b1111;
                        checkRead(o_addr);
                end

		$write("\nWriting...\n\n");
		for(int i=0; i<2; i++) begin
                        checkWrite(32'hDADADADA, i+10, 4'b0001);
                end
		for(int i=0; i<2; i++) begin
                        checkWrite(32'hDADADADA, i+12, 4'b0011);
                end
		for(int i=0; i<2; i++) begin
                        checkWrite(32'hDADADADA, i+14, 4'b0111);
                end
		for(int i=0; i<4; i++) begin
                        checkWrite(32'hDADADADA, i+16, 4'b1111);
                end

        
		$write("\nFinal read...\n\n");
		for(int i=0; i<20; i++) begin
                        o_addr  	= i;
                        o_we    	= 1'b0;
			o_mem_type 	= 4'b1111;
                        checkRead(o_addr);
                end
	end

endprogram
