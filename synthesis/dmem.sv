/*********************************************************************
 *                                                                   *
 *  University of Crete                                              *
 *  Department of Computer Science                                   *
 *  CS-523: Digital Circuits Design Lab Using EDA Tools              *
 *  Spring 2018                                                      *
 *                                                                   *
 *                                                                   *
 *  Author:       Antonios Psistakis (psistakis@csd.uoc.gr)          *
 *  Date:         June 21th, 2018                                    *
 *  Description:  Data memory for a 32-bit RISC-V                    *  
 *                                                                   *
 *********************************************************************/


`include "PipelineRegs.sv"


module dmem
#(
//------------------------------------------------
  parameter DEPTH       = 2048,
  parameter ADDR_WIDTH  = $clog2(DEPTH),
  parameter DATA_WIDTH  = 32,
  parameter DATA_BYTES  = DATA_WIDTH/8,
  parameter INIT_ZERO   = 0,
  parameter INIT_FILE   = "fibonacci_data.hex",
  parameter INIT_START  = 0,
  parameter INIT_END    = DEPTH-1
//------------------------------------------------
) (
  input                        		i_clk,
  input					i_reset,
  input      [ADDR_WIDTH-1:0]   	i_addr,
  input      [DATA_WIDTH-1:0]   	i_wdata,
  input        				i_we,
  input	     [DATA_BYTES-1:0]   	i_mem_type,	
  output bit [DATA_WIDTH-1:0]   	o_rdata,
  input PipelineReg::MEM_STATE 		i_mem_state,
  output PipelineReg::WBACK_STATE 	o_wback_state

);

bit [DATA_WIDTH-1:0] mem [0 : DEPTH-1];
bit [DATA_WIDTH-1:0] tmp_rdata;


// WRITE_FIRST MODE
always @(posedge i_clk) begin
  if ( i_we ) begin
  	for (int i=0 ; i<DATA_BYTES; i++) begin
    		if ( i_mem_type[i] ) begin
      			mem[i_addr][8*i +: 8] = i_wdata[8*i +: 8];
    		end
  	end
  end

  for (int i=0 ; i<DATA_BYTES; i++) begin
        if ( i_mem_type[i] ) begin
        	tmp_rdata[8*i +: 8] = mem[i_addr][8*i +: 8];
        end
	else begin
		tmp_rdata[8*i +: 8] = 8'b0;
	end
  end  

  o_rdata = tmp_rdata;
end

// initialize memory from file
initial begin
  if ( !INIT_ZERO ) begin
    $readmemh(INIT_FILE, mem, INIT_START, INIT_END);
  end
end


always @(posedge i_clk) begin

	if(i_reset)
	begin
		o_wback_state <= 0;
	end
	else
	begin

		o_wback_state.pc <= i_mem_state.pc;
		o_wback_state.RegWrite <= i_mem_state.RegWrite;
		o_wback_state.rd <= i_mem_state.rd;
		if(i_mem_state.MemToReg) o_wback_state.final_out <= o_rdata;
		else o_wback_state.final_out <= i_mem_state.ALUOutput;
	end
end


endmodule
