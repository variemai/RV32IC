`ifndef _PIPELINEREGS_SV_
`define _PIPELINEREGS_SV_

package PipelineRegs;

	typedef struct packed{
		logic [31:0] pc;
		logic [15:0] compressedpc;
	}InstructionFetch;

	typedef struct packed{
		logic [15:0] pc;
		logic [15:0] compressedpc;
	}InstructionDecode;

endpackage
`endif	
