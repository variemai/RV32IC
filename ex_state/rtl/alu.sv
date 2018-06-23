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
 *  Description:  Arithmetic Logic Unit (ALU) for a 32-bit RISC-V    *
 *                                                                   *
 *********************************************************************/

//`define PC_bits 32

`include "PipelineRegs.sv"

typedef enum bit [6:0]{

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


module alu (i_clk, i_reset, i_A, i_B, i_Imm_SignExt, i_NPC, i_ALUop, i_func3, i_func7, o_ALUOutput, o_branch, i_ex_state, o_mem_state, o_jmp_pc, o_jmp);// o_retaddr);

  
  input  [31:0]           i_A;
  input  [31:0]           i_B;
  input  [31:0]           i_Imm_SignExt;
  input  [31:0]           i_NPC;
  input  [2:0]            i_ALUop;
  input  [2:0]            i_func3;
  input                   i_func7; // 1 bit
  output reg [31:0]       o_ALUOutput;
  output reg              o_branch;
  //output reg [31:0]       retaddr_p;
  input                   i_reset;
  input                   i_clk;
  input  PipelineReg::EX_STATE i_ex_state;
  output PipelineReg::MEM_STATE o_mem_state;
  output logic [31:0] o_jmp_pc;
  output logic o_jmp;
	
reg [31:0] tmp_PC;
reg [31:0] stalled_PC; // target PC after a branch = stalled_PC

reg [31:0] tmp_value;

logic [3:0] mem_type; // type of memory access (byte, half word, word..)

//always_comb
always_ff @(posedge i_clk)
begin
  tmp_PC <= i_NPC + (i_Imm_SignExt<<1);
  o_jmp_pc <= i_NPC - 4 + i_Imm_SignExt;
  o_jmp <= i_ex_state.jmp;
end

initial begin
  stalled_PC = 32'b0;
end


always @(posedge i_clk)
begin
  if(i_ALUop==1) // branch
  begin
    stalled_PC = tmp_PC;
  end
end

always @(posedge i_clk)
begin
	o_mem_state.pc <= i_ex_state.pc;

	o_mem_state.AddSum <= tmp_PC;
	o_mem_state.branch <= o_branch;

//	o_mem_state.ALUOutput <= o_ALUOutput;
	//o_mem_state.rd2 <= i_ex_state.rd2;
	o_mem_state.write_reg <= i_B;


	o_mem_state.MemToReg <= i_ex_state.MemToReg;

	o_mem_state.RegWrite <= i_ex_state.RegWrite;
	o_mem_state.rd <= i_ex_state.rd;

	o_mem_state.MemRead <= i_ex_state.MemRead;
	o_mem_state.MemWrite <= i_ex_state.MemWrite;
//	o_mem_state.mem_type <= mem_type;
end

always_comb
begin
	o_mem_state.ALUOutput <= o_ALUOutput;
end


always @(posedge i_clk) 
//always_comb
begin
  if(stalled_PC == 32'b0) // no stall; keep going
  begin
    o_ALUOutput = 32'b0;
    //	$display ("\ti_ALUop is: %d\n", i_ALUop);
    if(i_ALUop==0) // LD-type, ST-type
    begin
	case(i_func3)
        0: begin // byte
		o_mem_state.mem_type <= 4'b0001; 
	end
	1: begin // half word
		o_mem_state.mem_type <= 4'b0011;
	end
	2: begin // word
		o_mem_state.mem_type <= 4'b1111;
	end
	4: begin // byte upper
		o_mem_state.mem_type <= 4'b1000;
	end
	5: begin // half word upper
		o_mem_state.mem_type <= 4'b1100;
	end
	default: begin
            	o_mem_state.mem_type <= 4'bx; // should never go here
        end
      endcase

      o_ALUOutput = i_A + i_Imm_SignExt;
    end
    else if(i_ALUop==1) // Branch..
    begin
      o_branch = 1'b0;
      case(i_func3)
        0: begin // beq
          if(i_A == i_B)
          begin
             o_branch = 1'b1;
          end
        end
        1: begin // bne
          if(i_A != i_B)
          begin
             o_branch = 1'b1;
          end
        end
        4: begin // blt
          if($signed(i_A) < $signed(i_B))
          begin
             o_branch = 1'b1;
          end
        end
        5: begin // bge
          if($signed(i_A) >= $signed(i_B))
          begin
             o_branch = 1'b1;
          end
        end
        6: begin // bltu
          if(i_A < i_B)
          begin
             o_branch = 1'b1;
          end 
        end
        7: begin // bgeu
          if(i_A >= i_B)
          begin
             o_branch = 1'b1;
          end
        end
        default: begin
            o_branch = 1'bx; // should never go here
        end
      endcase
      o_ALUOutput = tmp_PC;
    end
    else if(i_ALUop==2) // R-type..
    begin
      case(i_func3)
      0: begin // ADD/SUB
  	//$display ("\t~~~~~ALUout (res. was: %d)\n", o_ALUOutput);
          if(i_func7 == 0) // ADD
          begin
             o_ALUOutput = i_A + i_B;
            // $display ("\tALUout (res. was: %d)\n", o_ALUOutput);
          end
          else                // SUB (func7==1'b1)
          begin
             o_ALUOutput = i_A - i_B;
             //$display ("\tALUout (res. was: %d)\n", o_ALUOutput);
          end
        end
        1: begin // SLL
          o_ALUOutput = (i_A<<i_B); // shifted left by i_B
        end
        2: begin // SLT
          if($signed(i_A) < $signed(i_B))
            begin
              o_ALUOutput = 32'b1;
            end
            else
            begin
              o_ALUOutput = 32'b0;
            end
          end
        3: begin // SLTU
            if(i_A < i_B)
            begin
              o_ALUOutput = 32'b1;
            end
            else
            begin
              o_ALUOutput = 32'b0;
            end
          end
        4: begin // XOR
          begin
            o_ALUOutput = i_A ^ i_B;
          end
        end
        5: begin // SRL/SRA
          if(i_func7 == 1'b0) // SRL
          begin
             o_ALUOutput      = (i_A>>i_B); // shifted right by i_B
          end
          else                // SRA (func7==1'b1)
          begin
             o_ALUOutput      = (i_A>>i_B);
             o_ALUOutput[31]  = i_A[31]; // keep sign-bit
          end
        end
        6: begin // OR
        	o_ALUOutput = i_A | i_B;
        end
        7: begin // AND
          o_ALUOutput = i_A & i_B;
        end
        default: begin
            o_ALUOutput = 1'bx; // should never go here
        end
      endcase
    end
    else if(i_ALUop==3) // I-type..
    begin
      case(i_func3)
        0: begin // ADDI
          o_ALUOutput = i_A + i_Imm_SignExt;
        end
        1: begin // SLLI
          o_ALUOutput = i_A << i_Imm_SignExt;
        end
        2: begin // SLTI
          if($signed(i_A) < $signed(i_Imm_SignExt))
            begin
              o_ALUOutput = 32'b1;
            end
            else
            begin
              o_ALUOutput = 32'b0;
            end
          end
        3: begin // SLTIU
          if(i_A < i_Imm_SignExt)
            begin
              o_ALUOutput = 32'b1;
            end
            else
            begin
              o_ALUOutput = 32'b0;
            end
          end
        4: begin // XORI
          begin
            o_ALUOutput = i_A ^ i_Imm_SignExt;
          end
        end
        5: begin // SRLI, SRAI TODO
          if(i_func7 == 1'b0) // SRLI
          begin
             o_ALUOutput      = (i_A>>i_Imm_SignExt);
          end
          else                // SRAI (func7==1'b1)
          begin
             o_ALUOutput      = (i_A>>i_Imm_SignExt);
             o_ALUOutput[31]  = i_A[31]; // keep sign-bit
          end
        end
        6: begin // ORI
          o_ALUOutput = i_A | i_Imm_SignExt;
        end
        7: begin // ANDI
          o_ALUOutput = i_A & i_Imm_SignExt;
        end
        default: begin
            o_ALUOutput = 1'bx; // should never go here
        end
      endcase
    end
    else if(i_ALUop==4) // I-type.., LUI
    begin
      o_ALUOutput = i_Imm_SignExt;
    end
    else if(i_ALUop==5 || i_ALUop==6) // I-type.., AUIPC, JAL
    begin
      o_ALUOutput = tmp_PC;
    end
    else if(i_ALUop==7) // I-type.., JALR
    begin
      tmp_value = i_A + i_Imm_SignExt;
      o_ALUOutput = {tmp_value[31:1], 1'b0};
    end
  end
  else // there is a need for stall in execution state
       // wait until the needed new PC
  begin
    if(i_NPC == stalled_PC)
    begin
      stalled_PC = 32'b0;
    end
  end
end
endmodule
