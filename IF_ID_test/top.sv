`include "../PipelineRegs.sv"
`include "../ISA.sv"
module top;
	bit clk;
	logic reset;
	logic pc_enable;
	logic [31:0] pc;
	logic [31:0] data_out0;
	logic [31:0] data_out1;
	logic [31:0] data_in;
	PipelineReg::ID_STATE id_reg;
	PipelineReg::EX_STATE id_ex_reg;
	PipelineReg::EX_STATE ex_reg;


	IFetch fetch(
		.clk(clk),
		.enable(pc_enable),
		.pc_in(id_reg.pc),
		.pc_out(id_reg.pc),
		//.stall_pc(pc),
		.reset(reset),
		//.pc_out(id_reg.pc),
		.instruction(id_reg.instruction)
	);
	
	decoder decode(
		.clk(clk),
		.id_state(id_reg),
		.reset(reset),
		//.stall_pc(pc),
		.ex_state(id_ex_reg),
		.enable_pc(pc_enable)
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

	id_ex_reg idexreg(
		.clk(clk),
		.in(id_ex_reg),
		.out(ex_reg)
	);

	
	if_id_tb tb(
		.clk(clk),
		.ex_state(ex_reg),
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
