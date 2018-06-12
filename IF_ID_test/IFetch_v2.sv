/*****************************************************************************
 * The Instruction Fetch module, reads from instruction memory using a 32bit *
 * pc depending on the control signals                                       *
 * Authors: Vardas Ioannis                                                   *
 * created for the purposes of CS-523 RISC-V 32 bit implementation project   *
 * Computer Science Department University of Crete 27/03/2018                *
 *****************************************************************************/
`include "PipelineRegs.sv"

module IFetch(
	input clk,
	input logic reset,
	input logic stall,
	input logic jmp,
	input logic [31:0] jmp_pc,
	output logic [31:0] pc_out,
	output logic [31:0] instruction,
	output logic valid
	);

	logic [31:0] pc_in;
	logic [31:0] pc;
	/*
	logic [31:0] instruction_r;
	logic [31:0] instruction_m;
	
	logic stall_r;

	always_ff @ (posedge clk) begin
		if(reset) stall_r <= 0;
		else begin
			stall_r <= stall;
		end
	end
	*/
	always_ff @(posedge clk) begin 
		$write("STALL SIGNAL: %d\n",stall);
		//$write("PC_IN: %d\nPC_OUT: %d\n",pc_in,pc_out);
		if(reset) begin 
			pc <= 'h0;
			pc_out <= 'h0;
			valid <= 0;
		end
		else begin
			pc <= pc_in;
			pc_out <= pc;
			valid <= 1;
		end
	end

	//assign	pc_4 = pc_out + 4;
	//assign	pc_in = stall ? pc_out: pc_4;
	always_comb begin
		if(jmp) begin 
			pc_in = jmp_pc;
		end else if(~stall) begin 
			pc_in = pc + 4;
		end else begin
			pc_in = pc;
		end
	end

	imem InstructionMem(
		.clk(clk),
		.addr(pc[10:2]),
		.dout(instruction)
	);
	/*
	assign instruction = stall_r ? instruction_r : instruction_m;
	always_ff @(posedge clk) begin
		if(reset) instruction_r <= 32'b0;
		else begin
			instruction_r <= instruction_m;
		end
	end
	*/
endmodule
