/*****************************************************************************
 * Pipeline Registers used by the modules                                    *
 * Authors: Vardas Ioannis                                                   *
 * created for the purposes of CS-523 RISC-V 32 bit implementation project   *
 * Computer Science Department University of Crete 27/03/2018                *
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
		logic [6:0] func7;
		logic [2:0] ALUOp;
        //logic [31:0] rs1_data; we will not need these sync reg file
        //logic [31:0] rs2_data;
        logic [31:0] immediate; 
		logic [4:0] rd;
		logic [1:0] ALUsrc ; //sources are regfile, immediate or pc
		logic Mem2Reg; //Load instructions write back to reg file
		logic RegWrite; //Instructions that need to write to reg file
        /*More signals for forwarding and hazard detection*/
		logic branch; //is one bit enough?
        logic [4:0] rs1;
        logic [4:0] rs2;
		logic MemRead;
		logic MemWrite;
    }EX_STATE;


endpackage
`endif
