module hazard(
	input [4:0] WriteRegM, WriteRegE, WriteRegW, rsE, rtE, rsD, rtD, 
	input [5:0] opcode,
	input MemtoRegM, MemtoRegE, RegWriteW, RegWriteM, RegWriteE, BranchD, MultFinish,FD_nEN,start_multD,
	output reg StallF, StallD, ForwardAD, ForwardBD, FlushE, StallE,
	output reg [1:0] ForwardAE, ForwardBE); //This is subject to change depending on the size of the mux that is used to feed the ALU input. 
//lwstall: load word install
//branchstall: branch stall
//jumpstall: jump stall
//branchstallD: branchstall at Decode stage
reg lwstall, branchstall, jumpstall, branchstallD;


initial begin
  StallF <= 1'b0;	//intialize stall at F/D so that the first instruction passes through FD pipeline register
  StallD <= 1'b0;
end

always @(*) begin
	//for signal ready at memory stage, forwards to execute
	if((rsE != 0) && (rsE == WriteRegM) && RegWriteM) begin
		ForwardAE = 01;
	end	
	//for signal ready at write stage, forwards to execute	
	else if((rsE != 0) && (rsE == WriteRegW) && RegWriteW) begin
		ForwardAE = 10;
	end
	else ForwardAE = 0; 
	if(   (rtE != 0) && (rtE == WriteRegM) && RegWriteM ) begin
		ForwardBE = 01;
	end
	//second one forward from I-type to I-type, 
	else if(((rtE != 0) && (rtE == WriteRegW) && RegWriteW) 
		|| ((rtE != 0) && (rtE == WriteRegE) && RegWriteW)) begin
		ForwardBE = 10;
	end 
	else ForwardBE = 0; 
	
	//for data ready at memory stage, forwards to decode stage
	ForwardAD = (rsD != 0) && (rsD == WriteRegM) && RegWriteM;
	ForwardBD = (rtD != 0) && (rtD == WriteRegM) && (RegWriteM || start_multD);
	//stalls when branch happens
	branchstall = (BranchD && RegWriteE && (WriteRegE == rsD || WriteRegE == rtD)) || (BranchD && MemtoRegM && (WriteRegM == rsD || WriteRegM == rtD));
        //lwstall = ((rsD == rtE) || (rtD == rtE)) && MemtoRegE;
	if(opcode == 6'b100011&& FD_nEN == 1'b1) begin
		lwstall = 1'b1;
	end
	else begin
		lwstall = 1'b0;
	end

	if(opcode == 6'b000010) begin
		jumpstall = 1'b1;
	end
	else begin
		jumpstall = 1'b0;
	end
	//gradient stall
	StallF = jumpstall || MultFinish || branchstall;	//the lw_stall is deleted to be implemented in the data_path |Finn added branchstall to this.
	StallD = lwstall || branchstall || MultFinish;
	FlushE = lwstall || branchstall; 
	StallE = MultFinish;
	end
endmodule