module PC_reg(
	inout [31:0] pc
);

	initial begin
		pc = 32'b0;
	end

	always @ (posedge clk)
		pc <= pc +4;

endmodule
