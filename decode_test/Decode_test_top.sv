`include "../PipelineRegs.sv"
module decode_test_top;
	bit clk;
	PipelineReg::ID_STATE id_state;
	PipelineReg::EX_STATE ex_state;
	logic reset;
	logic [4:0] rdsrc1;
	logic [4:0] rdsrc2;
	logic [4:0] regDest;
	logic [31:0] write_data;
	logic [31:0] dout0;
	logic [31:0] dout1;

	RegFile registerfile(
		.clk(clk),
		.we(we),
		.read_addr0(rdsrc1),
		.read_addr1(rdsrc2),
		.write_addr(regDest),
		.din(write_data),
		.dout0(dout0),
		.dout1(dout1)
	);
		

	decoder dut(
		.clk(clk),
		.reset(reset),
		.id_state(id_state),
		.ex_state(ex_state),
		.rs1(rdsrc1),
		.rs2(rdsrc2),
		.rd(regDest),
		.write_data(write_data)
	);
	
	decode_test tb(
		.clk(clk),
		.ex_state(ex_state),
		.id_state(id_state),
		.data0(dout0),
		.data1(dout1)
	);

	initial begin
		clk = 0;
		forever begin
			#100 clk = ~clk;
		end
	end
endmodule
