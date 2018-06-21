`include "PipelineRegs.sv"

program testbench(
	input clk,
	input PipelineReg::ID_STATE id_state,
	input PipelineReg::EX_STATE ex_state,
	input PipelineReg::MEM_STATE mem_state,
	input PipelineReg::WBACK_STATE wb_state,
	input [31:0] i_A,
	input [31:0] i_B,
	output logic reset
	);
	

	initial begin
		reset <= 1;
		repeat (2) @(posedge clk); 
		reset <= 0;
		for(int i=0; i<16; i++) begin
			@(posedge clk)
			read_all_states();
			//read_wb_state();
			//read_ex_state();
		end
	end

	task read_all_states();

		
		$write("PC\n id: %d, ex: %d, mem: %d, wb:%d \n", id_state.pc, ex_state.pc, mem_state.pc, wb_state.pc);

		$write("MemRead\n ex: %d, mem: %d, wb: %d \n", ex_state.MemRead, mem_state.MemRead, wb_state.MemRead);
		$write("MemWrite\n ex: %d, mem: %d, wb: %d \n", ex_state.MemWrite, mem_state.MemWrite, wb_state.MemWrite);
		

		$write("MemToReg\n ex: %d, mem: %d, wb: %d \n", ex_state.MemToReg, mem_state.MemToReg, wb_state.MemToReg);

		$write("RegWrite\n ex: %d, mem: %d, wb: %d \n", ex_state.RegWrite, mem_state.RegWrite, wb_state.RegWrite);


		$write("rd\n ex: %d, mem: %d, wb:%d \n", ex_state.rd, mem_state.rd, wb_state.rd);


		$write("ALU_A\n ex: %d\n", i_A);
		$write("ALU_B\n ex: %d\n", i_B);
		$write("Immediate\n ex: %d\n", ex_state.immediate);	
		$write("ALUOutput\n mem: %d, wb:%d \n", mem_state.ALUOutput, wb_state.ALUOutput);
		$write("Final Output\n mem: %d\n", wb_state.final_out);
		$write("------------------------\n");

	endtask


	task read_ex_state();
		$write("PC :%d\nRD :%d\n",ex_state.pc, ex_state.rd);
		$write("IMM: %d\nALUOp :%d\n",ex_state.immediate,ex_state.ALUOp);
	endtask

	task read_wb_state();
                $write("PC: %d\nALUout: %d\n",wb_state.pc,wb_state.final_out);
                $write("RD: %d\nRegWrite: %d\n",wb_state.rd,wb_state.RegWrite);
        endtask


endprogram
