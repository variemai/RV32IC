/*********************************************************************
 *                                                                   *
 *  University of Crete                                              *  
 *  Department of Computer Science                                   *
 *  CS-523: Digital Circuits Design Lab Using EDA Tools              *
 *  Spring 2018                                                      *
 *                                                                   *
 *                                                                   *
 *  Author:       Antonios Psistakis (psistakis@csd.uoc.gr)          *
 *  Date:         April 20th, 2018                                   *
 *  Description:  Top test for the Arithmetic Logic Unit (ALU)       *
 *                for a 32-bit RISC-V                                *
 *                                                                   *
 *********************************************************************/


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
  wire      [31:0]            i_A;
  wire      [31:0]            i_B;
  wire      [5:0]             i_ALUmode;
  

  wire      [31:0]            i_Imm_SignExt;
  wire      [31:0]            i_NPC;

  wire	    [2:0]   	      i_ALUop;
  wire      [2:0]   	      i_func3;
  wire          	      i_func7; // 1 bit

  wire      [31:0]            o_ALUOutput;
  wire                        o_branch;
  wire      [31:0]            o_retaddr;


  alu dut(
    .i_clk          ( i_clk ),
    .i_reset        ( i_reset ),
    .i_A            ( i_A ),
    .i_B            ( i_B ),
    .i_ALUmode      ( i_ALUmode ),
    .i_Imm_SignExt  ( i_Imm_SignExt ),
    .i_NPC          ( i_NPC ),
    .i_ALUop        ( i_ALUop ),
    .i_func3        ( i_func3 ),
    .i_func7        ( i_func7 ), // 1 bit
    .o_ALUOutput    ( o_ALUOutput ),
    .o_branch       ( o_branch ),
    .o_retaddr	    ( o_retaddr )
  );

  alu_test testbench( 
    .clk            ( i_clk ),
    .reset_p        ( i_reset ),
    .A_p            ( i_A ),
    .B_p            ( i_B ),
    .ALUmode_p      ( i_ALUmode ),
    .Imm_SignExt_p  ( i_Imm_SignExt ),
    .NPC_p          ( i_NPC ),
    .ALUop_p        ( i_ALUop ),
    .func3_p        ( i_func3 ),
    .func7_p        ( i_func7 ), // 1 bit
    .ALUOutput_p    ( o_ALUOutput ),
    .branch_p       ( o_branch ),
    .retaddr_p 	    ( o_retaddr )
  );

  initial begin
    i_clk = 1'b0;
    forever begin
      #(clock_cycle/2)
        i_clk = ~i_clk ;
    end
  end
endmodule

