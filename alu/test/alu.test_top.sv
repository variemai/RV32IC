/*********************************************************************
 *                                                                   *
 *  University of Crete                                              *  
 *  Department of Computer Science                                   *
 *  CS-523: Digital Circuits Design Lab Using EDA Tools              *
 *  Spring 2018                                                      *
 *                                                                   *
 *                                                                   *
 *  Author:       Antonios Psistakis (psistakis@csd.uoc.gr)          *
 *  Date:         May 14th, 2018                                     *
 *  Description:  Top test for the Arithmetic Logic Unit (ALU)       *
 *                for a 32-bit RISC-V                                *
 *                                                                   *
 *********************************************************************/

`include "../../PipelineRegs.sv"

module alu_test_top;

typedef enum bit [6:0] {

  // I-type
  LUI,
  AUIPC,
  JAL,
  JALR,

  // Control - Branch
  BEQ,
  BNE,
  BLT,
  BGE,
  BLTU,
  BGEU,

  // Data transfers
  LB,
  LH,
  LW,
  LBU,
  LHU,
  SB,
  SH,
  SW,

  // I-type (more)
  ADDI,
  SLTI,
  SLTIU,
  XORI,
  ORI,
  ANDI,
  SLLI,
  SRLI,
  SRAI,

  // R-type
  ADD,
  SUB,
  SLL,
  SLT,
  SLTU,
  XOR,
  SRL,
  SRA,
  OR,
  AND

} ALUmode_t;


//`define PC_bits 32

//module alu_test_top;

 //`define PC_bits 32 

 //`include "../rtl/alu.v"

 parameter clock_cycle = 100 ;
  
  bit                         i_clk;
  wire                        i_reset;

  PipelineReg::EX_STATE ex_state;
  PipelineReg::MEM_STATE mem_state;

  wire      [31:0]            o_ALUOutput;
  wire                        o_branch;
  wire      [31:0]            o_retaddr;


  alu dut(
    .i_clk          ( i_clk ),
    .i_reset        ( i_reset ),
    .i_A            ( ex_state.rs1 ),
    .i_B            ( ex_state.rs2 ),

    .i_Imm_SignExt  ( ex_state.immediate ),
    .i_NPC          ( ex_state.pc ),
    .i_ALUop        ( ex_state.ALUOp ),
    .i_func3        ( ex_state.func3 ),
    .i_func7        ( ex_state.func7 ), // 1 bit

    .o_ALUOutput    ( mem_state.ALUOutput ),
    .o_branch       ( mem_state.branch )
    //.o_retaddr	    ( o_retaddr )
  );

  alu_test testbench( 
    .clk            ( i_clk ),
    .reset_p        ( i_reset ),

    .A_p            ( ex_state.rs1 ),
    .B_p            ( ex_state.rs2 ),
    .Imm_SignExt_p  ( ex_state.immediate ),
    .NPC_p          ( ex_state.pc ),
    .ALUop_p        ( ex_state.ALUOp ),
    .func3_p        ( ex_state.func3 ),
    .func7_p        ( ex_state.func7 ), // 1 bit

    .ALUOutput_p    ( mem_state.ALUOutput ),
    .branch_p       ( mem_state.branch )
    //.retaddr_p 	    ( o_retaddr )
  );

  initial begin
    i_clk = 1'b0;
    forever begin
      #(clock_cycle/2)
        i_clk = ~i_clk ;
    end
  end
endmodule

