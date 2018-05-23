/*********************************************************************
 *                                                                   *
 *  University of Crete                                              *
 *  Department of Computer Science                                   *
 *  CS-523: Digital Circuits Design Lab Using EDA Tools              *
 *  Spring 2018                                                      *
 *                                                                   *
 *                                                                   *
 *  Author:       Antonios Psistakis (psistakis@csd.uoc.gr)          *
 *  Date:         May 23th, 2018                                     *
 *  Description:  Top module for data mem. test for a 32-bit RISC-V  *  
 *                                                                   *
 *********************************************************************/

module dmem_test_top;

	parameter clock_cycle = 100;

	bit 		clk;
	logic [31:0] 	addr;
	logic [31:0] 	data_from_mem;
	logic 		we;
	logic [31:0] 	data_to_mem;

	dmem dut(
                .i_clk(clk),
                .i_we(we),
                .i_addr(addr),
                .i_wdata(data_to_mem),
                .o_rdata(data_from_mem)
        );

	dmem_test tb(
		.i_clk(clk),
		.i_rdata(data_from_mem),
		.o_addr(addr),
		.o_wdata(data_to_mem),
		.o_we(we)
	);


	initial begin
    		clk = 1'b0;
    		forever begin
      			#(clock_cycle/2)
        		clk = ~clk;
    		end
  	end


endmodule
