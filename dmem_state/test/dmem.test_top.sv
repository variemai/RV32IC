/*********************************************************************
 *                                                                   *
 *  University of Crete                                              *
 *  Department of Computer Science                                   *
 *  CS-523: Digital Circuits Design Lab Using EDA Tools              *
 *  Spring 2018                                                      *
 *                                                                   *
 *                                                                   *
 *  Author:       Antonios Psistakis (psistakis@csd.uoc.gr)          *
 *  Date:         June 29th, 2018                                    *
 *  Description:  Top module for data mem. test for a 32-bit RISC-V  *  
 *                                                                   *
 *********************************************************************/
`include "PipelineRegs.sv"

module dmem_test_top
#(
//------------------------------------------------
  parameter ADDR_WIDTH  = 32,
  parameter DATA_WIDTH  = 32,
  parameter DATA_BYTES  = DATA_WIDTH/8
//-----------------------------------------------
);

	PipelineReg::MEM_STATE mem_state;
        PipelineReg::WBACK_STATE wback_state;

	parameter 		clock_cycle = 100;

	bit 			clk;
	logic [ADDR_WIDTH-1:0] 	addr;
	logic [DATA_WIDTH-1:0] 	data_from_mem;
	logic 			we;
	logic [DATA_WIDTH-1:0] 	data_to_mem;
	logic [DATA_BYTES-1:0] 	mem_type;

	dmem dut(
                .i_clk(clk),
		.i_reset(reset),
                .i_addr(addr),
                .i_wdata(data_to_mem),
		.i_we(we),
		.i_mem_type(mem_type),
                .o_rdata(data_from_mem),
		.i_mem_state(mem_state),
		.o_wback_state(wback_state)
        );

	dmem_test tb(
		.i_clk(clk),
		.i_rdata(data_from_mem),
		.o_addr(addr),
		.o_wdata(data_to_mem),
		.o_we(we),
		.o_mem_type(mem_type)
	);


	initial begin
    		clk = 1'b0;
    		forever begin
      			#(clock_cycle/2)
        		clk = ~clk;
    		end
  	end


endmodule
