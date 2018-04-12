/*********************************************************************
 *                                                                   *
 *  University of Crete                                              *  
 *  Department of Computer Science                                   *
 *  CS-523: Digital Circuits Design Lab Using EDA Tools              *
 *  Spring 2018                                                      *
 *                                                                   *
 *                                                                   *
 *  Author:       Antonios Psistakis (psistakis@csd.uoc.gr)          *
 *  Date:         April 10th, 2018                                   *
 *  Description:  Arithmetic Logic Unit (ALU) for a 32-bit RISC-V    *
 *                                                                   *
 *********************************************************************/

//`define PC_bits 32

typedef enum bit [5:0] {

  // Data transfers
  LD,
  ST,

  // Arithmetical
  ADD,
  ADDI,
  SUB,
  SUBI,
  MULT,

  // Logical
  AND,
  ANDI,
  OR,
  ORI,
  XORI,
  SLL,
  SRL,

  SLT,
  SLTI,

  // Control
  BEQ,
  BNE,
  BLT,
  BGE,
  JAL

} ALUmode_t;


module alu (i_clk, i_reset, i_ALUmode, i_A, i_B, i_Imm_SignExt, i_NPC, o_ALUOutput, o_branch, o_retaddr);

  
  input  [31:0]           i_A;
  input  [31:0]           i_B;
  input  [5:0] i_ALUmode;
  input  [31:0]           i_Imm_SignExt;
  input  [31:0]  i_NPC;
  output reg [31:0]           o_ALUOutput;
  output reg                 o_branch;
  output reg [31:0]           o_retaddr;
  input                   i_reset;
  input                   i_clk;



  
always @(posedge i_clk) 
begin
    
    o_ALUOutput = 32'b0;

    if(i_ALUmode==LD || i_ALUmode==ST)
    begin
      o_ALUOutput = i_A + i_Imm_SignExt;
    end
    else if(i_ALUmode==ADD)
    begin
      o_ALUOutput = i_A + i_B;
    end
    else if(i_ALUmode==SUB)
    begin
      o_ALUOutput = i_A - i_B;
    end
    else if(i_ALUmode==ADDI) // same with LD and ST
    begin
      o_ALUOutput = i_A + i_Imm_SignExt;
    end
    else if(i_ALUmode==SUBI)
    begin
      o_ALUOutput = i_A - i_Imm_SignExt;
    end
    else if(i_ALUmode==MULT)
    begin
      o_ALUOutput = i_A * i_B;
    end
    else if(i_ALUmode==AND)
    begin
      o_ALUOutput = i_A & i_B;
    end
    else if(i_ALUmode==ANDI)
    begin
      o_ALUOutput = i_A & i_Imm_SignExt;
    end
    else if(i_ALUmode==OR)
    begin
      o_ALUOutput = i_A | i_B;
    end
    else if(i_ALUmode==ORI)
    begin
      o_ALUOutput = i_A | i_Imm_SignExt;
    end
    else if(i_ALUmode==XORI)
    begin
      o_ALUOutput = ~i_A;
    end
    else if(i_ALUmode==SLL)
    begin
      o_ALUOutput = (i_A>>i_B);
    end
    else if(i_ALUmode==SRL)
    begin
      o_ALUOutput = (i_A<<i_B);
    end
    else if(i_ALUmode==SLT)
    begin
      if(i_A < i_B)
      begin
        o_ALUOutput = 32'b1;
      end
      else
      begin
        o_ALUOutput = 32'b0;
      end
    end
    else if(i_ALUmode==SLTI)
    begin
      if(i_A < i_Imm_SignExt)
      begin
        o_ALUOutput = 32'b1;
      end
      else
      begin
        o_ALUOutput = 32'b0;
      end
    end
    else if(i_ALUmode==BEQ)
    begin
      if(i_A == i_B)
      begin
        o_branch = 1'b1;
      end
      else
      begin
        o_branch = 1'b0;
      end
      o_ALUOutput = i_NPC + (2<<i_Imm_SignExt);
    end
    else if(i_ALUmode==BNE)
    begin
      if(i_A != i_B)
      begin
        o_branch = 1'b1;
      end
      else
      begin
        o_branch = 1'b0;
      end
      o_ALUOutput = i_NPC + (2<<i_Imm_SignExt);
    end
    else if(i_ALUmode==BLT)
    begin
      if(i_A < i_B)
      begin
        o_branch = 1'b1;
      end
      else
      begin
        o_branch = 1'b0;
      end
      o_ALUOutput = i_NPC + (2<<i_Imm_SignExt);
    end
    else if(i_ALUmode==BGE)
    begin
      if(i_A >= i_B)
      begin
        o_branch = 1'b1;
      end
      else
      begin
        o_branch = 1'b0;
      end
      o_ALUOutput = i_NPC + (2<<i_Imm_SignExt);
    end
    else if(i_ALUmode==JAL)
    begin
      o_retaddr	  = i_NPC + 4;
      o_ALUOutput = i_NPC + (2<<i_Imm_SignExt);
    end
end

endmodule
