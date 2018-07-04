/*********************************************************************
 *                                                                   *
 *  University of Crete                                              *
 *  Department of Computer Science                                   *
 *  CS-523: Digital Circuits Design Lab Using EDA Tools              *
 *  Spring 2018                                                      *
 *                                                                   *
 *                                                                   *
 *  Author:       Antonios Psistakis (psistakis@csd.uoc.gr)          *
 *  Date:         July 2nd, 2018                                     *
 *  Description:  Data memory for a 32-bit RISC-V                    *  
 *                                                                   *
 *********************************************************************/


`include "PipelineRegs.sv"


/* mem-type (4 bits) definitions */
`define MTYPE_BYTE      1   // 4'b0001 , byte
`define MTYPE_HALFWORD  3   // 4'b0011 , half word
`define MTYPE_FULLWORD  15  // 4'b1111 , full word
`define MTYPE_UBYTE     8   // 4'b1000 , upper byte
`define MTYPE_UHALFWORD 12  // 4'b1100 , upper half word
`define MTYPE_INVALID   0   // invalid case, should never go there

/* byte-num (2 bits) definitions */
`define BYTE0      		0   // 2'b00
`define BYTE1 	 		1   // 2'b01 
`define BYTE2  			2  	// 2'b10 
`define BYTE3     		3   // 2'b11

/* word-num (1 bit) definitions */
`define WORD0      		0   // 1'b0
`define WORD1 	 		1   // 1'b1


module dmem_state
#(
//------------------------------------------------
  parameter DEPTH       = 2048,
  parameter ADDR_WIDTH  = $clog2(DEPTH),
  parameter DATA_WIDTH  = 32,
  parameter DATA_BYTES  = DATA_WIDTH/8
//------------------------------------------------
) (
  input                        		i_clk,
  input								i_reset,
  input      [ADDR_WIDTH-1:0]   	i_addr,
  input      [DATA_WIDTH-1:0]   	i_wdata,
  input        						i_we,
  input	     [DATA_BYTES-1:0]   	i_mem_type,	
  output bit [DATA_WIDTH-1:0]   	o_rdata,
  input PipelineReg::MEM_STATE 		i_mem_state,
  output PipelineReg::WBACK_STATE 	o_wback_state

);

bit [DATA_WIDTH-1:0] 	tmp_rdata;			// 32 bits
bit [DATA_WIDTH/4-1:0] 	byte_rdata; 		// 8 bits
bit [DATA_WIDTH-1:0] 	halfword_rdata; 	// 16 bits
bit [DATA_WIDTH-1:0] 	word_rdata; 		// 32 bits

bit [DATA_BYTES-1:0]	write_type;			// 4 bits, for byte, halfword, word, upper half byte and upper half word

assign write_type = (i_we == 1'b1) ? i_mem_type : 4'b0000;

/* Byte mux */
always_comb begin
	case(i_addr[1:0])
	`BYTE0: begin
		byte_rdata = tmp_rdata[DATA_WIDTH/4-1:0]; 				// [7:0]
	end
	`BYTE1: begin
		byte_rdata = tmp_rdata[DATA_WIDTH/2-1:DATA_WIDTH/4]; 	// [15:8]
	end
	`BYTE2: begin
		byte_rdata = tmp_rdata[DATA_WIDTH/2+8-1:DATA_WIDTH/2]; 	// [23:16]
	end
	`BYTE3: begin
		byte_rdata = tmp_rdata[DATA_WIDTH-1:DATA_WIDTH/2+8]; 	// [31:24]
	end
	default: begin // should not go here
		byte_rdata = 8'bx;
	end
	endcase
end

/* Halfword mux */
always_comb begin
	case(i_addr[1])
	`WORD0: begin
		halfword_rdata = tmp_rdata[DATA_WIDTH/2-1:0]; // [15:0]
	end
	`WORD1: begin
		halfword_rdata = tmp_rdata[DATA_WIDTH-1:DATA_WIDTH/2]; // [31:16]
	end
	default: begin // should not go here
		halfword_rdata = 16'bx;
	end
	endcase
end

/* Word */
assign word_rdata = tmp_rdata;


always_comb begin
	if(i_mem_type != `MTYPE_INVALID) begin
		case(i_mem_type)
        		`MTYPE_BYTE: begin
				o_rdata = { {28{byte_rdata[DATA_WIDTH/4-1]}}, byte_rdata };
				//$displa is: %d\n", i_ALUop);
			end
        		`MTYPE_HALFWORD: begin
				o_rdata = { {24{halfword_rdata[DATA_WIDTH/2-1]}}, halfword_rdata };
			end
        		`MTYPE_FULLWORD: begin
				o_rdata = word_rdata;      	
			end
        		`MTYPE_UBYTE: begin
				o_rdata = { byte_rdata, {28'b0} };
			end
			`MTYPE_UHALFWORD: begin
				o_rdata = { halfword_rdata, {24'b0} };
			end
			default: begin
				o_rdata = 32'bx; // should never go here
			end
        	endcase
	end
	else begin
		o_rdata = 32'bx;
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



mem_sync_sp dmem(
		.clk			( i_clk ),
		.i_addr			( i_addr ),
		.i_wdata		( i_wdata ),
		.i_wen			( write_type ),
		.o_rdata		( tmp_rdata )
);




endmodule
