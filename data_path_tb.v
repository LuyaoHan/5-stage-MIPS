/*
Module: datapath test bench 
Note that the input signals mem_access_status, FD_MemStall, is_lw_sw, lw_sw_cnt are temporarily 
pulled out from the datapath module
*/
/*module datapath_tb();

reg clk, reset;
reg mem_access_status, FD_MemStall, is_lw_sw, loc_access;
reg [2:0] lw_sw_cnt;
wire FD_nEN, nPC_EN;
datapath(.clk(clk), 
	.reset(reset),
	.mem_access_status(mem_access_status), 
	.FD_MemStall(FD_MemStall), 
	.is_lw_sw(is_lw_sw), 
	.lw_sw_cnt(lw_sw_cnt),
	.loc_access(loc_access),
	.FD_nEN(FD_nEN), 
	.nPC_EN(nPC_EN)
                );

initial begin
	clk = 1;
	forever #10 clk = ~clk;	//initiate clock sequence
	end


	initial begin
	reset = 1; 
	#5;		//reset at 5ns.
	reset = 0;
	//#200;
	end
	initial begin
	$display("test 1: data miss")	//increment lw_sw counter with detected lw_sw instructionn
	 mem_access_status <= 1'b1;
	 is_lw_sw <= 1'b1;		
	 FD_MemStall <= 1'b1;
 	 lw_sw_cnt <= 3'b0;
	#1;
	lw_sw_cnt <= 3'b1;
	#1;
	lw_sw_cnt <= 3'b2;
	#1;
	lw_sw_cnt <= 3'b3;
	#1;
        loc_access <= 1'b0;		//locality access is false, so data miss
	lw_sw_cnt <= 3'b4;
	#1;
	$display("test 1: data hit")
	 mem_access_status <= 1'b1;
	 is_lw_sw <= 1'b1;		
	 FD_MemStall <= 1'b1;
 	 lw_sw_cnt <= 3'b0;
	#1;
	lw_sw_cnt <= 3'b1;
	#1;
	lw_sw_cnt <= 3'b2;
	#1;
	lw_sw_cnt <= 3'b3;
	#1;
        loc_access <= 1'b1;
	lw_sw_cnt <= 3'b4;
	#1;

	end

endmodule*/