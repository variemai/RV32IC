`include "PipelineRegs.sv"
`include "ISA.sv"
module top;
	bit clk;
	logic reset;
	logic pc_enable;
	logic jmp;
	logic [31:0] pc;
	logic [31:0] pc_stall;
	logic [31:0] pc_jump;
	logic [31:0] data_out0;
	logic [31:0] data_out1;
	logic [31:0] data_in;
	logic valid;
	PipelineReg::ID_STATE id_reg;
	PipelineReg::EX_STATE id_ex_reg;
	PipelineReg::EX_STATE ex_reg;


	IFetch fetch(
		.clk(clk),
		.stall(pc_enable),
		.pc_out(id_reg.pc),
		.jmp(jmp),
		.jmp_pc(pc_jump),
		.reset(reset),
		.valid(valid),
		.instruction(id_reg.instruction)
	);

	decoder decode(
		.clk(clk),
		.id_state(id_reg),
		.reset(reset),
		.ex_state(id_ex_reg),
		.next_state(ex_reg),
		.stall(pc_enable),
		.valid(valid)
	);
	
	RegFile regF(
		.clk(clk),
		.we(we),
		.read_addr0(id_ex_reg.rs1),
		.read_addr1(id_ex_reg.rs2),
		.write_addr(id_ex_reg.rd),
		.din(data_in),
		.dout0(data_out0),
		.dout1(data_out1)
	);

	id_ex_reg ID_EX(
		.clk(clk),
		.in(id_ex_reg),
		.out(ex_reg)
	);

	
	if_id_tb tb(
		.clk(clk),
		.ex_state(ex_reg),
		.jmp_pc(pc_jump),
		.data0(data_out0),
		.data1(data_out1),
		.reset(reset)
	);




	initial begin
		clk = 0;
		forever begin
			#100 clk = ~clk;
		end
	end


endmodule
