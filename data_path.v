module datapath(input          clk, reset
                );
/*
Name: Luyao Han, Finn Linderman
Please open DraftV3.pdf in the diagram folder to refer to the design. 
We originally added a lot of comments, eventually things got unclear. 
but with the diagram it is easy to undertsnad. 
The datapath is composed of five stages, Fetch-Decode-Execute-Memory-Write
Each section is divided with the notation shown below. 
The constructions follows strictly the design in the diagram so the block can be found
between each stage are also appears in the verilog code. 
*/
/*****Fetch*****Fetch*****Fetch*****Fetch*****Fetch*****Fetch*****Fetch*****Fetch*****\ */    

wire [31:0] branch_mux_out,jump_mux_out, calcBranchAddrD,JumpAddr;
reg [31:0] PCplus8_out;
//branch MUX (moves to execution stage)
wire [31:0] InstrD, InstrD2;
wire branch_mux_ctrl;  
wire BranchD;                                                                     

/*
Two cases where branch is taken.
In execution stage: is_bneE, which means it was a load-word
	and RF_ReadData1_E == RF_ReadData2_E

In execuion stage: is_beqE, which means it was a store word 
	and RF_ReadData1_E == RF_ReadData2_E

If branch is taken and the calcBranchAddrE != PredBranchAddr
Then --> Enter branch instruction address and next PC into branch-target buffer
*/ 
wire [31:0] RF_ReadData1_D, RF_ReadData2_D;   //path A      
wire [31:0] RF_ReadData1_D2, RF_ReadData2_D2;  //path B



wire isBranchTakenD; 				//signal to determine if instruction are flushed in execution stage
wire is_bneD,is_beqD;				//determined in the controller by either path A bne/beq or path B bne/beq	 

//this is critical in determining if the branch is indeed taken
assign isBranchTakenD = 
	((is_bneD  && (RF_ReadData1_D != RF_ReadData2_D)) 
	|| (is_beqD  && (RF_ReadData1_D == RF_ReadData2_D)) );

//at fetech stage if op_F is detected as bne/beq --> then 'access' of branch predictor will be set high
wire [5:0] op_F, op_F2;	
wire[31:0] InstrF, InstrF2;
assign op_F = {InstrF[31:26]};
assign op_F2 = {InstrF2[31:26]};





//initialize the branch address at execution stage
wire [31:0] calcBranchAddrE;
wire [1:0] pred_state;


wire [31:0] PCplus8D;
wire [31:0] PC_F,PC_D,PC_E,PC_M;
wire [31:0] PC_out; 
assign PC_F = PC_out;

//access the branch prediction buffer when either of the operation is branch type
assign access = (  (op_F === 6'b000101 || op_F === 6'b000100)      
		|| (op_F2 === 6'b000101 || op_F2 === 6'b000100)); 


//because we are having two PC in each increment, we will have to diffientiate between which one is 
//used to access the branch predictor
wire [31:0] branching_addressF,branching_addressD,branching_addressE,branching_addressM;

//branching_address is now used instead of originally PC_F for accessing the branch predictor 
//access will be strictly enable/disable the read from the branch predictor
assign branching_addressF = (op_F === 6'b000101 || op_F === 6'b000100) ? PC_out : (PC_out+32'h4);

//if branchTakenE is true but calculated address != predicted address, update branch cache
wire isBranchTakenE;
wire [31:0] predBranchAddrE,predBranchAddrD;
wire is_bneE, is_beqE;

/*
There are two cases where the branch cache is updated:
1. Branch is not found in PC so in Fetch stage PC+4 was placed to PC_r; 
    However, if instruction should be taken at execution. This pair should be written to branch cache
2. Branch is found in PC, it was taken at Fetch stage; but at execution stage we realize branch is not supposed
   to be taken, so then pipeline stage CLR are set to flush. 
*/


assign update = (PC_out == 0) ? 32'b0 : 
	( ((calcBranchAddrE != predBranchAddrE) && !isBranchTakenE && (is_bneE === 1 || is_beqE === 1)) || 	//false prediction
	( (PC_E == PC_M + 8) && isBranchTakenE && (is_bneE===1 || is_beqE===1) ) );				//false increment

wire branching;
wire [1:0] history;
assign branching = is_bneE || is_beqE;

//add a 2 after the module name, and pass the PC-F as address like: .address(PC_F)
global_reg gr(.clk(clk), .isTakenE(isBranchTakenE), .branch(branching), .history(history));

assign false_increment = ((calcBranchAddrE != branching_addressD) && (is_bneE === 1 || is_beqE === 1) && isBranchTakenE); //mainly used for hazard when a branch was supposed to be taken but was not
assign false_predict = ((calcBranchAddrE != predBranchAddrE) && (predBranchAddrE != 32'hffffffff)  && !isBranchTakenE && (is_bneE === 1 || is_beqE === 1) ); //This is the inverse of false_increment
assign FD_CLR = false_increment || false_predict; 
assign DE_CLR = false_increment || false_predict; 
assign EM_CLR = false_increment || false_predict ; 
assign MW_CLR = false_predict ;    //we only clear when we have a false predict because if it's a false increment the above CLR signals would have already killed garbage
wire [31:0] predBranchAddrF;

//just add a 1 after the instantiation module name for Extra credit to run
branch_target_predictor_buffer branch_target_predictor_buffer(
	.clk(clk),
	.branching_addressF(branching_addressF), 
	.access(access),
	.update(( (PC_E == PC_M + 8) && isBranchTakenE && (is_bneE===1 || is_beqE===1) )),		//update enables write to the branch buffer
	.branchUpdatePC(branching_addressE),
	.branchUpdateTarget(calcBranchAddrE),	//the calculated address is written to history table
	//.history(history),
        .found(isEntryFound),	
	.predictPC(predBranchAddrF), 
	.state(pred_state)
);


wire [31:0] BranchAddrF;
//branch MUX (signal defined in fetch stage)    
assign branch_mux_ctrl = isEntryFound || update;                                                                
assign branch_mux_out = branch_mux_ctrl? BranchAddrF:PCplus8_out; 
assign BranchAddrF = (update) ?  calcBranchAddrE : predBranchAddrF;  //correct the branch address




////////   /\  /\  /\  /\  /\  /\  /\  /\  /\  /\  /\  /\ //////////
////////   ||  ||  ||  ||  ||  ||  ||  ||  ||  ||  ||  || //////////


//jump MUX
wire se_ze;
assign jump_mux_out =   se_ze?  JumpAddr: branch_mux_out;

//prepare jump address
wire [25:0] JumpAddrRaw;
assign JumpAddrRaw = InstrD[25:0]; 
assign JumpAddr = {4'b0000,JumpAddrRaw<<2};  

//program counter
reg [31:0] PC_r;      		
assign PC_out = PC_r;

always@(negedge reset)begin
  PC_r <= 32'b0;
end

//cache enable
wire mem_access_status; // when data loading, 0 when not


wire [31:0] write_dataE, write_dataM, write_dataE2, write_dataM2;	
wire [31:0] read_dataM, read_dataM2; 
wire MemWriteD, MemWriteE, MemWriteM, MemReadD, MemReadE, MemReadM, MemWriteD2, MemWriteE2,MemWriteM2, MemReadD2, MemReadE2, MemReadM2; 

reg FD_MemStall;
always@(posedge MemReadD)begin			//first fetch
    FD_MemStall <= 1'b1; 			//I am not sure what this does...I believe it has to do with the cache implementation for when we are going to fetch from the cache for a long period of time.
end

always@(posedge MemReadD2)begin			//first fetch
    FD_MemStall <= 1'b1; 			//I am not sure what this does...I believe it has to do with the cache implementation for when we are going to fetch from the cache for a long period of time.
end

/*
The FD_MemStall doesn?t solely decides if the pipeline will stall.
The following logic includes the signal FD_nEN:
assign FD_nEN = ((mem_access_status || FD_MemStall) && ((is_lw_sw && (lw_sw_cnt!=4)) || (is_lw_sw && !loc_access)) );*/
always@(posedge clk)begin				
    if(MemReadD == 1'b1 || MemReadD2 == 1'b1)begin
    FD_MemStall <= 1'b1;
	end
end

//FD_MemStall is shut off when ever the mem_access status goe negedge, this is when the cache has finished fetching a piece of data
always@(negedge mem_access_status)begin
    		FD_MemStall <= 1'b0;
end

assign DE_nEN = mem_access_status || MemWriteD || MemWriteE || MemWriteM || MemReadD || MemReadE || MemReadM || MemWriteD2 || MemWriteE2 || MemWriteM2 || MemReadD2 || MemReadE2 || MemReadM2;

wire [11:0] op_FuncD, op_FuncD2;	//is declare to receive Op_code concatinated with Func. Which this piece of info the specific type of instruction can be determined
reg is_lw_sw, is_lw_sw2;	        //used to subtitite lw_stall in the hazard unit


reg [2:0] lw_sw_cnt, lw_sw_cnt2;	//used to count up whenever a lw_sw is detected in the decode stage so that the cache has enough room to realize if block hits

initial begin
    lw_sw_cnt = 0;
    lw_sw_cnt2 = 0;
end

always@(*)begin
  case(op_FuncD[11:6])				//is_lw_sw are assigned directly depending on the instruction type in the decode stage
	6'b100011 : begin
		is_lw_sw = 1'b1; //lw
		lw_sw_cnt = 1'b0;		//the counter is set to 0 once lw/sw deteced. It is expected to count up to 4 for enough room for loc_access to load
	end
	6'b101011 : begin
		is_lw_sw = 1'b1; //sw
		lw_sw_cnt = 1'b0;
	end
	
	default: is_lw_sw = 0;
  endcase
end

always@(*)begin
  case(op_FuncD2[11:6])				//is_lw_sw are assigned directly depending on the instruction type in the decode stage
	6'b100011 : begin
		is_lw_sw2 = 1'b1; //lw
		lw_sw_cnt2 = 1'b0;		//the counter is set to 0 once lw/sw deteced. It is expected to count up to 4 for enough room for loc_access to load
	end
	6'b101011 : begin
		is_lw_sw2 = 1'b1; //sw
		lw_sw_cnt2 = 1'b0;
	end
	
	default: is_lw_sw2 = 0;
  endcase
end


always@(posedge clk)begin 
   if(lw_sw_cnt == 5) lw_sw_cnt <= 0;	//upper limit for lw_sw_cnt is 4, therefore, the lw_sw_cnt is 0 when it adds to 5
   else begin
      if(is_lw_sw)begin
      lw_sw_cnt = lw_sw_cnt + 1;	//increment lw_sw_cnt while it is still is_lw_sw
    end
   end
   
end

always@(posedge clk)begin 
   if(lw_sw_cnt2 == 5) lw_sw_cnt2 <= 0;	//upper limit for lw_sw_cnt is 4, therefore, the lw_sw_cnt is 0 when it adds to 5
   else begin
      if(is_lw_sw2)begin
      lw_sw_cnt2 = lw_sw_cnt2 + 1;	//increment lw_sw_cnt while it is still is_lw_sw
    end
   end
   
end

wire pipeline_regFD_nEN;	//pipeline register EN signal 
wire loc_access, loc_access2;
/*
The FD_nEN is used to determine (the key) to if the whole processer stop to wait for memory associated instruction
1. The first case is that loc_access is 1, meaning the penalty is just 4 cycles, waiting for the lw_sw_cnt count to 4 and proceed
2. The second case is that loc_access is 0, meaning the penalty is as long as 20 cycles. 
*/
assign FD_nEN = (((mem_access_status || FD_MemStall) && ((is_lw_sw && (lw_sw_cnt!=4)) || (is_lw_sw && !loc_access)) ) || pipeline_regFD_nEN) || (((mem_access_status || FD_MemStall) && ((is_lw_sw2 && (lw_sw_cnt2!=4)) || (is_lw_sw2 && !loc_access2)) ) || pipeline_regFD_nEN);


//declare the register FD_nEN_r so that the effect can last for another cycle. 
reg FD_nEN_r;
always@(posedge clk)begin
	FD_nEN_r <= FD_nEN;
end


wire nPC_EN; //controlled by StallF in hazard
always@(posedge clk)begin
   if(nPC_EN == 0) begin
     PC_r = jump_mux_out;	//PC takes in the value of the jump mux output
   end
end

//PC+8 adder
always@(posedge reset)begin		//when reset/at inital, we initialize the value of PC out so that the signals are defined
  PCplus8_out = 32'b0; 
end
always@(negedge clk)begin
  PCplus8_out = PC_out + 32'd8;		// Changed the PC+4 to PC+8 for dual processing. 
end


instr_memory instr_memory(	//declare instance of the instruction memory 
.address(PC_out),
.read_data(InstrF),
.read_data2(InstrF2)
);



//pipeline reg
Pipeline_RegFD pipeline_regFD(		//declare the instance of pipeline register at Fetech-Decode stage
  .CLK(clk),
  .RST(reset),
  .InstrF(InstrF),
  .InstrD(InstrD),
  .InstrF2(InstrF2),
  .InstrD2(InstrD2),
  .PCplus8F(PCplus8_out),
  .PCplus8D(PCplus8D),
  .nEN(FD_nEN),
  .CLR(FD_CLR),
  .PC_D(PC_D),
  .PC_F(PC_F),
  .predBranchAddrF(predBranchAddrF),
  .predBranchAddrD(predBranchAddrD),
  .branching_addressF(branching_addressF), //added for lab4 to have the PC for branching one
  .branching_addressD(branching_addressD)
);


/****Decode****Decode****Decode****Decode****Decode****Decode****Decode****Decode*****\ */    


//InstrD spliter
wire [5:0] InstrD5_0;		//splits the instruction in different section so that debug is easy 
wire [5:0] InstrD31_26;
wire [4:0] InstrD15_11;
wire [4:0] InstrD20_16;
wire [4:0] InstrD25_21;
assign InstrD5_0   = InstrD[5:0];
assign InstrD31_26 = InstrD[31:26];
assign InstrD15_11 = InstrD[15:11];
assign InstrD20_16 = InstrD[20:16];
assign InstrD25_21 = InstrD[25:21];

wire [5:0] InstrD5_02;		//splits the instruction in different section so that debug is easy 
wire [5:0] InstrD31_262;
wire [4:0] InstrD15_112;
wire [4:0] InstrD20_162;
wire [4:0] InstrD25_212;
assign InstrD5_02   = InstrD2[5:0];
assign InstrD31_262 = InstrD2[31:26];
assign InstrD15_112 = InstrD2[15:11];
assign InstrD20_162 = InstrD2[20:16];
assign InstrD25_212 = InstrD2[25:21];

wire [3:0] ALUControlD, ALUControlD2;
wire [1:0] Out_selectD, Out_selectD2;  
assign op_FuncD = {InstrD31_26,InstrD5_0};	//op_FuncD is a wire concatnate the Opcode and the Func field. With it the whole block can be deyermined for a specific instruction  
assign op_FuncD2 = {InstrD31_262,InstrD5_02};                                                                 
controller controller(
  .op(InstrD31_26),    .op2(InstrD31_262),    .Func(InstrD5_0),     .Func2(InstrD5_02    ),.Eq_ne(Eq_neD),	        .PC_source(),      
  .se_ze(se_ze),       .ALUSrcB(ALUSrcB),  
  .mult_sign(mult_signD),.MemRead(MemReadD),.MemRead2(MemReadD2), .RegWrite(RegWriteD),.RegWrite2(RegWriteD2), .MemtoReg(MemtoRegD), .MemtoReg2(MemtoRegD2),
  .MemWrite(MemWriteD), .ALU_op(ALUControlD), .ALUSrcA(ALUSrcD), .MemWrite2(MemWriteD2), .ALU_op2(ALUControlD2), .ALUSrcA2(ALUSrcD2),.start_mult(start_multD),       
  .RegDst(RegDstD), 
  .RegDst2(RegDstD2),
  .is_bneD(is_bneD),
  .is_beqD(is_beqD),               
  .Out_select(Out_selectD),
  .Out_select2(Out_selectD2),
  .dpred_accessD(dpred_accessD)   
);

//reg file
wire [31:0] write_dataD;
wire [31:0] RF_ReadData1;
wire [31:0] RF_ReadData2;
wire [4:0] WriteRegW;
wire [31:0] write_dataD2;
wire [31:0] RF_ReadData12;
wire [31:0] RF_ReadData22;
wire [4:0] WriteRegW2;
wire RegWriteW, RegWriteW2; // pipeline reg control signal 
wire mult_finishW; //pipeline reg signal passed from mult_finish at execution stage 
reg mult_status_record1,mult_status_record2;
wire mult_status;
assign RegWriteW_ctrl = (!mult_finishW && RegWriteW) || (!mult_finishW && RegWriteW2);
wire mult_finishM;
assign RFWriteEnable = 
	((!mult_finishM && RegWriteW) || (!mult_finishW && RegWriteW && op_FuncD!=18)) //RF is enable write when multiplier finish multiplication
	&& (mem_access_status == 1'b0);  //when memory is not caching
assign RFWriteEnable2 = 
	((!mult_finishM && RegWriteW2) || (!mult_finishW && RegWriteW2 && op_FuncD2!=18)) //RF is enable write when multiplier finish multiplication
	&& (mem_access_status == 1'b0);  //when memory is not caching
//(!mult_finishW && RegWriteW) for ORI or other i types
wire [4:0] WriteRegM;
wire [4:0] WriteRegM2;	
regfile regfile(
  .Clk(clk),
  .Reset(reset),
  .Write(RFWriteEnable),  //WriteEnable
  .Write2(RFWriteEnable2),
  .PR1(InstrD25_21),
  .PR2(InstrD20_16),
  .WR(WriteRegM), //WriteRegW [4:0]
  .WD(write_dataD),
  .RD1(RF_ReadData1), 
  .RD2(RF_ReadData2),
  .PR12(InstrD25_212),
  .PR22(InstrD20_162),
  .WR2(WriteRegM2), //WriteRegW [4:0]
  .WD2(write_dataD2),
  .RD12(RF_ReadData12), 
  .RD22(RF_ReadData22)
);

//Sign Extend
wire [15:0] ImmRaw;
assign ImmRaw = InstrD[15:0];
wire [31:0] SignImmD,SignImmE;
assign SignImmD = { {16{ImmRaw[15]}}, ImmRaw };

wire [15:0] ImmRaw2;
assign ImmRaw2 = InstrD2[15:0];
wire [31:0] SignImmD2,SignImmE2;
assign SignImmD2 = { {16{ImmRaw2[15]}}, ImmRaw2 };

//pipeline reg
wire [31:0] RF_ReadData1_E,RF_ReadData2_E;
wire [4:0] RtD, RdD, RsD; 
wire [4:0] RtE, RdE, RsE;
wire [3:0] ALUControlE;
wire [1:0] Out_selectE;
wire [31:0] RF_ReadData1_E2,RF_ReadData2_E2;
wire [4:0] RtD2, RdD2, RsD2; 
wire [4:0] RtE2, RdE2, RsE2;
wire [3:0] ALUControlE2;
wire [1:0] Out_selectE2;

//PC Branch Target Address 								//This needs to be updated and thought about for branching
wire [31:0] PCplus8E;


//calculate actual branch address 
assign calcBranchAddrE = isBranchTakenE ?  ((SignImmE << 2) + PCplus8E) : PCplus8E;



wire [31:0] ALUoutW;
wire [31:0] ALUoutE;
wire [31:0] ALUoutW2;
wire [31:0] ALUoutE2;

wire [1:0] ForwardAD,ForwardAD2;
wire ForwardBD; //connects to the hazard module
wire AdependB, BdependA;
wire [31:0] ALUoutM;	
//ForwardAD MUX 
assign RF_ReadData1_D = (ForwardAD==2'b01) ? ALUoutE : 
			((ForwardAD==2'b10) ? ALUoutE2 : RF_ReadData1);

//ForwardAD MUX2
wire ForwardBD2; //connects to the hazard module
wire [31:0] ALUoutM2;	
assign RF_ReadData1_D2 = (ForwardAD2==2'b01) ? ALUoutE2 : 
			((ForwardAD2==2'b10) ? ALUoutE :RF_ReadData12);



//ForwardBD MUX
assign RF_ReadData2_D = ForwardBD ? ALUoutW : RF_ReadData2;
assign RF_ReadData2_D2 = ForwardBD2 ? ALUoutW2 : RF_ReadData22;


//Branch MUX Control, deleted from  static branching functions
//assign branch_mux_ctrl = BranchD && (RF_ReadData1_D != RF_ReadData2_D ? 1'b1 : 1'b0);   //////Update this also for branching


//Pipeline Reg D-E

wire start_multE, StallE;
assign RsD = InstrD25_21;
assign RtD = InstrD20_16;
assign RdD = InstrD15_11;
assign RsD2 = InstrD25_212;
assign RtD2 = InstrD20_162;
assign RdD2 = InstrD15_112;
wire isLW_E;
assign isLW_E = (MemWriteE == 1'b1 || MemWriteE2 == 1'b1 )?1'b1:1'b0; //is load word at execution stage ===================================================
assign isRtype_D = (jump_mux_out[31:26] == 6'b000000)?1'b1:1'b0; 

assign isRtype_D2 = (jump_mux_out[31:26] == 6'b000000)?1'b1:1'b0; /////// This must also be updated for branching and jump hazard

wire [31:0] InstrE, InstrM, InstrW;
wire [31:0] InstrE2, InstrM2, InstrW2;
//wire nEN = !(StallE || (isLW_E && isRtype_D));
//.nEN(mem_access_status),
Pipeline_RegDE pipeline_regDE(
  .CLK(clk),.RST(reset), 
  .nEN(1'b0), //MemReadE starts one cycle earlier detecing cache access
  .InstrD(InstrD), .InstrE(InstrE),
  .InstrD2(InstrD2), .InstrE2(InstrE2),
  .mult_signD(mult_signD),.mult_signE(mult_signE),
  .MemReadD(MemReadD),    .MemReadE(MemReadE),
  .RegWriteD(RegWriteD),  .RegWriteE(RegWriteE),
  .MemtoRegD(MemtoRegD),  .MemtoRegE(MemtoRegE),
  .MemWriteD(MemWriteD),  .MemWriteE(MemWriteE),
  .ALUControlD(ALUControlD),.ALUControlE(ALUControlE),
  .ALUSrcD(ALUSrcD),   .ALUSrcE(ALUSrcE),
  .MemReadD2(MemReadD2),    .MemReadE2(MemReadE2),
  .RegWriteD2(RegWriteD2),  .RegWriteE2(RegWriteE2),
  .MemtoRegD2(MemtoRegD2),  .MemtoRegE2(MemtoRegE2),
  .MemWriteD2(MemWriteD2),  .MemWriteE2(MemWriteE2),
  .ALUControlD2(ALUControlD2),.ALUControlE2(ALUControlE2),
  .ALUSrcD2(ALUSrcD2),   .ALUSrcE2(ALUSrcE2),
  .start_multD(start_multD), .start_multE(start_multE),
  .RegDstD(RegDstD), .RegDstE(RegDstE),
  .Out_selectD(Out_selectD), .Out_selectE(Out_selectE), 
  .RF_ReadData1_D(RF_ReadData1_D),  .RF_ReadData1_E(RF_ReadData1_E),
  .RF_ReadData2_D(RF_ReadData2_D),  .RF_ReadData2_E(RF_ReadData2_E),
  .RsD(RsD), .RsE(RsE),
  .RtD(RtD), .RtE(RtE),
  .RdD(RdD), .RdE(RdE),
  .SignImmD(SignImmD), .SignImmE(SignImmE),
  .RegDstD2(RegDstD2), .RegDstE2(RegDstE2),
  .Out_selectD2(Out_selectD2), .Out_selectE2(Out_selectE2), 
  .RF_ReadData1_D2(RF_ReadData1_D2),  .RF_ReadData1_E2(RF_ReadData1_E2),
  .RF_ReadData2_D2(RF_ReadData2_D2),  .RF_ReadData2_E2(RF_ReadData2_E2),
  .RsD2(RsD2), .RsE2(RsE2),
  .RtD2(RtD2), .RtE2(RtE2),
  .RdD2(RdD2), .RdE2(RdE2),
  .SignImmD2(SignImmD2), .SignImmE2(SignImmE2),
  .PCplus8D(PCplus8D), .PCplus8E(PCplus8E),
  .CLR(DE_CLR),
  .PC_D(PC_D), .PC_E(PC_E),
  .isBranchTakenD(isBranchTakenD), .isBranchTakenE(isBranchTakenE),
  .calcBranchAddrD(calcBranchAddrD), .calcBranchAddrE(calcBranchAddrE),
  .predBranchAddrD(predBranchAddrD), .predBranchAddrE(predBranchAddrE),
  .branching_addressD(branching_addressD), .branching_addressE(branching_addressE),//added for lab4 to have the PC for branching 
  .is_bneD(is_bneD), .is_bneE(is_bneE),
  .is_beqD(is_beqD), .is_beqE(is_beqE),
  .stall(DE_stall), .stall2(DE_stall2)
);


assign DE_stall2 = (RtD != RsD2);
assign DE_stall = (RtD2 != RsD);
/***Execute****Execute***Execute***Execute***Execute***Execute***Execute***Execute****\  */   



/*
In execution stage calcBranchAddr
*/


//ALU Src Select
wire [31:0] ALU_in_1;
wire [31:0] ALU_in_2;
wire [31:0] ALU_in_12;
wire [31:0] ALU_in_22;
wire [31:0] ForwardBE_MUX_out;	
wire [31:0] ForwardBE_MUX_out2;							////////This needs to be adjusted for hazard forwarding
assign ALU_in_2 = ALUSrcE ? SignImmE : ForwardBE_MUX_out;
assign ALU_in_22 = ALUSrcE2 ? SignImmE2 : ForwardBE_MUX_out2;
//ALU
ALU ALU(
  .clk(clk),
  .In1(ALU_in_1),
  .In2(ALU_in_2), 
  .Func(ALUControlE), 
  .ALUout(ALUoutE)
);

ALU ALU2(
  .clk(clk),
  .In1(ALU_in_12),
  .In2(ALU_in_22), 
  .Func(ALUControlE2), 
  .ALUout(ALUoutE2)
);



//multiplier
wire [31:0] multi_in_a,multi_in_b;
assign multi_in_a = RF_ReadData1_E;
assign multi_in_b = RF_ReadData2_E;
wire [63:0] mult_resultE;
mult multiplier(
	.clk(clk),
	.mult_status(mult_status), 
        .start(start_multE), 
        .in_is_signed(1'b0),
	//.in_a(multi_in_a), 
        //.in_b(multi_in_b),
	.in_a(ALU_in_1), 
        .in_b(ForwardBE_MUX_out),
	.s(mult_resultE)
);



//WriteReg Select
reg [4:0] WriteRegE,WriteRegD;
reg [4:0] WriteRegE2,WriteRegD2;
always@(posedge clk)begin
  if(RegDstE == 1)
	WriteRegE <= RtE;
  else 
	WriteRegE <= RdE;
end

always@(posedge clk)begin
  if(RegDstD == 1)
	WriteRegD <= RtD;
  else 
	WriteRegD <= RdD;
end

always@(posedge clk)begin
  if(RegDstE2 == 1)
	WriteRegE2 <= RtE2;
  else 
	WriteRegE2 <= RdE2;
end

always@(posedge clk)begin
  if(RegDstD2 == 1)
	WriteRegD2 <= RtD2;
  else 
	WriteRegD2 <= RdD2;
end


wire[1:0] ForwardAE, ForwardBE;
//ForwardAE MUX
assign ALU_in_1 = ForwardAE[1] ?
         (ForwardAE[0]? RF_ReadData1_E:ALUoutM)
        :(ForwardAE[0]? write_dataD:RF_ReadData1_E); 

wire[1:0] ForwardAE2, ForwardBE2;
//ForwardAE MUX
assign ALU_in_12 = ForwardAE2[1] ?
         (ForwardAE2[0]? RF_ReadData1_E2:ALUoutM2)
        :(ForwardAE2[0]? write_dataD2:RF_ReadData1_E2);

/*
00: from register 
01: write_dataD forwards 
10: ALUoutM forwards
*/
//ForwardBE MUX
assign ForwardBE_MUX_out = ForwardBE[1] ?
         (ForwardBE[0]? RF_ReadData2_E:ALUoutM)
        :(ForwardBE[0]? write_dataD:RF_ReadData2_E); 

assign ForwardBE_MUX_out2 = ForwardBE2[1] ?
         (ForwardBE2[0]? RF_ReadData2_E2:ALUoutM2)
        :(ForwardBE2[0]? write_dataD2:RF_ReadData2_E2);


//Pipeline Reg
//.nEN(mem_access_status),
wire [1:0] Out_selectM;
wire [1:0] Out_selectM2;
wire [63:0] mult_resultM;	
Pipeline_RegEM pipeline_regEM(
  .CLK(clk), .RST(reset), .nEN(1'b0), .CLR(EM_CLR),
  .InstrE(InstrE),.InstrM(InstrM),
  .MemReadE(MemReadE), .MemReadM(MemReadM),
  .RegWriteE(RegWriteE),.RegWriteM(RegWriteM),
  .MemtoRegE(MemtoRegE),.MemtoRegM(MemtoRegM),
  .MemWiteE(MemWriteE), .MemWiteM(MemWriteM),

  .InstrE2(InstrE2),.InstrM2(InstrM2),
  .MemReadE2(MemReadE2), .MemReadM2(MemReadM2),
  .RegWriteE2(RegWriteE2),.RegWriteM2(RegWriteM2),
  .MemtoRegE2(MemtoRegE2),.MemtoRegM2(MemtoRegM2),
  .MemWiteE2(MemWriteE2), .MemWiteM2(MemWriteM2),

  .mult_finishE(mult_status), .mult_finishM(mult_finishM),
  .Out_selectE(Out_selectE), .Out_selectM(Out_selectM),
  .Out_selectE2(Out_selectE2), .Out_selectM2(Out_selectM2),
  .mult_resultE(mult_resultE),.mult_resultM(mult_resultM),
  .ALUoutE(ALUoutE),.ALUoutM(ALUoutM),
  .write_dataE(write_dataE),.write_dataM(write_dataM),
  .WriteRegE(WriteRegE),  .WriteRegM(WriteRegM),
  .ALUoutE2(ALUoutE2),.ALUoutM2(ALUoutM2),
  .write_dataE2(write_dataE2),.write_dataM2(write_dataM2),
  .WriteRegE2(WriteRegE2),  .WriteRegM2(WriteRegM2),
  .PC_E(PC_E), .PC_M(PC_M),
  .branching_addressE(branching_addressE), .branching_addressM(branching_addressM)//added for lab4 to have the PC for branching 

);

//forward addi result to SW
assign write_dataE = ((RtE == WriteRegE) && (RtE!= 0) && (RegWriteE == 0))? ALUoutM:ForwardBE_MUX_out;
/****Memory****Memory****Memory****Memory****Memory****Memory****Memory****Memory*****\     */

//data memory
wire [31:0] data_memory_in_addr;
assign data_memory_in_addr = ALUoutM;

wire [31:0] data_memory_in_addr2;
assign data_memory_in_addr2 = ALUoutM2;
 

//cache
//declare an instance
//the following signals are used to connect cache and the main memory
wire [4:0] count;
wire [31:0] mem_read_address, mem_write_address;
wire [127:0] mem_write_data, mem_input;
wire mem_write;				
	
wire [4:0] count2;
wire [31:0] mem_read_address2, mem_write_address2;
wire [127:0] mem_write_data2, mem_input2;
wire mem_write2;	

cache cache(
	.mem_input(mem_input), 
	.address(data_memory_in_addr),
	.mem_input2(mem_input2), 
	.address2(data_memory_in_addr2),
	.write_in(MemWriteM),
	.write_in2(MemWriteM2),
	.clk(clk), 
	.write_data_in(write_dataM), 
	.write_data_in2(write_dataM2),
	.countR(count),
	.read_in(MemReadM),
	.read_in2(MemReadM2),  
	.mem_read_address(mem_read_address), 
	.mem_write_address(mem_write_address),  
	.mem_write_data(mem_write_data), 
	.mem_read_address2(mem_read_address2), 
	.mem_write_address2(mem_write_address2),  
	.mem_write_data2(mem_write_data2),
	.mem_access_status(mem_access_status), 
	.mem_write(mem_write),
	.read_data(read_dataM),
	.mem_write2(mem_write2),
	.read_data2(read_dataM2),
	.loc_access(loc_access)
);


data_memory data_memory(
	.clk(clk), 
	.write(mem_write), 
	.read_address(mem_read_address), 
	.write2(mem_write2), 
	.read_address2(mem_read_address2), 
	.count(count), 
	.write_address(mem_write_address), 
	.write_data(mem_write_data), 
	.read_data(mem_input),
	.write_address2(mem_write_address2), 
	.write_data2(mem_write_data2), 
	.read_data2(mem_input2)
);
                                                               
/*
the original data memory is deleted                                                      
data_memory data_memory(
  .clk(clk), 
  .write_enable(MemWriteM),
  .read_enable(MemReadM), 
  .address(data_memory_in_addr), 
  .write_data(write_dataM), 
  .read_data(read_dataM)
) ;
*/


//lui extend
wire[31:0] lui_extendedM;
assign lui_extendedM = {ALUoutM<<16, 16'b0};

wire[31:0] lui_extendedM2;
assign lui_extendedM2 = {ALUoutM2<<16, 16'b0};

//pipeline reg
wire [1:0] Out_selectW;
wire [63:0] mult_resultW;
wire [31:0] read_dataW;
wire [31:0] lui_extendedW;

wire [1:0] Out_selectW2;
wire [63:0] mult_resultW2;
wire [31:0] read_dataW2;
wire [31:0] lui_extendedW2 ;


//.nEN(mem_access_status),
Pipeline_RegMW pipeline_regMW(
  .CLK(clk), .RST(reset),.nEN(1'b0), .CLR(MW_CLR),
  .InstrM(InstrM),.InstrW(InstrW),
  .InstrM2(InstrM2),.InstrW2(InstrW2),
  .RegWriteM(RegWriteM),  .RegWriteW(RegWriteW),
  .MemtoRegM(MemtoRegM),  .MemtoRegW(MemtoRegW),
  .RegWriteM2(RegWriteM2),  .RegWriteW2(RegWriteW2),
  .MemtoRegM2(MemtoRegM2),  .MemtoRegW2(MemtoRegW2),
  .mult_finishM(mult_finishM), .mult_finishW(mult_finishW),
  .Out_SelectM(Out_selectM),  .Out_SelectW(Out_selectW), 
  .ALUoutM(ALUoutM),  .ALUoutW(ALUoutW),
  .Out_SelectM2(Out_selectM2),  .Out_SelectW2(Out_selectW2), 
  .ALUoutM2(ALUoutM2),  .ALUoutW2(ALUoutW2),
  .mult_resultM(mult_resultM),  .mult_resultW(mult_resultW),
  .ReadDataM(read_dataM),  .ReadDataW(read_dataW),
  .lui_extendedM(lui_extendedM),  .lui_extendedW(lui_extendedW),
  .WriteRegM(WriteRegM),  .WriteRegW(WriteRegW),
  .ReadDataM2(read_dataM2),  .ReadDataW2(read_dataW2),
  .lui_extendedM2(lui_extendedM2),  .lui_extendedW2(lui_extendedW2),
  .WriteRegM2(WriteRegM2),  .WriteRegW2(WriteRegW2)
);


/*****Write*****Write*****Write*****Write*****Write*****Write*****Write*****Write*****\     
/*****/                                                                         /*****/
/**/                                                                            /**/
//mult_result[63:0] path
reg  [31:0] hi, lo;
wire [31:0] mult_resultH,mult_resultL;
assign mult_resultH = hi;
assign mult_resultL = lo;

//assigns the output multiplier rereult
always@(mult_finishM)begin    //because hi/lo register takes an extra cycle, we load then when data available to memory stage
  hi = mult_resultW[63:32];
  lo = mult_resultW[31:0];
end

//MemtoReg MUX
wire [31:0] MemtoReg_out, MemtoReg_out2;
assign MemtoReg_out = MemtoRegW ? (loc_access ? read_dataM : read_dataW):ALUoutW;
assign MemtoReg_out2 = MemtoRegW2 ? (loc_access ? read_dataM2 : read_dataW2):ALUoutW2;


//Out_select MUX
always @(posedge clk)begin
    
end

assign write_dataD = Out_selectW[1] ?
                   (Out_selectW[0]? lui_extendedW : mult_resultL):
                   (Out_selectW[0]? mult_resultH  : MemtoReg_out );
assign write_dataD2 = Out_selectW2[1] ?
                   (Out_selectW2[0]? lui_extendedW2 : mult_resultL):
                   (Out_selectW2[0]? mult_resultH  : MemtoReg_out2 );

/********************************************************************************************************
********************************************************************************************************
********************************************************************************************************
********************************************************************************************************
********************************************************************************************************
********************************************************************************************************
HAZARD EXTRACTED HAZARD EXTRACTEDHAZARD EXTRACTEDHAZARD EXTRACTEDHAZARD EXTRACTEDHAZARD EXTRACTEDHAZARD EXTRACTED
********************************************************************************************************
********************************************************************************************************
********************************************************************************************************
********************************************************************************************************
********************************************************************************************************/

//declares the hazard instance
/*
hazard hazard(
	.WriteRegM(WriteRegM), .WriteRegE(WriteRegE), .WriteRegW(WriteRegW), .rsE(RsE), .rtE(RtE), .rsD(RsD), .rtD(RtD), .opcode(InstrD31_26), .MultFinish(mult_status),
	.MemtoRegM(MemtoRegM), .MemtoRegE(MemtoRegE), .RegWriteW(RegWriteW), .RegWriteM(RegWriteM), .RegWriteE(RegWriteE), .BranchD(BranchD),
	.StallF(StallF), .StallD(pipeline_regFD_nEN), .StallE(StallE), .ForwardAD(ForwardAD), .ForwardBD(ForwardBD), .FlushE(pipeline_regDE_CLR),
	.ForwardAE(ForwardAE), .ForwardBE(ForwardBE), .FD_nEN(FD_nEN) ,. start_multD(start_multD)
);
*/
//hazard block is extracted to portion of code below

wire [5:0] opcode;
assign opcode = InstrD31_26;
wire [5:0] opcode2;
assign opcode2 = InstrD31_262;
assign MultFinish = mult_status;
reg StallF_r, StallE_r;
assign StallF = StallF_r;
assign StallE = StallE_r;
reg lwstall, branchstall, jumpstall, branchstallD;
reg pipeline_regFD_nEN_r;
reg pipeline_regDE_CLR_r;

reg ForwardAD_r,ForwardBD_r;

reg ForwardAD_r2,ForwardBD_r2;
assign pipeline_regFD_nEN = pipeline_regFD_nEN_r;
assign pipeline_regDE_CLR = pipeline_regDE_CLR_r;

reg [1:0] ForwardAE_r,ForwardBE_r;
assign ForwardAE = ForwardAE_r;
assign ForwardBE = ForwardBE_r;


reg [1:0] ForwardAE_r2,ForwardBE_r2;
assign ForwardAE2 = ForwardAE_r2;
assign ForwardBE2 = ForwardBE_r2;

initial begin
  StallF_r <= 1'b0;	//intialize stall at F/D so that the first instruction passes through FD pipeline register
  StallE_r <= 1'b0;  
  pipeline_regFD_nEN_r <= 1'b0;
  lwstall <= 1'b0; 
  branchstall <= 1'b0;
  jumpstall<= 1'b0; 
  branchstallD <= 1'b0;
end

always @(*) begin
	//for signal ready at memory stage, forwards to execute
	if((RsE != 0) && (RsE == WriteRegM) && RegWriteM) begin
		ForwardAE_r = 01;
	end	
	//for signal ready at write stage, forwards to execute	
	else if((RsE != 0) && (RsE == WriteRegW) && RegWriteW) begin
		ForwardAE_r = 10;
	end
	else ForwardAE_r = 0; 
	if(   (RtE != 0) && (RtE == WriteRegM) && RegWriteM ) begin
		ForwardBE_r = 01;
	end
	//second one forward from I-type to I-type, 
	else if(((RtE != 0) && (RtE == WriteRegW) && RegWriteW) 
		|| ((RtE != 0) && (RtE == WriteRegE) && RegWriteW)) begin
		ForwardBE_r = 10;
	end 
	else ForwardBE_r = 0; 
	
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
	StallF_r = jumpstall || MultFinish;	//the lw_stall is deleted to be implemented in the data_path
	//pipeline_regFD_nEN_r = lwstall || branchstall || MultFinish; //is also StallD
        pipeline_regFD_nEN_r = lwstall || MultFinish; //is also StallD
	pipeline_regDE_CLR_r = lwstall || branchstall; //is also FlushE
	StallE_r = MultFinish;
end

always @(*) begin
	//for signal ready at memory stage, forwards to execute
	if((RsE2 != 0) && (RsE2 == WriteRegM2) && RegWriteM2) begin
		ForwardAE_r2 = 01;
	end	
	//for signal ready at write stage, forwards to execute	
	else if((RsE2 != 0) && (RsE2 == WriteRegW2) && RegWriteW2) begin
		ForwardAE_r2 = 10;
	end
	else ForwardAE_r2 = 0; 
	if(   (RtE2 != 0) && (RtE2 == WriteRegM2) && RegWriteM2 ) begin
		ForwardBE_r2 = 01;
	end
	//second one forward from I-type to I-type, 
	else if(((RtE2 != 0) && (RtE2 == WriteRegW2) && RegWriteW2) 
		|| ((RtE2 != 0) && (RtE2 == WriteRegE2) && RegWriteW2)) begin
		ForwardBE_r2 = 10;
	end 
	else ForwardBE_r2 = 0; 
	
	//for data ready at memory stage, forwards to decode stage
	//ForwardAD_r2 = (RsD2 != 0) && (RsD2 == WriteRegM2) && RegWriteM2;
	//ForwardBD_r2 = (RtD2 != 0) && (RtD2 == WriteRegM2) && (RegWriteM2 || start_multD); //extracted outside of the always block
	
	//stalls when branch happens
	//branchstall = (BranchD && RegWriteE && (WriteRegE == RsD || WriteRegE == RtD)) || (BranchD && MemtoRegM && (WriteRegM == RsD || WriteRegM == RtD));
        //lwstall = ((rsD == rtE) || (rtD == rtE)) && MemtoRegE;
	if(opcode2 == 6'b100011&& FD_nEN == 1'b1) begin
		lwstall2 = 1'b1;
	end
	else begin
		lwstall2 = 1'b0;
	end

	if(opcode2 == 6'b000010) begin
		jumpstall = 1'b1;
	end
	else begin
		jumpstall = 1'b0;
	end
	//gradient stall
	StallF_r = jumpstall || MultFinish;	//the lw_stall is deleted to be implemented in the data_path
	//pipeline_regFD_nEN_r = lwstall || branchstall || MultFinish; //is also StallD
        pipeline_regFD_nEN_r = lwstall || MultFinish; //is also StallD
	pipeline_regDE_CLR_r = lwstall || branchstall; //is also FlushE
	StallE_r = MultFinish;
end
	
	//outside of always
	assign ForwardAD = (
		(RsD != 0) && ( ((RsD == WriteRegM) && RegWriteM && (RsD != RtD))   || ((RsD == WriteRegE) && RegWriteE) || (RsD == RtE))
		) ? 2'b01 : 
		(
		(RsD == RtE) ? 2'b10 : 2'b00
		);
	assign ForwardBD = (RtD != 0) && ( ((RtD == WriteRegE) && (RegWriteM || start_multD))  );
	assign ForwardAD2 = (
		(RsD2 != 0) && ( ((RsD2 == WriteRegM2) && RegWriteM2 && (RsD2 != RtD2))   || ((RsD2 == WriteRegE2) && RegWriteE2) || (RsD == RtE))
		) ? 2'b01 : 
		(
		(RsD2 == RtE) ? 2'b10 : 2'b00
		); 
	assign ForwardBD2 = (RtD2 != 0) && ( ((RtD2 == WriteRegE2) && (RegWriteM2 || start_multD))  );

/********************************************************************************************************
********************************************************************************************************
********************************************************************************************************
********************************************************************************************************
********************************************************************************************************
********************************************************************************************************
HAZARD EXTRACTED HAZARD EXTRACTEDHAZARD EXTRACTEDHAZARD EXTRACTEDHAZARD EXTRACTEDHAZARD EXTRACTEDHAZARD EXTRACTED
********************************************************************************************************
********************************************************************************************************
********************************************************************************************************
********************************************************************************************************
********************************************************************************************************/




//nPC_EN is used to stall the PC counter value. Note that when the FD_nEN is disabled, the PC will stop two on the next cycle because of is_lw_sw
assign nPC_EN = reset ? 1'b0 : (StallF || mult_status || start_multD || start_multE || (FD_nEN && is_lw_sw));



endmodule