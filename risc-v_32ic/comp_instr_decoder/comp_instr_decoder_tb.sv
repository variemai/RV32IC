

program comp_instr_decoder_tb(
	input					aclk,
	input  logic	[31:0]	decomp_instruction,
	input  logic	[31:0]	word,
	//input  logic	[1:0]	control,
	output logic			aresetn,
	output logic	[10:0]	address,
	output logic	[15:0]	cinstruction);
	
	logic [10:0]	i;
	initial begin
		aresetn = 0;
		repeat (10) @(posedge aclk);
		aresetn = 1;
		@(posedge aclk);
		for(i=0; i<20; i = i+1) begin
			 @(posedge aclk);
			 feed_address(i);
			 @(posedge aclk);
				cinstruction = word[15:0];
				//@(posedge aclk);
				display_instruction();
				$write("instruction: %b\n",word[15:0]);
			@(posedge aclk)
				cinstruction = word[31:16];
				//@(posedge aclk);
				display_instruction();
				$write("instructionMSB: %b\n",word[31:16]);
		end
	end
	
	task feed_address(input [10:0] addr);
		address = addr;
	endtask
	
	task display_instruction();
		$write("decomp_instruction: %b\n",decomp_instruction);
	endtask
	
endprogram
