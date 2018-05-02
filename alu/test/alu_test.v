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
 *  Description:  Test for the Arithmetic Logic Unit (ALU)           *
 *                for a 32-bit RISC-V                                *
 *                                                                   *
 *********************************************************************/

program alu_test(

    input 				clk,
    output reg 			reset_p,
    output reg	[31:0] 	A_p,
    output reg 	[31:0]	B_p,
    output reg  [6:0]	ALUmode_p,
    output reg 	[31:0]	Imm_SignExt_p,
    output reg 	[31:0]	NPC_p,
    output reg  [2:0]   ALUop_p,
  	output reg  [2:0]   func3_p,
  	output reg          func7_p, // 1 bit
    input  		[31:0]  ALUOutput_p,
    input 				branch_p,
    input  		[31:0]  retaddr_p);



`define A 	32'h1
`define B 	32'h1
`define Imm 	32'h1
`define NPC	32'h1


reg 	[31:0]	tmp_res;
reg 		tmp_branch;


task set_params();

    ALUop_p = 0;
    if(ALUmode_p==LUI)
    begin
      ALUop_p = 4;
      func3_p = 0; // not needed
      func7_p = 0; // not needed
    end
    else if(ALUmode_p==AUIPC)
    begin
      ALUop_p = 5;
      func3_p = 0; // not needed
      func7_p = 0; // not needed
    end
    else if(ALUmode_p==JAL)
    begin
      ALUop_p = 6;
      func3_p = 0; // not needed
      func7_p = 0; // not needed
    end
    else if(ALUmode_p==JALR)
    begin
      ALUop_p = 7;
      func3_p = 0; // not needed
      func7_p = 0; // not needed
    end
    else if(ALUmode_p==BEQ)
    begin
      ALUop_p = 1; // same for all branches
      func3_p = 0;
      func7_p = 0; // not needed
    end
    else if(ALUmode_p==BNE)
    begin
      ALUop_p = 1; // same for all branches
      func3_p = 1;
      func7_p = 0; // not needed
    end
    else if(ALUmode_p==BLT)
    begin
      ALUop_p = 1; // same for all branches
      func3_p = 4;
      func7_p = 0; // not needed
    end
    else if(ALUmode_p==BGE)
    begin
      ALUop_p = 1; // same for all branches
      func3_p = 5;
      func7_p = 0; // not needed
    end
    else if(ALUmode_p==BLTU)
    begin
      ALUop_p = 1; // same for all branches
      func3_p = 6;
      func7_p = 0; // not needed
    end
    else if(ALUmode_p==BGEU)
    begin
      ALUop_p = 1; // same for all branches
      func3_p = 7;
      func7_p = 0; // not needed
    end
    else if(ALUmode_p==LB)
    begin
      ALUop_p = 0; // same for all ld/st instructions
      func3_p = 0; // not needed
      func7_p = 0; // not needed
    end
    else if(ALUmode_p==LH)
    begin
      ALUop_p = 0; // same for all ld/st instructions
      func3_p = 0; // not needed
      func7_p = 0; // not needed
    end
    else if(ALUmode_p==LW)
    begin
      ALUop_p = 0; // same for all ld/st instructions
      func3_p = 0; // not needed
      func7_p = 0; // not needed
    end
    else if(ALUmode_p==LBU)
    begin
      ALUop_p = 0; // same for all ld/st instructions
      func3_p = 0; // not needed
      func7_p = 0; // not needed
    end
    else if(ALUmode_p==LHU)
    begin
      ALUop_p = 0; // same for all ld/st instructions
      func3_p = 0; // not needed
      func7_p = 0; // not needed
    end
    else if(ALUmode_p==SB)
    begin
      ALUop_p = 0; // same for all ld/st instructions
      func3_p = 0; // not needed
      func7_p = 0; // not needed
    end
    else if(ALUmode_p==SH)
    begin
      ALUop_p = 0; // same for all ld/st instructions
      func3_p = 0; // not needed
      func7_p = 0; // not needed
    end
    else if(ALUmode_p==SW)
    begin
      ALUop_p = 0; // same for all ld/st instructions
      func3_p = 0; // not needed
      func7_p = 0; // not needed
    end
    else if(ALUmode_p==ADDI)
    begin
      ALUop_p = 3; // same for most I-Type instructions
      func3_p = 0;
      func7_p = 0; // not needed
    end
    else if(ALUmode_p==SLLI)
    begin
      ALUop_p = 3; // same for most I-Type instructions
      func3_p = 1;
      func7_p = 0; // not needed
    end
    else if(ALUmode_p==SLTI)
    begin
      ALUop_p = 3; // same for most I-Type instructions
      func3_p = 2;
      func7_p = 0; // not needed
    end
    else if(ALUmode_p==SLTIU)
    begin
      ALUop_p = 3; // same for most I-Type instructions 
      func3_p = 3;
      func7_p = 0; // not needed
    end
    else if(ALUmode_p==XORI)
    begin
      ALUop_p = 3; // same for most I-Type instructions 
      func3_p = 4;
      func7_p = 0; // not needed
    end
    else if(ALUmode_p==SRLI)
    begin
      ALUop_p = 3; // same for most I-Type instructions 
      func3_p = 5;
      func7_p = 0;
    end
    else if(ALUmode_p==SRAI)
    begin
      ALUop_p = 3; // same for most I-Type instructions 
      func3_p = 5;
      func7_p = 1;
    end
    else if(ALUmode_p==ORI)
    begin
      ALUop_p = 3; // same for most I-Type instructions 
      func3_p = 6;
      func7_p = 0; // not needed
    end
    else if(ALUmode_p==ANDI)
    begin
      ALUop_p = 3; // same for most I-Type instructions 
      func3_p = 7;
      func7_p = 0; // not needed
    end
    else if(ALUmode_p==ADD)
    begin
      ALUop_p = 2; // same for all R-Type instructions 
      func3_p = 0;
      func7_p = 0;
    end
    else if(ALUmode_p==SUB)
    begin
      ALUop_p = 2; // same for all R-Type instructions 
      func3_p = 0;
      func7_p = 1;
    end
    else if(ALUmode_p==SLL)
    begin
      ALUop_p = 2; // same for all R-Type instructions 
      func3_p = 1;
      func7_p = 0; // not needed
    end
    else if(ALUmode_p==SLT)
    begin
      ALUop_p = 2; // same for all R-Type instructions 
      func3_p = 2;
      func7_p = 0; // not needed
    end
    else if(ALUmode_p==SLTU)
    begin
      ALUop_p = 2; // same for all R-Type instructions 
      func3_p = 3;
      func7_p = 0; // not needed
    end
    else if(ALUmode_p==XOR)
    begin
      ALUop_p = 2; // same for all R-Type instructions 
      func3_p = 4;
      func7_p = 0; // not needed
    end
    else if(ALUmode_p==SRL)
    begin
      ALUop_p = 2; // same for all R-Type instructions 
      func3_p = 5;
      func7_p = 0;
    end
    else if(ALUmode_p==SRA)
    begin
      ALUop_p = 2; // same for all R-Type instructions 
      func3_p = 5;
      func7_p = 1;
    end
    else if(ALUmode_p==OR)
    begin
      ALUop_p = 2; // same for all R-Type instructions 
      func3_p = 6;
      func7_p = 0; // not needed
    end
    else if(ALUmode_p==AND)
    begin
      ALUop_p = 2; // same for all R-Type instructions 
      func3_p = 7;
      func7_p = 0; // not needed
    end
endtask



task alu_arithmetic_ops_test();
	$write("Task alu_arithmetic_ops_test: Arithmetic Operations of ALU - Verification\n");

	//`define A 32'h1
	//`define B 32'h1
	A_p             <= `A;
  B_p         	<= `B;
	Imm_SignExt_p	<= `Imm;

	/******* ADD *******/
  @(posedge clk);
	ALUmode_p 	= ADD;
	set_params();
  @(posedge clk);
	expect(@(posedge clk) ALUOutput_p == (A_p+B_p)) else $display ("\tArithm. of ALU: ADD failed! (res. was: %d, while expected was: %d)\n", ALUOutput_p, A_p+B_p);
  
  /******* SUB *******/
  @(posedge clk);
  ALUmode_p   = SUB;
  set_params();
  @(posedge clk);
  expect(@(posedge clk) ALUOutput_p === (A_p-B_p)) else $display ("\tArithm. of ALU: SUB failed! (res. was: %d, while expected was: %d)\n", ALUOutput_p, A_p-B_p);
  
  /******* ADDI *******/
  @(posedge clk) 
  ALUmode_p   = ADDI;
  set_params();
  @(posedge clk);
  expect(@(posedge clk) ALUOutput_p == (A_p+Imm_SignExt_p)) else $display ("\tArithm. of ALU: ADDI failed! (res. was: %d, while expected was: %d)\n", ALUOutput_p, A_p+Imm_SignExt_p);
  

endtask

task alu_logic_ops_test();
	$write("Task alu_logic_ops_test: Logical Operations of ALU - Verification\n");
	A_p             <= `A;
  B_p             <= `B;
	Imm_SignExt_p	<= `Imm;

	/******* AND *******/
	@(posedge clk);
  ALUmode_p 	= AND;
  set_params();
  @(posedge clk);
  expect(@(posedge clk) ALUOutput_p == (A_p&B_p)) else $display ("\tLogic. of ALU: AND failed! (res. was: %d, while expected was: %d)\n", ALUOutput_p, A_p&B_p);
	
	/******* OR *******/
	@(posedge clk);
  ALUmode_p 	= OR;
  set_params();
  @(posedge clk);
  expect(@(posedge clk) ALUOutput_p == (A_p|B_p)) else $display ("\tLogic. of ALU: OR failed! (res. was: %d, while expected was: %d)\n", ALUOutput_p, A_p|B_p);
	
  /******* XOR *******/
  @(posedge clk);
  ALUmode_p   = XOR;
  set_params();
  @(posedge clk);
  expect(@(posedge clk) ALUOutput_p == (A_p^B_p)) else $display ("\tLogic. of ALU: XOR failed! (res. was: %d, while expected was: %d)\n", ALUOutput_p, A_p^B_p);
  
	/******* ANDI *******/
	@(posedge clk);
  ALUmode_p 	= ANDI;
  set_params();
  @(posedge clk);
  expect(@(posedge clk) ALUOutput_p == (A_p&Imm_SignExt_p)) else $display ("\tLogic. of ALU: ANDI failed! (res. was: %d, while expected was: %d)\n", ALUOutput_p, A_p&Imm_SignExt_p);
	
	/******* ORI *******/
	@(posedge clk);
  ALUmode_p 	= ORI;
  set_params();
  @(posedge clk);
  expect(@(posedge clk) ALUOutput_p == (A_p|Imm_SignExt_p)) else $display ("\tLogic. of ALU: ORI failed! (res. was: %d, while expected was: %d)\n", ALUOutput_p, A_p|Imm_SignExt_p);

	/******* XORI *******/
	@(posedge clk);
  ALUmode_p 	= XORI;
  set_params();
  @(posedge clk);
  expect(@(posedge clk) ALUOutput_p == (A_p^Imm_SignExt_p)) else $display ("\tLogic. of ALU: XORI failed! (res. was: %d, while expected was: %d)\n", ALUOutput_p, A_p^Imm_SignExt_p);

  /******* SLL *******/
	@(posedge clk);
  ALUmode_p 	= SLL;
  set_params();
  @(posedge clk);
  expect(@(posedge clk) ALUOutput_p == (A_p<<B_p)) else $display ("\tLogic. of ALU: SLL failed! (res. was: %d, while expected was: %d)\n", ALUOutput_p, A_p<<B_p);

  /******* SLL *******/
  @(posedge clk);
  ALUmode_p   = SLLI;
  set_params();
  @(posedge clk);
  expect(@(posedge clk) ALUOutput_p == (A_p<<B_p)) else $display ("\tLogic. of ALU: SLLI failed! (res. was: %d, while expected was: %d)\n", ALUOutput_p, A_p<<Imm_SignExt_p);


	/******* SRL *******/
	@(posedge clk);
  ALUmode_p 	= SRL;
  set_params();
  @(posedge clk);
  expect(@(posedge clk) ALUOutput_p == (A_p>>B_p)) else $display ("\tLogic. of ALU: SRL failed! (res. was: %d, while expected was: %d)\n", ALUOutput_p, A_p>>B_p);

  /******* SRLI *******/
  @(posedge clk);
  ALUmode_p   = SRLI;
  set_params();
  @(posedge clk);
  expect(@(posedge clk) ALUOutput_p == (A_p>>Imm_SignExt_p)) else $display ("\tLogic. of ALU: SRLI failed! (res. was: %d, while expected was: %d)\n", ALUOutput_p, A_p>>Imm_SignExt_p);

	/******* SLT *******/
	@(posedge clk);
  ALUmode_p 	= SLT;
  set_params();
  @(posedge clk);
	if($signed(A_p)<$signed(B_p))
	begin
		tmp_res		=  32'b1;
	end
	else
	begin
		tmp_res		= 32'b0;
	end
  expect(@(posedge clk) ALUOutput_p === (tmp_res)) else $display ("\tLogic. of ALU: SLT failed! (res. was: %d, while expected was: %d)\n", ALUOutput_p, tmp_res);

  /******* SLTU *******/ // TODO
  @(posedge clk);
  ALUmode_p   = SLTU;
  set_params();
  @(posedge clk);
  if(A_p<B_p)
  begin
    tmp_res   =  32'b1;
  end
  else
  begin
    tmp_res   = 32'b0;
  end
  expect(@(posedge clk) ALUOutput_p === (tmp_res)) else $display ("\tLogic. of ALU: SLTU failed! (res. was: %d, while expected was: %d)\n", ALUOutput_p, tmp_res);

	/******* SLTI *******/
	@(posedge clk);
  ALUmode_p 	= SLTI;
  set_params();
  @(posedge clk);
	if($signed(A_p)<$signed(Imm_SignExt_p))
	begin
		tmp_res		=  32'b1;
	end
	else
	begin
		tmp_res		=  32'b0;
	end
  expect(@(posedge clk) ALUOutput_p === (tmp_res)) else $display ("\tLogic. of ALU: SLTI failed! (res. was: %d, while expected was: %d)\n", ALUOutput_p, tmp_res);

  /******* SLTIU *******/ // TODO
  @(posedge clk);
  ALUmode_p   = SLTIU;
  set_params();
  @(posedge clk);
  if(A_p<Imm_SignExt_p)
  begin
    tmp_res   =  32'b1;
  end
  else
  begin
    tmp_res   =  32'b0;
  end
  expect(@(posedge clk) ALUOutput_p === (tmp_res)) else $display ("\tLogic. of ALU: SLTIU failed! (res. was: %d, while expected was: %d)\n", ALUOutput_p, tmp_res);


  /******* SRA *******/
  @(posedge clk);
  ALUmode_p   = SRA;
  set_params();
  @(posedge clk);
  tmp_res      = (A_p>>B_p);
  tmp_res[31]  = A_p[31]; // keep sign-bit
  expect(@(posedge clk) ALUOutput_p == (tmp_res)) else $display ("\tArithm. of ALU: SRA failed! (res. was: %d, while expected was: %d)\n", ALUOutput_p, tmp_res);

  /******* SRAI *******/
  @(posedge clk);
  ALUmode_p   = SRAI;
  set_params();
  @(posedge clk);
  tmp_res      = (A_p>>Imm_SignExt_p);
  tmp_res[31]  = A_p[31]; // keep sign-bit
  expect(@(posedge clk) ALUOutput_p == (tmp_res)) else $display ("\tArithm. of ALU: SRAI failed! (res. was: %d, while expected was: %d)\n", ALUOutput_p, tmp_res);


endtask

task alu_control_ops_test();
	$write("Task alu_control_ops_test: Control Operations of ALU - Verification\n");
	
  A_p             <= `A;
  B_p             <= `B;
  Imm_SignExt_p	  <= `Imm;
  NPC_p		        <= `NPC;
	
	/******* BEQ *******/
  @(posedge clk); 
  ALUmode_p 	= BEQ;
  set_params();
  @(posedge clk);
	if(A_p===B_p)
	begin
		tmp_branch	=  1'b1;
	end
	else
	begin
		tmp_branch	=  1'b0;
	end
	tmp_res = NPC_p + (2<<Imm_SignExt_p);
  expect(@(posedge clk) (branch_p===tmp_branch) && (ALUOutput_p===tmp_res)) else $display ("\tLogic. of ALU: BEQ failed! (Out: res. was: %d, while expected was: %d, Branch: es. was: %d, while expected was: %d)\n", ALUOutput_p, tmp_res, branch_p, tmp_branch);

	/******* BNE *******/
	@(posedge clk);
  ALUmode_p 	= BNE;
  set_params();
  @(posedge clk);
	if(A_p!==B_p)
	begin
		tmp_branch	=  1'b1;
	end
	else
	begin
		tmp_branch	=  1'b0;
	end
	tmp_res = NPC_p + (2<<Imm_SignExt_p);
  expect(@(posedge clk) (branch_p===tmp_branch) && (ALUOutput_p===tmp_res)) else $display ("\tLogic. of ALU: BNE failed! (Out: res. was: %d, while expected was: %d, Branch: es. was: %d, while expected was: %d)\n", ALUOutput_p, tmp_res, branch_p, tmp_branch);

	/******* BLT *******/
	@(posedge clk);
  ALUmode_p 	= BLT;
  set_params();
  @(posedge clk);
	if($signed(A_p)<$signed(B_p))
	begin
		tmp_branch	=  1'b1;
	end
	else
	begin
		tmp_branch	=  1'b0;
	end
	tmp_res = NPC_p + (2<<Imm_SignExt_p);
  expect(@(posedge clk) (branch_p===tmp_branch) && (ALUOutput_p===tmp_res)) else $display ("\tLogic. of ALU: BLT failed! (Out: res. was: %d, while expected was: %d, Branch: es. was: %d, while expected was: %d)\n", ALUOutput_p, tmp_res, branch_p, tmp_branch);

	/******* BGE *******/
	@(posedge clk);
  ALUmode_p 	= BGE;
  set_params();
  @(posedge clk);
	if($signed(A_p)>=$signed(B_p))
	begin
		tmp_branch	=  1'b1;
	end
	else
	begin
		tmp_branch	=  1'b0;
	end
	tmp_res = NPC_p + (2<<Imm_SignExt_p);
  expect(@(posedge clk) (branch_p===tmp_branch) && (ALUOutput_p===tmp_res)) else $display ("\tLogic. of ALU: BGE failed! (Out: res. was: %d, while expected was: %d, Branch: es. was: %d, while expected was: %d)\n", ALUOutput_p, tmp_res, branch_p, tmp_branch);

  /******* BLTU *******/
  @(posedge clk);
  ALUmode_p   = BLTU;
  set_params();
  @(posedge clk);
  if(A_p<B_p)
  begin
    tmp_branch  =  1'b1;
  end
  else
  begin
    tmp_branch  =  1'b0;
  end
  tmp_res = NPC_p + (2<<Imm_SignExt_p);
  expect(@(posedge clk) (branch_p===tmp_branch) && (ALUOutput_p===tmp_res)) else $display ("\tLogic. of ALU: BLTU failed! (Out: res. was: %d, while expected was: %d, Branch: es. was: %d, while expected was: %d)\n", ALUOutput_p, tmp_res, branch_p, tmp_branch);


  /******* BGEU *******/
  @(posedge clk);
  ALUmode_p   = BGEU;
  set_params();
  @(posedge clk);
  if(A_p>=B_p)
  begin
    tmp_branch  =  1'b1;
  end
  else
  begin
    tmp_branch  =  1'b0;
  end
  tmp_res = NPC_p + (2<<Imm_SignExt_p);
  expect(@(posedge clk) (branch_p===tmp_branch) && (ALUOutput_p===tmp_res)) else $display ("\tLogic. of ALU: BGEU failed! (Out: res. was: %d, while expected was: %d, Branch: es. was: %d, while expected was: %d)\n", ALUOutput_p, tmp_res, branch_p, tmp_branch);



  /******* LUI *******/
  @(posedge clk);
  ALUmode_p   = LUI;
  set_params();
  @(posedge clk);
  expect(@(posedge clk) ( (ALUOutput_p == (Imm_SignExt_p)) ) ) else $display ("\tLogic. of ALU: JAL failed! (Out: res. was: %d, while expected was: %d\n", ALUOutput_p, Imm_SignExt_p);

  /******* AUIPC *******/
  @(posedge clk);
  ALUmode_p   = AUIPC;
  set_params();
  @(posedge clk);
  expect(@(posedge clk) ( (ALUOutput_p == (NPC_p + Imm_SignExt_p)) ) ) else $display ("\tLogic. of ALU: JAL failed! (Out: res. was: %d, while expected was: %d\n", ALUOutput_p, NPC_p + Imm_SignExt_p);

	/******* JAL *******/
	@(posedge clk);
  ALUmode_p 	= JAL;
  set_params();
  @(posedge clk);
  expect(@(posedge clk) ( (ALUOutput_p == (NPC_p + Imm_SignExt_p)) ) ) else $display ("\tLogic. of ALU: JAL failed! (Out: res. was: %d, while expected was: %d\n", ALUOutput_p, NPC_p + Imm_SignExt_p);
	
  /******* JALR *******/
  @(posedge clk);
  ALUmode_p   = JALR;
  set_params();
  @(posedge clk);
  expect(@(posedge clk) ( (ALUOutput_p == (A_p + Imm_SignExt_p)) ) ) else $display ("\tLogic. of ALU: JALR failed! (Out: res. was: %d, while expected was: %d\n", ALUOutput_p, A_p + Imm_SignExt_p);
  

endtask

task alu_data_transf_test();
	$write("Task alu_data_transf_test: Data Transfers of ALU - Verification\n");

	A_p             <= `A;
  B_p             <= `B;
	Imm_SignExt_p	<= `Imm;

	/******* LB *******/
	@(posedge clk);
  ALUmode_p 	= LB;
  set_params();
  @(posedge clk);
  expect(@(posedge clk) ALUOutput_p == (A_p+Imm_SignExt_p)) else $display ("\tData transf. of ALU: LB failed! (res. was: %d, while expected was: %d)\n", ALUOutput_p, (A_p+Imm_SignExt_p));

  /******* LH *******/
  @(posedge clk);
  ALUmode_p   = LH;
  set_params();
  @(posedge clk);
  expect(@(posedge clk) ALUOutput_p == (A_p+Imm_SignExt_p)) else $display ("\tData transf. of ALU: LH failed! (res. was: %d, while expected was: %d)\n", ALUOutput_p, (A_p+Imm_SignExt_p));

  /******* LW *******/
  @(posedge clk);
  ALUmode_p   = LW;
  set_params();
  @(posedge clk);
  expect(@(posedge clk) ALUOutput_p == (A_p+Imm_SignExt_p)) else $display ("\tData transf. of ALU: LW failed! (res. was: %d, while expected was: %d)\n", ALUOutput_p, (A_p+Imm_SignExt_p));

  /******* LBU *******/
  @(posedge clk);
  ALUmode_p   = LBU;
  set_params();
  @(posedge clk);
  expect(@(posedge clk) ALUOutput_p == (A_p+Imm_SignExt_p)) else $display ("\tData transf. of ALU: LBU failed! (res. was: %d, while expected was: %d)\n", ALUOutput_p, (A_p+Imm_SignExt_p));

  /******* LHU *******/
  @(posedge clk);
  ALUmode_p   = LHU;
  set_params();
  @(posedge clk);
  expect(@(posedge clk) ALUOutput_p == (A_p+Imm_SignExt_p)) else $display ("\tData transf. of ALU: LHU failed! (res. was: %d, while expected was: %d)\n", ALUOutput_p, (A_p+Imm_SignExt_p));

	/******* SB *******/
	@(posedge clk);
  ALUmode_p 	= SB;
  set_params();
  @(posedge clk);
  expect(@(posedge clk) ALUOutput_p == (A_p+Imm_SignExt_p)) else $display ("\tData transf. of ALU: SB failed! (res. was: %d, while expected was: %d)\n", ALUOutput_p, (A_p+Imm_SignExt_p));

  /******* SH *******/
  @(posedge clk);
  ALUmode_p   = SH;
  set_params();
  @(posedge clk);
  expect(@(posedge clk) ALUOutput_p == (A_p+Imm_SignExt_p)) else $display ("\tData transf. of ALU: SH failed! (res. was: %d, while expected was: %d)\n", ALUOutput_p, (A_p+Imm_SignExt_p));

  /******* SW *******/
  @(posedge clk);
  ALUmode_p   = SW;
  set_params();
  @(posedge clk);
  expect(@(posedge clk) ALUOutput_p == (A_p+Imm_SignExt_p)) else $display ("\tData transf. of ALU: SW failed! (res. was: %d, while expected was: %d)\n", ALUOutput_p, (A_p+Imm_SignExt_p));


endtask




initial begin
	repeat(2)
	begin
		alu_arithmetic_ops_test();
		alu_logic_ops_test();
		alu_control_ops_test();
		alu_data_transf_test();
	end
end




endprogram
