module branch_target_tb();

reg clk, update,access;
reg [31:0] PC_in;
reg [31:0] branch_target;
wire [31:0] predictPC;
wire [1:0] state;
branch_target_predictor_buffer branch_target_predictor_buffer(
	.clk(clk),
	.PC_in(PC_in), 
	.branch_target(branch_target),
	.access(access),
	.update(update),		//update enables write to the branch buffer
	.predictPC(predictPC), 
	.state(state)
);


initial begin
	clk = 1;
	forever #10 clk = ~clk;	//initiate clock sequence
end


initial begin
	update <= 1;
	access <= 0;
	PC_in <= 32'h00000008;	//enter current PC, should write next PC
	branch_target <= 32'h24;
	
	#40
	update <= 0;
	access <= 1;
	PC_in <= 32'h0000000C;	//check the target that just got stored

end




endmodule