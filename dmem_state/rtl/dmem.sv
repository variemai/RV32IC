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
	output logic [DATA_WIDTH-1:0] o_rdata
	);


	logic [DATA_WIDTH-1:0] RAM [RAM_SIZE-1:0];
	initial begin
		$readmemh("../test/data.data", RAM, 0, 100);
	end

	always @(posedge i_clk) begin
		if(i_we) begin
			RAM[i_addr] <= i_wdata;
			o_rdata <= RAM[i_addr];
		end
		else
			o_rdata <= RAM[i_addr];
	end

	PipelineReg::EX_STATE ex_state;
	PipelineReg::MEM_STATE mem_state;
	PipelineReg::WBACK_STATE wback_state;
	always @(posedge i_clk) begin
	        wback_state.RegWrite = mem_state.RegWrite;
        	wback_state.MemToReg = mem_state.MemToReg;
		wback_state.rdata = o_rdata;
		wback_state.ALUOutput = mem_state.ALUOutput;
        	wback_state.write_reg = mem_state.write_reg;
	end

	
endmodule
