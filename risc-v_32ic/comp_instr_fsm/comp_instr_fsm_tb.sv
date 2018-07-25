

program comp_instr_fsm_tb(
	input					aclk,
	input  logic	[1:0]	fsm_out,
	output logic			aresetn,
	output logic	[3:0]	instruction);
	
	class rand_instr;
		rand bit [3:0]	r;
	endclass
	
	logic [10:0]	i;
	rand_instr instr;
	initial begin
		aresetn = 0;
		repeat (10) @(posedge aclk);
		aresetn = 1;
		//@(posedge aclk);
		instr = new();
		for(i=0; i<100; i = i+1) begin
			assert(instr.randomize())
			else $fatal(0, "rand_instr::randomize failed!");
			feed_instruction(instr);
			display_info();
			@(posedge aclk);
		end
	end
	
	task feed_instruction(input rand_instr instr);
		instruction = instr.r;
	endtask
	
	task display_info();
		$write("fsm_out: %b\tinstruction: %b\n",fsm_out,instr.r);
	endtask
	
endprogram
