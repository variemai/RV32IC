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
 *  Description:  Arithmetic Logic Unit (ALU) for a 32-bit RISC-V    *
 *                                                                   *
 *********************************************************************/


`include "PipelineRegs.sv"


/* ALUop (3 bits) definitions */
`define ALUOP_LDST      0 // LB, LH, LW, LBU, LHU, SB, SH, SW
`define ALUOP_BRANCH    1 // BEQ, BNE, BLT, BGE, BLTU, BGEU
`define ALUOP_RTYPE     2 // ADD, SUB, SLL, SLT, SLTU, XOR, SRL, SRA, OR, AND
`define ALUOP_ITYPE     3 // ADDI, SLTI, SLTIU, XORI, ORI, ANDI, SLLI, SRLI, SRAI
`define ALUOP_LUI       4
`define ALUOP_AUIPC     5
`define ALUOP_JAL       6
`define ALUOP_JALR      7

/* mem-type (4 bits) definitions */
`define MTYPE_BYTE      1   // 4'b0001 , byte
`define MTYPE_HALFWORD  3   // 4'b0011 , half word
`define MTYPE_FULLWORD  15  // 4'b1111 , full word
`define MTYPE_UBYTE     8   // 4'b1000 , upper byte
`define MTYPE_UHALFWORD 12  // 4'b1100 , upper half word
`define MTYPE_INVALID   0   // invalid case, should never go there


module alu (i_clk, i_reset, i_A, i_B, i_Imm_SignExt, i_NPC, i_ALUop, i_func3, i_func7, o_ALUOutput, i_ex_state, o_mem_state, o_jmp_pc, o_jmp);// o_retaddr);

  
input  [31:0]                 i_A;
input  [31:0]                 i_B;
input  [31:0]                 i_Imm_SignExt;
input  [31:0]                 i_NPC;
input  [2:0]                  i_ALUop;
input  [2:0]                  i_func3;
input                         i_func7; // 1 bit
input                         i_reset;
input                         i_clk;
input  PipelineReg::EX_STATE  i_ex_state;

output reg [31:0]             o_ALUOutput;
output PipelineReg::MEM_STATE o_mem_state;
output logic [31:0]           o_jmp_pc;
output logic                  o_jmp;


reg [31:0]                    tmp_PC;


always_ff @(posedge i_clk)
begin
  tmp_PC <= i_NPC + (i_Imm_SignExt<<1);
end

always @(posedge i_clk)
begin
	if(i_reset)
	begin
		o_mem_state.pc          <= 0;
    		o_mem_state.write_reg   <= 0;
    		o_mem_state.write_reg   <= 0;
    		o_mem_state.MemToReg    <= 0;
    		o_mem_state.RegWrite    <= 0;
    		o_mem_state.rd          <= 0;

    		o_mem_state.MemRead     <= 0;
    		o_mem_state.MemWrite    <= 0;
				
		o_mem_state.mem_type    <= 0;
	end
	else
	begin
		o_mem_state.pc          <= i_ex_state.pc;
		o_mem_state.write_reg   <= i_B;
		o_mem_state.MemToReg    <= i_ex_state.MemToReg;
		o_mem_state.RegWrite    <= i_ex_state.RegWrite;
		o_mem_state.rd          <= i_ex_state.rd;

		o_mem_state.MemRead     <= i_ex_state.MemRead;
		o_mem_state.MemWrite    <= i_ex_state.MemWrite;
	end
end


/*  Combinational logic that independently calculates the jump_pc (next pc) 
    in the cases of the following instructions:
    a. JAL
    b. JALR &
    c. BRANCH (BEQ, BNE, BLT, BGE, BLTU, BGEU)
 */
always_comb 
begin
	if(i_reset) o_jmp = 0;
	if(~i_reset) o_mem_state.ALUOutput <= o_ALUOutput;
	if(i_ALUop == `ALUOP_JALR) begin // JALR
		o_jmp_pc = i_A + i_Imm_SignExt;
		o_jmp = 1;	
	end 
	else if(i_ALUop == `ALUOP_BRANCH) begin
	o_jmp = 1'b0;
      case(i_func3)
        0: begin // beq
          if(i_A == i_B)
          begin
             o_jmp = 1'b1;
          end
        end
        1: begin // bne
          if(i_A != i_B)
          begin
             o_jmp = 1'b1;
          end
        end
        4: begin // blt
          if($signed(i_A) < $signed(i_B))
          begin
             o_jmp = 1'b1;
          end
        end
        5: begin // bge
          if($signed(i_A) >= $signed(i_B))
          begin
             o_jmp = 1'b1;
          end
        end
        6: begin // bltu
          if(i_A < i_B)
          begin
             o_jmp = 1'b1;
          end 
        end
        7: begin // bgeu
          if(i_A >= i_B)
          begin
             o_jmp = 1'b1;
          end
        end
        default: begin
            o_jmp = 1'b0; // should never go here
        end
      endcase
		o_jmp_pc = i_NPC  + i_Imm_SignExt;
	end	
	else if(i_ALUop == `ALUOP_JAL) begin // jal
		o_jmp = 1;
		o_jmp_pc = i_NPC + i_Imm_SignExt;
	end
	else begin 
		o_jmp = 0;
	end
end

always @(posedge i_clk)
begin
    o_ALUOutput               = 32'b0;
    //	$display ("\ti_ALUop is: %d\n", i_ALUop);
    if(i_ALUop == `ALUOP_LDST) // LD-type, ST-type
    begin
    	case(i_func3)
        0: begin // byte
    		  o_mem_state.mem_type <= `MTYPE_BYTE;      // 4'b0001 
    	   end
      	1: begin // half word
      		o_mem_state.mem_type <= `MTYPE_HALFWORD;  // 4'b0011
      	end
      	2: begin // word
      		o_mem_state.mem_type <= `MTYPE_FULLWORD;  // 4'b1111
      	end
      	4: begin // byte upper
      		o_mem_state.mem_type <= `MTYPE_UBYTE;     // 4'b1000
      	end
      	5: begin // half word upper
      		o_mem_state.mem_type <= `MTYPE_UHALFWORD; // 4'b1100
      	end
      	default: begin
          o_mem_state.mem_type <= `MTYPE_INVALID;   // 4'b0000, should never go here
        end
      endcase
      o_ALUOutput             = i_A + i_Imm_SignExt;
    end
    else if(i_ALUop == `ALUOP_RTYPE) // R-type..
    begin
      case(i_func3)
        0: begin // ADD/SUB
          //$display ("\t~~~~~ALUout (res. was: %d)\n", o_ALUOutput);
          if(i_func7 == 0)      // ADD
          begin
            o_ALUOutput       = i_A + i_B;
            // $display ("\tALUout (res. was: %d)\n", o_ALUOutput);
          end
          else if(i_func7 == 1) // SUB (func7==1'b1)
          begin
             o_ALUOutput      = i_A - i_B;
             //$display ("\tALUout (res. was: %d)\n", o_ALUOutput);
          end
          else // should never go here
          begin
             o_ALUOutput      = 32'bx;
          end
        end
        1: begin // SLL
          o_ALUOutput         = (i_A<<i_B); // shifted left by i_B
        end
        2: begin // SLT
          if($signed(i_A) < $signed(i_B))
            begin
              o_ALUOutput     = 32'b1;
            end
            else
            begin
              o_ALUOutput     = 32'b0;
            end
          end
        3: begin // SLTU
            if(i_A < i_B)
            begin
              o_ALUOutput     = 32'b1;
            end
            else
            begin
              o_ALUOutput     = 32'b0;
            end
          end
        4: begin // XOR
          begin
            o_ALUOutput       = i_A ^ i_B;
          end
        end
        5: begin // SRL/SRA
          if(i_func7 == 1'b0) // SRL
          begin
             o_ALUOutput      = (i_A>>i_B); // shifted right by i_B
          end
          else if(i_func7 == 1'b1) // SRA (func7==1'b1)
          begin
             o_ALUOutput      = (i_A>>i_B);
             o_ALUOutput[31]  = i_A[31]; // keep sign-bit
          end
          else
          begin
            o_ALUOutput       = 32'bx; // should never go here
          end
        end
        6: begin // OR
        	o_ALUOutput         = i_A | i_B;
        end
        7: begin // AND
          o_ALUOutput         = i_A & i_B;
        end
        default: begin
            o_ALUOutput       = 32'bx; // should never go here
        end
      endcase
    end
    else if(i_ALUop == `ALUOP_ITYPE) // I-type..
    begin
      case(i_func3)
        0: begin // ADDI
          o_ALUOutput         = i_A + i_Imm_SignExt;
        end
        1: begin // SLLI
          o_ALUOutput         = i_A << i_Imm_SignExt;
        end
        2: begin // SLTI
          if($signed(i_A) < $signed(i_Imm_SignExt))
            begin
              o_ALUOutput     = 32'b1;
            end
            else
            begin
              o_ALUOutput     = 32'b0;
            end
          end
        3: begin // SLTIU
          if(i_A < i_Imm_SignExt)
            begin
              o_ALUOutput     = 32'b1;
            end
            else
            begin
              o_ALUOutput     = 32'b0;
            end
          end
        4: begin // XORI
          begin
            o_ALUOutput       = i_A ^ i_Imm_SignExt;
          end
        end
        5: begin // SRLI, SRAI
          if(i_func7 == 1'b0)             // SRLI
          begin
             o_ALUOutput      = (i_A>>i_Imm_SignExt);
          end
          else if(i_func7 == 1'b1)        // SRAI (func7==1'b1)
          begin
             o_ALUOutput      = (i_A>>i_Imm_SignExt);
             o_ALUOutput[31]  = i_A[31];  // keep sign-bit
          end
          else
          begin
            o_ALUOutput       = 32'bx; // should never go here
          end
        end
        6: begin // ORI
          o_ALUOutput         = i_A | i_Imm_SignExt;
        end
        7: begin // ANDI
          o_ALUOutput         = i_A & i_Imm_SignExt;
        end
        default: begin
            o_ALUOutput       = 32'bx; // should never go here
        end
      endcase
    end
    else if(i_ALUop == `ALUOP_LUI) // I-type.., LUI
    begin
      o_ALUOutput             = i_Imm_SignExt;
    end
    else if(i_ALUop == `ALUOP_AUIPC) // I-type.., AUIPC
    begin
		  o_ALUOutput             = i_NPC + i_Imm_SignExt;
    end
    else if(i_ALUop == `ALUOP_JAL || i_ALUop == `ALUOP_JALR ) // JALR - JAL
    begin
	   o_ALUOutput             = i_NPC + 4;
    end
  end
endmodule
