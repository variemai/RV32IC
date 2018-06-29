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
 *  Description:  Top test for the Arithmetic Logic Unit (ALU)       *
 *                for a 32-bit RISC-V                                *
 *                                                                   *
 *********************************************************************/

`include "PipelineRegs.sv"

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
  wire      [31:0]            o_retaddr;

  wire	    [31:0]	      A;
  wire       [31:0]            B;
  wire      [31:0]            Imm;
  wire      [31:0]            jmp_pc;
  wire                        jmp;

  alu dut(
    .i_clk          ( i_clk ),
    .i_reset        ( i_reset ),
    .i_A            ( A ),
    .i_B            ( B ),

    .i_Imm_SignExt  ( Imm ),
    .i_NPC          ( ex_state.pc ),
    .i_ALUop        ( ex_state.ALUOp ),
    .i_func3        ( ex_state.func3 ),
    .i_func7        ( ex_state.func7 ), // 1 bit

    .o_ALUOutput    ( o_ALUOutput ),

    .i_ex_state     ( ex_state ),
    .o_mem_state    ( mem_state ),

    .o_jmp_pc       ( jmp_pc ),
    .o_jmp          ( jmp )

  );

  alu_test testbench( 
    .clk            ( i_clk ),
    .reset_p        ( i_reset ),

    .A_p            ( A ),
    .B_p            ( B ),
    .Imm_SignExt_p  ( Imm ),
    .NPC_p          ( ex_state.pc ),
    .ALUop_p        ( ex_state.ALUOp ),
    .func3_p        ( ex_state.func3 ),
    .func7_p        ( ex_state.func7 ), // 1 bit

    .ALUOutput_p    ( o_ALUOutput ),
    .jmp_pc_p	    ( jmp_pc ),
    .jmp_p	    ( jmp )
);

  initial begin
    i_clk = 1'b0;
    forever begin
      #(clock_cycle/2)
        i_clk = ~i_clk ;
    end
  end
endmodule

