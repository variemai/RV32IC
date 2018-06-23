`include "PipelineRegs.sv"
`include "ISA.sv"

module top;
	bit clk;
	logic reset;
	logic valid;
	logic pc_enable;
	logic nop;
	logic jmp;
	logic [31:0] pc;
	logic [31:0] pc_stall;
	logic [31:0] reg_dataA;
	logic [31:0] reg_dataB;
	logic [31:0] data_in;
	logic [31:0] rdata;
	logic [31:0] jmp_pc;
	PipelineReg::ID_STATE id_reg;
	PipelineReg::EX_STATE id_ex_reg;
	PipelineReg::EX_STATE ex_reg;
	PipelineReg::MEM_STATE mem_state;
	PipelineReg::WBACK_STATE wb_state;	


	wire [31:0]  ALUOutput;
  	wire         branch;

	IFetch fetch(
		.clk(clk),
        .stall(pc_enable),
        .pc_out(id_reg.pc),
        .issue_nop(nop),
        .jmp_pc(jmp_pc),
		.jmp(jmp),
        .reset(reset),
        .valid(valid),
        .instruction(id_reg.instruction)
   );

   decoder decode(
	   .clk(clk),
       .id_state(id_reg),
	   .issue_nop(nop),
       .ex_state(id_ex_reg),
       .next_state(ex_reg),
       .stall(pc_enable),
       .valid(valid)
   );

	RegFile regF(
		.clk(clk),
		.we(wb_state.RegWrite),
		.read_addr0(id_ex_reg.rs1),
		.read_addr1(id_ex_reg.rs2),
		.write_addr(wb_state.rd),
		.din(wb_state.final_out),
		.dout0(reg_dataA),
		.dout1(reg_dataB)
	);

	id_ex_reg ID_EX(
		.clk(clk),
		.in(id_ex_reg),
		.out(ex_reg),
		.reset(reset)
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

    		.o_ALUOutput    ( ALUOutput ),
    		.o_branch       ( branch ),

			.i_ex_state     ( ex_reg ),
    		.o_mem_state    ( mem_state ),
			.o_jmp	( jmp ),
			.o_jmp_pc ( jmp_pc)

  	);

	testbench tb(
		.clk		( clk ),
		.id_state	( id_state ),
		.ex_state	( ex_reg ),
		.mem_state	( mem_state ),
		.wb_state	( wb_state ),
		.i_A		( reg_dataA ),
		.i_B		( reg_dataB ),
		.reset		( reset )
	);

	dmem MEM_WB(
		.i_clk		( clk ),
        	.i_reset	( reset ),
		.i_we		( mem_state.MemWrite ),
		.i_mem_type	( mem_state.mem_type ),
        	.i_addr		( mem_state.ALUOutput ),
        	.i_wdata	( mem_state.write_reg ),
        	.i_mem_state	( mem_state ),
		.o_rdata	( rdata ),
		.o_wback_state	( wb_state )
	);

/*
	 top_tb tb(
                .clk(clk),
                .ex_state(ex_reg),
                .jmp_pc(pc_jump),
                .data0(data_out0),
                .data1(data_out1),
                .reset(reset)
        );

*/
	initial begin
		clk = 0;
		forever begin
			#100 clk = ~clk;
		end
	end


endmodule
