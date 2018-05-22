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
 *  Description:  Data fetch for a 32-bit RISC-V    		     *
 *                                                                   *
 *********************************************************************/

module DFetch(
	input 			i_clk,
	input logic [31:0] 	i_addr,
	input logic [31:0] 	i_data_to_mem,
	input logic		i_we,
	output logic [31:0] 	o_data_from_mem
	);
	
	 dmem DataMem(
                .i_clk(i_clk),
                .i_we(i_we),
                .i_addr(i_addr),
                .i_wdata(i_data_to_mem),
                .o_rdata(o_data_from_mem)
        );

endmodule
