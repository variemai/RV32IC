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
 *  Description:  Test for the Arithmetic Logic Unit (ALU)           *
 *                for a 32-bit RISC-V                                *
 *                                                                   *
 *********************************************************************/

program alu_test(

    input 				clk,
    output reg 				reset_p,
    output reg	[31:0] 			A_p,
    output reg 	[31:0]			B_p,
    output reg  [5:0]			ALUmode_p,
    output reg 	[31:0]			Imm_SignExt_p,
    output reg 	[31:0]			NPC_p,
    input 	[31:0]			ALUOutput_p,
    input 				branch_p,
    input       [31:0]			retaddr_p);



`define A 	32'h1
`define B 	32'h1
`define Imm 	32'h1
`define NPC	32'h1

reg 	[31:0]	tmp_res;
reg 		tmp_branch;

task alu_arithmetic_ops_test();
	$write("Task alu_arithmetic_ops_test: Arithmetic Operations of ALU - Verification\n");

	//`define A 32'h1
	//`define B 32'h1
	A_p             <= `A;
        B_p             <= `B;
	Imm_SignExt_p	<= `Imm;

	/******* ADD *******/
        @(posedge clk) 
        	//A_p 		<= 32'h1;
        	//B_p 		<= 32'h1;
		ALUmode_p 	<= ADD;
        @(posedge clk);
	expect(@(posedge clk) ALUOutput_p == (A_p+B_p)) else $display ("\tArithm. of ALU: ADD failed! (res. was: %d, while expected was: %d)\n", ALUOutput_p, A_p+B_p);
        
	/******* SUB *******/
        @(posedge clk) 
        	//A_p 		<= 32'hF;
        	//B_p 		<= 32'h1;
        	ALUmode_p 	<= SUB;
        @(posedge clk);
        expect(@(posedge clk) ALUOutput_p == (A_p-B_p)) else $display ("\tArithm. of ALU: SUB failed! (res. was: %d, while expected was: %d)\n", ALUOutput_p, A_p-B_p);

	/******* ADDI *******/
        @(posedge clk) 
        	//A_p 		<= 32'hF;
        	//Imm_SignExt_p <= 32'h1;
        	ALUmode_p 	<= ADDI;
        @(posedge clk);
        expect(@(posedge clk) ALUOutput_p == (A_p+Imm_SignExt_p)) else $display ("\tArithm. of ALU: ADDI failed! (res. was: %d, while expected was: %d)\n", ALUOutput_p, A_p+Imm_SignExt_p);

	/******* SUBI *******/
        @(posedge clk) 
        	//A_p 		<= 32'hF;
        	//Imm_SignExt_p <= 32'h1;
        	ALUmode_p 	<= SUBI;
        @(posedge clk);
        expect(@(posedge clk) ALUOutput_p == (A_p-Imm_SignExt_p)) else $display ("\tArithm. of ALU: SUBI failed! (res. was: %d, while expected was: %d)\n", ALUOutput_p, A_p-Imm_SignExt_p);

	/******* MULT *******/
	@(posedge clk) 
        	//A_p 		<= 32'hF;
        	//B_p 		<= 32'h1;
        	ALUmode_p 	<= MULT;
        @(posedge clk);
        expect(@(posedge clk) ALUOutput_p == (A_p*B_p)) else $display ("\tArithm. of ALU: MULT failed! (res. was: %d, while expected was: %d)\n", ALUOutput_p, A_p*B_p);
	
endtask

task alu_logic_ops_test();
	$write("Task alu_logic_ops_test: Logical Operations of ALU - Verification\n");
	A_p             <= `A;
        B_p             <= `B;
	Imm_SignExt_p	<= `Imm;

	/******* AND *******/
	@(posedge clk) 
        	//A_p 		<= 32'hF;
        	//B_p		<= 32'h1;
        	ALUmode_p 	<= AND;
        @(posedge clk);
        expect(@(posedge clk) ALUOutput_p == (A_p&B_p)) else $display ("\tLogic. of ALU: AND failed! (res. was: %d, while expected was: %d)\n", ALUOutput_p, A_p&B_p);
	
	/******* OR *******/
	@(posedge clk) 
        	//A_p 		<= 32'hF;
        	//B_p		<= 32'h1;
        	ALUmode_p 	<= OR;
        @(posedge clk);
        expect(@(posedge clk) ALUOutput_p == (A_p|B_p)) else $display ("\tLogic. of ALU: OR failed! (res. was: %d, while expected was: %d)\n", ALUOutput_p, A_p|B_p);
	
	/******* ANDI *******/
	@(posedge clk) 
        	//A_p 		<= 32'hF;
        	//Imm_SignExt_p	<= 32'h1;
        	ALUmode_p 	<= ANDI;
        @(posedge clk);
        expect(@(posedge clk) ALUOutput_p == (A_p&Imm_SignExt_p)) else $display ("\tLogic. of ALU: ANDI failed! (res. was: %d, while expected was: %d)\n", ALUOutput_p, A_p&Imm_SignExt_p);
	
	/******* ORI *******/
	@(posedge clk) 
        	//A_p 		<= 32'hF;
        	//Imm_SignExt_p	<= 32'h1;
        	ALUmode_p 	<= ORI;
        @(posedge clk);
        expect(@(posedge clk) ALUOutput_p == (A_p|Imm_SignExt_p)) else $display ("\tLogic. of ALU: ORI failed! (res. was: %d, while expected was: %d)\n", ALUOutput_p, A_p|Imm_SignExt_p);

	/******* XORI *******/
	@(posedge clk) 
        	//A_p 		<= 32'hF;
        	ALUmode_p 	<= XORI;
        @(posedge clk);
        expect(@(posedge clk) ALUOutput_p == (~A_p)) else $display ("\tLogic. of ALU: XORI failed! (res. was: %d, while expected was: %d)\n", ALUOutput_p, ~A_p);

	@(posedge clk) 
        	//A_p 		<= 32'hF;
		//B_p		<= 32'h1;
        	ALUmode_p 	<= SLL;
        @(posedge clk);
        expect(@(posedge clk) ALUOutput_p == (A_p>>B_p)) else $display ("\tLogic. of ALU: SLL failed! (res. was: %d, while expected was: %d)\n", ALUOutput_p, A_p>>B_p);

	/******* SRL *******/
	@(posedge clk) 
        	//A_p 		<= 32'hF;
		//B_p		<= 32'h1;
        	ALUmode_p 	<= SRL;
        @(posedge clk);
        expect(@(posedge clk) ALUOutput_p == (A_p<<B_p)) else $display ("\tLogic. of ALU: SRL failed! (res. was: %d, while expected was: %d)\n", ALUOutput_p, A_p<<B_p);

	/******* SLT *******/
	@(posedge clk) 
        	//A_p 		<= 32'hF;
		//B_p		<= 32'h1;
        	ALUmode_p 	<= SLT;
        @(posedge clk);
	if(A_p<B_p)
	begin
		tmp_res		=  32'b1;
	end
	else
	begin
		tmp_res		= 32'b0;
	end
        expect(@(posedge clk) ALUOutput_p === (tmp_res)) else $display ("\tLogic. of ALU: SLT failed! (res. was: %d, while expected was: %d)\n", ALUOutput_p, tmp_res);

	/******* SLTI *******/
	@(posedge clk) 
        	//A_p 		<= 32'hF;
		//B_p		<= 32'h1;
        	ALUmode_p 	<= SLTI;
        @(posedge clk);
	if(A_p<Imm_SignExt_p)
	begin
		tmp_res		=  32'b1;
	end
	else
	begin
		tmp_res		=  32'b0;
	end
        expect(@(posedge clk) ALUOutput_p === (tmp_res)) else $display ("\tLogic. of ALU: SLTI failed! (res. was: %d, while expected was: %d)\n", ALUOutput_p, tmp_res);

endtask

task alu_control_ops_test();
	$write("Task alu_control_ops_test: Control Operations of ALU - Verification\n");
	
	A_p             <= `A;
        B_p             <= `B;
	Imm_SignExt_p	<= `Imm;
	NPC_p		<= `NPC;
	
	/******* BEQ *******/
	@(posedge clk) 
        	//A_p 		<= 32'hF;
		//B_p		<= 32'h1;
		//Imm_SignExt_p	<= 32'h1;
		//NPC_p		<= 32'h1;
        	ALUmode_p 	<= BEQ;
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
	@(posedge clk) 
        	//A_p 		<= 32'hF;
		//B_p		<= 32'h1;
		//Imm_SignExt_p	<= 32'h1;
		//NPC_p		<= 32'h1;
        	ALUmode_p 	<= BNE;
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
	@(posedge clk) 
        	//A_p 		<= 32'hF;
		//B_p		<= 32'h1;
		//Imm_SignExt_p	<= 32'h1;
		//NPC_p		<= 32'h1;
        	ALUmode_p 	<= BLT;
        @(posedge clk);
	if(A_p<B_p)
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
	@(posedge clk) 
        	//A_p 		<= 32'hF;
		//B_p		<= 32'h1;
		//Imm_SignExt_p	<= 32'h1;
		//NPC_p		<= 32'h1;
        	ALUmode_p 	<= BGE;
        @(posedge clk);
	if(A_p>=B_p)
	begin
		tmp_branch	=  1'b1;
	end
	else
	begin
		tmp_branch	=  1'b0;
	end
	tmp_res = NPC_p + (2<<Imm_SignExt_p);

        expect(@(posedge clk) (branch_p===tmp_branch) && (ALUOutput_p===tmp_res)) else $display ("\tLogic. of ALU: BGE failed! (Out: res. was: %d, while expected was: %d, Branch: es. was: %d, while expected was: %d)\n", ALUOutput_p, tmp_res, branch_p, tmp_branch);

	/******* JAL *******/
	@(posedge clk) 
        	//A_p 		<= 32'hF;
		//Imm_SignExt_p	<= 32'h1;
		//NPC_p		<= 32'h1;
        	ALUmode_p 	<= JAL;
        @(posedge clk);
        expect(@(posedge clk) ( (ALUOutput_p == (NPC_p + (2<<Imm_SignExt_p))) && (retaddr_p == (NPC_p+4)) ) ) else $display ("\tLogic. of ALU: JAL failed! (Out: res. was: %d, while expected was: %d, i_A: res. was: %d, while expected was: %d)\n", ALUOutput_p, (NPC_p + (2<<Imm_SignExt_p)), retaddr_p, (NPC_p+4));
	

endtask

task alu_data_transf_test();
	$write("Task alu_data_transf_test: Data Transfers of ALU - Verification\n");

	A_p             <= `A;
        B_p             <= `B;
	Imm_SignExt_p	<= `Imm;

	/******* LD *******/
	@(posedge clk) 
        	//A_p 		<= 32'hF;
		//Imm_SignExt_p	<= 32'h1;
        	ALUmode_p 	<= LD;
        @(posedge clk);
        expect(@(posedge clk) ALUOutput_p == (A_p+Imm_SignExt_p)) else $display ("\tData transf. of ALU: LD failed! (res. was: %d, while expected was: %d)\n", ALUOutput_p, (A_p+Imm_SignExt_p));

	/******* ST *******/
	@(posedge clk) 
        	//A_p 		<= 32'hF;
		//Imm_SignExt_p	<= 32'h1;
        	ALUmode_p 	<= ST;
        @(posedge clk);
        expect(@(posedge clk) ALUOutput_p == (A_p+Imm_SignExt_p)) else $display ("\tData transf. of ALU: ST failed! (res. was: %d, while expected was: %d)\n", ALUOutput_p, (A_p+Imm_SignExt_p));

endtask




initial begin
	repeat(2000)
	begin
		alu_arithmetic_ops_test();
		alu_logic_ops_test();
		alu_control_ops_test();
		alu_data_transf_test();
	end
end




endprogram
