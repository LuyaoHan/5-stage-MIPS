module global_reg( input clk, isTakenE, branch,
	output [1:0] history);

reg [1:0] tempHist;
initial begin 
	tempHist = 2'b0;
end

//This is the shift reg for the global 2-level branch predictor. It is two bits long. The shift reg will be fed back to the datapath.
//It is updated at every branch instruction, and happens whether or not the branch is a hit or miss

assign history = tempHist;
always@(posedge branch) begin
	tempHist[1] = tempHist[0];
	tempHist[0] = isTakenE;
end
endmodule
