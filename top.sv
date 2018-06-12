`include "PipelineRegs.sv"
`include "ISA.sv"

module top;
	bit clk;
	logic reset;
	logic pc_enable;
	logic [31:0] pc;
	logic [31:0] pc_stall;
	logic [31:0] reg_dataA;
	logic [31:0] reg_dataB;
	logic [31:0] data_in;
	logic valid;

	logic [31:0] rdata;

	PipelineReg::ID_STATE id_reg;
	PipelineReg::EX_STATE id_ex_reg;
	PipelineReg::EX_STATE ex_reg;
	PipelineReg::MEM_STATE mem_state;
	PipelineReg::WBACK_STATE wb_state;	

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
		.dout0(reg_dataA),
		.dout1(reg_dataB)
	);

	id_ex_reg ID_EX(
		.clk(clk),
		.in(id_ex_reg),
		.out(ex_reg)
	);

	
        alu EX_MEM(
    		.i_clk          ( clk ),
    		.i_reset        ( reset ),
    		.i_A            ( reg_dataA ),
    		.i_B            ( reg_dataB ),

    		.i_Imm_SignExt  ( ex_reg.immediate ),
    		.i_NPC          ( ex_reg.pc ),
    		.i_ALUop        ( ex_reg.ALUOp ),
    		.i_func3        ( ex_reg.func3 ),
    		.i_func7        ( ex_reg.func7 ), // 1 bit

    		.o_ALUOutput    ( mem_state.ALUOutput ),
    		.o_branch       ( mem_state.branch )
  	);

	dmem MEM_WB(
                .i_clk(clk),
                .i_we(mem_state.MemWrite),

                .i_addr(mem_state.ALUOutput),
                .i_wdata(mem_state.write_reg),
          	.i_mem_state(mem_state),
		.o_rdata(rdata),
		.o_wback_state(wb_state)
	);


	 top_tb tb(
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
