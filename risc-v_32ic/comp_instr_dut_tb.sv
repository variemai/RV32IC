

program comp_instr_dut_tb(
	input  bit				aclk,
	input  logic	[31:0]	decomp_instruction,
	input  logic	[31:0]	word,
	output logic			aresetn,
	output logic	[10:0]	address,
	input  logic	[1:0]	control
	);
	
	integer 	i;
	bit 		flag;
	initial begin
		aresetn = 0;
		repeat (10) @(posedge aclk);
		aresetn = 1;
		i=0;
		while(i<20) begin
		//@(posedge aclk);
			
			feed_address(i);
			@(posedge aclk);
			display_instruction();
			if(control == 2'b01) begin
				@(posedge aclk);
				display_instruction();
				@(posedge aclk);
				display_instruction();
			end else if(control == 2'b10 | control == 2'b11)	begin
				@(posedge aclk);
				display_instruction();
				@(posedge aclk);
				display_instruction();
			end
			i = i + 1;
		end
	end
	
	task feed_address(input [10:0] addr);
		address = addr;
	endtask
	
	task display_instruction();
	//@(posedge aclk)
		$write("decomp_instruction: %b\n",decomp_instruction);
	endtask
	
endprogram
