`include "../PipelineRegs.sv"
`include "../ISA.sv"
module top;
	bit clk;
	bit reset;
	logic [31:0] pc;
	logic [4:0] src1;
	logic [4:0] src2;
	logic [4:0] dst;
	logic [31:0] data_out0;
	logic [31:0] data_out1;
	logic [31:0] data_in;
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
		.rs1(src1),
		.rs2(src2),
		.rd(dst)
	);
	
	RegFile regF(
		.clk(clk),
		.we(we),
		.read_addr0(src1),
		.read_addr1(src2),
		.write_addr(dst),
		.din(data_in),
		.dout0(data_out0),
		.dout1(data_out1)
	);

	
	if_id_tb tb(
		.clk(clk),
		.pc(pc),
		.ex_state(ex_reg),
		.data0(data_out0),
		.data1(data_out1)
	);




	initial begin
		clk = 0;
		forever begin
			#100 clk = ~clk;
		end
	end


endmodule
