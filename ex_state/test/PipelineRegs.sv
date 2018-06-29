/*****************************************************************************
 * Pipeline Registers used by the modules                                    *
 * Authors: Vardas Ioannis                                                   *
 *          Antonios Psistakis (psistakis@csd.uoc.gr)                        *
 *	    (updated on May 24th, 2018)					     *
 * created for the purposes of CS-523 RISC-V 32 bit implementation project   *
 * Computer Science Department University of Crete 14/05/2018                *
 *****************************************************************************/
 
`ifndef _pipelineregs
 `define _pipelineregs
package PipelineReg;

    typedef struct packed {
        logic [31:0] pc;
    }IF_STATE;

    typedef struct packed {
        logic [31:0] pc;
        logic [31:0] instruction;
    }ID_STATE;

    typedef struct packed {
        logic [31:0] pc;
        logic [2:0] func3; 
		logic func7;
		logic [2:0] ALUOp;
        logic [31:0] immediate; 
		logic [4:0] rd;
		logic MemToReg; //Load instructions write back to reg file
		logic RegWrite; //Instructions that need to write to reg file
        /*More signals for forwarding and hazard detection*/
		logic [4:0] rs1;
        logic [4:0] rs2;
		logic jmp;
		logic MemRead;
		logic MemWrite;
    }EX_STATE;

    typedef struct packed {
        logic [31:0] pc;

	// Memory Stage
	// control signals
	logic BranchSrc0;
    logic MemRead;
    logic MemWrite;
	logic [3:0] mem_type;
	// output signals
	logic [31:0] ALUOutput;
	logic [31:0] rd2;
	logic [31:0] write_reg;
	
	// Write back stage
        logic MemToReg;
	logic RegWrite;
	logic [4:0] rd;

    }MEM_STATE;

   
    typedef struct packed {
		logic [31:0] pc; //for debug purposes only
        //logic [31:0] ALUOutput;
        //logic [31:0] rdata;
        //logic [31:0] write_reg;
        //logic MemToReg;
        logic RegWrite;
		logic [4:0] rd;
		logic [31:0] final_out;
    }WBACK_STATE;


endpackage
`endif
