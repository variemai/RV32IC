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
 *  Description:  Data memory for a 32-bit RISC-V                    *  
 *                                                                   *
 *********************************************************************/


`include "PipelineRegs.sv"

module dmem
#(
//------------------------------------------------
parameter ADDR_WIDTH = 9,
parameter DATA_WIDTH = 32,
parameter RAM_SIZE = 512
//------------------------------------------------
)   (
	input i_clk,
	input i_we,
	input [ADDR_WIDTH-1:0] i_addr,
	input [DATA_WIDTH-1:0] i_wdata,
	output logic [DATA_WIDTH-1:0] o_rdata,
	input PipelineReg::MEM_STATE i_mem_state,
	output PipelineReg::WBACK_STATE o_wback_state
	);


	logic [DATA_WIDTH-1:0] RAM [RAM_SIZE-1:0];
	initial begin
		$readmemh("data.data", RAM, 0, 100);
	end

	always @(posedge i_clk) begin
		if(i_we) begin
			RAM[i_addr] <= i_wdata;
			o_rdata <= RAM[i_addr];
		end
		else
			o_rdata <= RAM[i_addr];
	end

	always @(posedge i_clk) begin
	        o_wback_state.RegWrite = i_mem_state.RegWrite;
        	o_wback_state.MemToReg = i_mem_state.MemToReg;
		o_wback_state.rdata = o_rdata;
		o_wback_state.ALUOutput = i_mem_state.ALUOutput;
        	o_wback_state.write_reg = i_mem_state.write_reg;
		o_wback_state.rd = i_mem_state.rd;
	end

	
endmodule
