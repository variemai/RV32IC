`include "../PipelineRegs.sv"
`include "../ISA.sv"
module top;
	bit clk;
	wire [31:0] pc;
	PipelineReg::ID_STATE id_reg;
	PipelineReg::EX_STATE ex_reg;
	
	IFetch fetch(
		.clk(clk),
		.pc_in(id_reg.pc),
		.pc_out(id_reg.pc),
		.instruction(id_reg.instruction)
	);
	
	decoder decode(
		.clk(clk),
		.reset(reset),
		.id_state(id_reg),
		.ex_state(ex_reg),
		.rs1
		.rs2
		.rd
		.write_data
	);	
	

	initial begin
		clk = 0;
		forever begin
			#100 clk = ~clk;
		end
	end


endmodule
