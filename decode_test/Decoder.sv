/*****************************************************************************
 * The Instruction Decoder module, creates the control signals,              *
 * reads from the register file and stores the information to EX_STATE reg   *
 * Authors: Vardas Ioannis                                                   *
 * created for the purposes of CS-523 RISC-V 32 bit implementation project   *
 * Computer Science Department University of Crete 27/03/2018                *
 *****************************************************************************/
`include "../PipelineRegs.sv"
`include "../ISA.sv"
module decoder(
    input clk,
    input reset,
    input PipelineReg::ID_STATE id_state,
    output PipelineReg::EX_STATE ex_state
    );
	
	always @(posedge clk) begin
		casez(id_state.instruction)
			`ADD: begin
				ex_state.pc <= id_state.pc;
				ex_state.rd <= id_state.instruction[11:7];
				ex_state.rs1 <= id_state.instruction[19:15];
				ex_state.rs2 <= id_state.instruction[24:20];
				ex_state.func3 <= id_state.instruction[14:12];
				ex_state.func7 <= id_state.instruction[31:25];
			end
			default: begin
				$write("Unknown Instruction Format!\n");
			end
		endcase
	end


endmodule
