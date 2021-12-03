//Fetch - Decode
/*
InstrFD [31:0]
PCplus8FD [31:0]
*/
module Pipeline_RegFD(
  input CLK,RST,
  input [31:0] InstrF,
  output [31:0] InstrD,
  input [31:0] InstrF2,
  output [31:0] InstrD2,
  input [31:0] PC_F,
  output [31:0] PC_D,
  input [31:0] branching_addressF,	//added for lab4 
  output [31:0] branching_addressD,	//added for lab4
  input [31:0] PCplus8F,
  output [31:0] PCplus8D,
  input nEN,
  input CLR,
  input [31:0] predBranchAddrF,
  input [31:0] predBranchAddrD
);
  reg [31:0] InstrFD, InstrFD2;
  reg [31:0] PCplus8FD;
  reg [31:0] PC_FD;
  reg [31:0] predBranchAddrFD;
  reg [31:0] branching_addressFD;
always@(posedge RST)begin
  InstrFD <= 32'b0;
  InstrFD2 <= 32'b0;
end

always@(posedge CLK) begin
	if(nEN==1'b0)begin
   		InstrFD <= InstrF;
		InstrFD2 <= InstrF2;
   		PCplus8FD <= PCplus8F;
   		PC_FD <= PC_F;	//used to pipeline PC to the executaion stage 
                predBranchAddrFD <= predBranchAddrF;
		branching_addressFD <= branching_addressF;
   	end
	if(CLR) begin
		InstrFD <= 0;
		InstrFD2 <= 0;
   		PCplus8FD <= 0;
   		PC_FD <= 0;
	end
end

assign InstrD = InstrFD;
assign InstrD2 = InstrFD2;
assign PCplus8D = PCplus8FD;
assign PC_D = PC_FD;
assign predBranchAddrD = predBranchAddrFD;
assign branching_addressD = branching_addressFD;
endmodule



//Decode - Execute
/*
mult_signDE
MemReadDE
RegWriteDE
MemtoRegDE
MemWriteDE
ALUControlDE [3:0] 
ALUSrcDE
start_multDE
RegDstDE
BranchDE
Out_selectDE [1:0]
RF_ReadData1_DE [31:0]
RF_ReadData2_DE [31:0]
RsDE     (25:21)
RtDE     (20:16)
RdDE     (15:11)
SignImmDE      [31:0]
PCplus8FD [31:0]
CLR
*/
module Pipeline_RegDE(
  input CLK,
  input RST,
  input nEN,
  input [31:0] PC_D,
  output [31:0] PC_E,
  input [31:0] InstrD,
  output [31:0] InstrE,
  input [31:0] InstrD2,
  output [31:0] InstrE2,
  input mult_signD,
  output mult_signE,
  input MemReadD,
  output MemReadE,
  input RegWriteD,
  output RegWriteE,
  input MemtoRegD,
  output MemtoRegE,
  input MemWriteD,
  output MemWriteE,
  input [3:0] ALUControlD,
  output [3:0] ALUControlE,
  input ALUSrcD,
  output ALUSrcE,
  input MemReadD2,
  output MemReadE2,
  input RegWriteD2,
  output RegWriteE2,
  input MemtoRegD2,
  output MemtoRegE2,
  input MemWriteD2,
  output MemWriteE2,
  input [3:0] ALUControlD2,
  output [3:0] ALUControlE2,
  input ALUSrcD2,
  output ALUSrcE2,
  input start_multD,
  output start_multE,
  input RegDstD,
  output RegDstE,
  input RegDstD2,
  output RegDstE2,
  input isBranchTakenD,
  output isBranchTakenE,
  input is_bneD,
  output is_bneE,
  input is_beqD,
  output is_beqE,
  input [1:0] Out_selectD, 
  output [1:0] Out_selectE, 
  input [31:0] RF_ReadData1_D,
  output [31:0] RF_ReadData1_E,
  input [31:0] RF_ReadData2_D,
  output [31:0] RF_ReadData2_E,
  input [4:0] RsD,
  output [4:0] RsE,
  input [4:0] RtD,
  output [4:0] RtE,
  input [4:0] RdD,
  output [4:0] RdE,
  input [31:0] SignImmD,
  output [31:0] SignImmE,
  input [1:0] Out_selectD2, 
  output [1:0] Out_selectE2, 
  input [31:0] RF_ReadData1_D2,
  output [31:0] RF_ReadData1_E2,
  input [31:0] RF_ReadData2_D2,
  output [31:0] RF_ReadData2_E2,
  input [4:0] RsD2,
  output [4:0] RsE2,
  input [4:0] RtD2,
  output [4:0] RtE2,
  input [4:0] RdD2,
  output [4:0] RdE2,
  input [31:0] SignImmD2,
  output [31:0] SignImmE2,
  input [31:0] calcBranchAddrD, //pass on the branch address to execute stage for branch target cache
  output [31:0] calcBranchAddrE,
  input [31:0] PCplus8D,
  output [31:0] PCplus8E,
  input  mfhiD,
  output mfhiE,
  input CLR,
  input [31:0] predBranchAddrD,
  output [31:0] predBranchAddrE,
  input [31:0] branching_addressD,	//added for lab4 
  output [31:0] branching_addressE,	//added for lab4 
  input stall,
  input stall2
);
  reg [31:0] instrDE;
  reg mult_signDE;
  reg MemReadDE;
  reg RegWriteDE;
  reg MemtoRegDE;
  reg MemWriteDE;
  reg [3:0] ALUControlDE;  
  reg ALUSrcDE;
  reg start_multDE;
  reg RegDstDE;
  reg [1:0] Out_selectDE; 
  reg [31:0] RF_ReadData1_DE; 
  reg [31:0] RF_ReadData2_DE; 
  reg [4:0] RsDE;     
  reg [4:0] RtDE;     
  reg [4:0] RdDE;     
  reg [31:0] SignImmDE;    
  reg [31:0] instrDE2;
  reg mult_signDE2;
  reg MemReadDE2;
  reg RegWriteDE2;
  reg MemtoRegDE2;
  reg MemWriteDE2;
  reg [3:0] ALUControlDE2;  
  reg ALUSrcDE2;
  reg start_multDE2;
  reg RegDstDE2;
  reg [1:0] Out_selectDE2; 
  reg [31:0] RF_ReadData1_DE2; 
  reg [31:0] RF_ReadData2_DE2; 
  reg [4:0] RsDE2;     
  reg [4:0] RtDE2;     
  reg [4:0] RdDE2;     
  reg [31:0] SignImmDE2;        
  reg [31:0] PCplus8DE; 
  reg [31:0] PC_DE; //used to store PC from fetch stage to access the branch cache
  reg [31:0] calcBranchAddrDE;
  reg isBranchTakenDE;
  reg [31:0] predBranchAddrDE;
  reg [31:0] branching_addressDE;
  reg is_bneDE;
  reg is_beqDE;

always@(negedge RST)begin
   RegWriteDE <= 1'b0;
   MemtoRegDE <= 1'b0;
   RsDE <= 5'b0;
   RtDE <= 5'b0;
   RdDE <= 5'b0;
   RegWriteDE2 <= 1'b0;
   MemtoRegDE2 <= 1'b0;
   RsDE2 <= 5'b0;
   RtDE2 <= 5'b0;
   RdDE2 <= 5'b0;
   is_bneDE <= 0;
   is_beqDE <= 0;
end


always@(posedge CLK) begin

  if(CLR)begin
	mult_signDE <= 0;
  	MemReadDE <= 0;
  	RegWriteDE <= 0;
  	MemtoRegDE <= 0;
  	MemWriteDE <= 0;
  	ALUControlDE <= 0;
  	ALUSrcDE <= 0;
  	start_multDE <= 0;
  	RegDstDE <= 0;
  	Out_selectDE <= 0;
 	RF_ReadData1_DE <= 0;
  	RF_ReadData2_DE <= 0;
  	RsDE <= 0;   
  	RtDE <= 0;   
  	RdDE <= 0;    
  	SignImmDE <= 0;     
  	PCplus8DE <= 0;
  	instrDE <= 0;
	mult_signDE2 <= 0;
  	MemReadDE2 <= 0;
  	RegWriteDE2 <= 0;
  	MemtoRegDE2 <= 0;
  	MemWriteDE2 <= 0;
  	ALUControlDE2 <= 0;
  	ALUSrcDE2 <= 0;
  	start_multDE2 <= 0;
  	RegDstDE2 <= 0;
  	Out_selectDE2 <= 0;
 	RF_ReadData1_DE2 <= 0;
  	RF_ReadData2_DE2 <= 0;
  	RsDE2 <= 0;   
  	RtDE2 <= 0;   
  	RdDE2 <= 0;    
  	SignImmDE2 <= 0;     
  	instrDE2 <= 0;
  	PC_DE <= 0;
  	calcBranchAddrDE <= 0;
        predBranchAddrDE <= 0;
        branching_addressDE <= 0;
	is_bneDE <= 0;
   	is_beqDE <= 0;
  end
  else begin
	if(stall != 0)begin
    mult_signDE <= mult_signD;
    MemReadDE <= MemReadD;
    RegWriteDE <= RegWriteD;
    MemtoRegDE <= MemtoRegD;
    MemWriteDE <= MemWriteD;
    ALUControlDE <= ALUControlD;
    ALUSrcDE <= ALUSrcD;
    start_multDE <= start_multD;
    RegDstDE <= RegDstD;
    Out_selectDE <= Out_selectD;
    RF_ReadData1_DE <= RF_ReadData1_D;
    RF_ReadData2_DE <= RF_ReadData2_D;
    RsDE <= RsD;   
    RtDE <= RtD;   
    RdDE <= RdD;    
    SignImmDE <= SignImmD;     
    PCplus8DE <= PCplus8D;
    instrDE <= InstrD;
	end

	if(stall2 != 0)begin
    MemReadDE2 <= MemReadD2;
    RegWriteDE2 <= RegWriteD2;
    MemtoRegDE2 <= MemtoRegD2;
    MemWriteDE2 <= MemWriteD2;
    ALUControlDE2 <= ALUControlD2;
    ALUSrcDE2 <= ALUSrcD2;
    RegDstDE2 <= RegDstD2;
    Out_selectDE2 <= Out_selectD2;
    RF_ReadData1_DE2 <= RF_ReadData1_D2;
    RF_ReadData2_DE2 <= RF_ReadData2_D2;
    RsDE2 <= RsD2;   
    RtDE2 <= RtD2;   
    RdDE2 <= RdD2;    
    SignImmDE2 <= SignImmD2;     
    instrDE2 <= InstrD2;
	end


    PC_DE <= PC_D;
    calcBranchAddrDE <= calcBranchAddrD;
    isBranchTakenDE <= isBranchTakenD;
    predBranchAddrDE <= predBranchAddrD;
    branching_addressDE <= branching_addressD;
    is_bneDE <= is_bneD;
    is_beqDE <= is_beqD;
  end
end

  assign InstrE = instrDE;
  assign mult_signE = mult_signDE;
  assign MemReadE = MemReadDE;
  assign RegWriteE = RegWriteDE;
  assign MemtoRegE = MemtoRegDE;
  assign MemWriteE = MemWriteDE;
  assign ALUControlE = ALUControlDE;
  assign ALUSrcE = ALUSrcDE;
  assign start_multE = start_multDE;
  assign RegDstE = RegDstDE;
  assign Out_selectE = Out_selectDE;
  assign RF_ReadData1_E = RF_ReadData1_DE;
  assign RF_ReadData2_E = RF_ReadData2_DE;
  assign RsE = RsDE;   
  assign RtE = RtDE;   
  assign RdE = RdDE;    
  assign SignImmE = SignImmDE;

  assign InstrE2 = instrDE2;
  assign mult_signE2 = mult_signDE2;
  assign MemReadE2 = MemReadDE2;
  assign RegWriteE2 = RegWriteDE2;
  assign MemtoRegE2 = MemtoRegDE2;
  assign MemWriteE2 = MemWriteDE2;
  assign ALUControlE2 = ALUControlDE2;
  assign ALUSrcE2 = ALUSrcDE2;
  assign start_multE2 = start_multDE2;
  assign RegDstE2 = RegDstDE2;
  assign Out_selectE2 = Out_selectDE2;
  assign RF_ReadData1_E2 = RF_ReadData1_DE2;
  assign RF_ReadData2_E2 = RF_ReadData2_DE2;
  assign RsE2 = RsDE2;   
  assign RtE2 = RtDE2;   
  assign RdE2 = RdDE2;    
  assign SignImmE2 = SignImmDE2;  
     
  assign PCplus8E = PCplus8DE;
  assign PC_E = PC_DE;
  assign calcBranchAddrE = calcBranchAddrDE;
  assign isBranchTakenE = isBranchTakenDE;
  assign predBranchAddrE = predBranchAddrDE;
  assign branching_addressE = branching_addressDE;
  assign is_bneE = is_bneDE;
  assign is_beqE = is_beqDE;
endmodule


//Execute - Memory
/*
MemReadEM
RegWriteEM
MemtoRegEM
MemWiteEM
BranchEM 
[1:0] Out_selectEM
[63:0] mult_resultEM
[31:0] ALUoutEM
[31:0] write_dataEM
[4:0] WriteReg
[31:0] PCplus8DE 
*/
module Pipeline_RegEM(
  input CLK,
  input RST,
  input nEN,
  input CLR,
  input [31:0] InstrE,
  output [31:0] InstrM,
  input [31:0] InstrE2,
  output [31:0] InstrM2,
  input  MemReadE,
  output MemReadM,
  input  RegWriteE,
  output RegWriteM,
  input  MemtoRegE,
  output MemtoRegM,
  input  MemWiteE,
  output MemWiteM,
  input  MemReadE2,
  output MemReadM2,
  input  RegWriteE2,
  output RegWriteM2,
  input  MemtoRegE2,
  output MemtoRegM2,
  input  MemWiteE2,
  output MemWiteM2,
  input  mult_finishE,
  output mult_finishM,
  input  [1:0] Out_selectE,
  output [1:0] Out_selectM,
  input  [63:0] mult_resultE,
  output [63:0] mult_resultM,
  input  [31:0] ALUoutE,
  output [31:0] ALUoutM,
  input  [31:0] write_dataE,
  output [31:0] write_dataM,
  input  [4:0] WriteRegE,
  output [4:0] WriteRegM,
  input  [1:0] Out_selectE2,
  output [1:0] Out_selectM2,
  input  [63:0] mult_resultE2,
  output [63:0] mult_resultM2,
  input  [31:0] ALUoutE2,
  output [31:0] ALUoutM2,
  input  [31:0] write_dataE2,
  output [31:0] write_dataM2,
  input  [4:0] WriteRegE2,
  output [4:0] WriteRegM2,
  input [31:0] PC_E,
  output [31:0] PC_M,
  input [31:0] branching_addressE,  //added for lab4
  output [31:0] branching_addressM  //added for lab4
);
  reg MemReadEM;
  reg RegWriteEM;
  reg MemtoRegEM;
  reg MemWiteEM;
  reg MemReadEM2;
  reg RegWriteEM2;
  reg MemtoRegEM2;
  reg MemWiteEM2;

  reg mult_finishEM;

  reg [1:0] Out_selectEM;
  reg [63:0] mult_resultEM;
  reg [31:0] ALUoutEM;
  reg [31:0] write_dataEM;
  reg [4:0] WriteRegEM;
  reg [31:0] instrEM;

  reg [1:0] Out_selectEM2;
  reg [63:0] mult_resultEM2;
  reg [31:0] ALUoutEM2;
  reg [31:0] write_dataEM2;
  reg [4:0] WriteRegEM2;
  reg [31:0] instrEM2;
	
  reg [31:0] PC_EM;
  reg [31:0] branching_addressEM;

always@(negedge RST)begin
   RegWriteEM <= 1'b0;
   WriteRegEM <= 5'b0;
   MemtoRegEM <= 1'b0;
   RegWriteEM2 <= 1'b0;
   WriteRegEM2 <= 5'b0;
   MemtoRegEM2 <= 1'b0;
   PC_EM <= 2'b0;
end


always @(posedge CLK)begin
  if(CLR)begin
    MemReadEM  <= 0;
    RegWriteEM <= 0;
    MemtoRegEM <= 0;
    MemWiteEM  <= 0;
    Out_selectEM  <= 0;

    MemReadEM2  <= 0;
    RegWriteEM2 <= 0;
    MemtoRegEM2 <= 0;
    MemWiteEM2  <= 0;
    Out_selectEM2  <= 0;

    mult_resultEM <= 0;

    ALUoutEM      <= 0;
    write_dataEM  <= 0;
    //WriteRegEM    <= 0;
	WriteRegEM    <= WriteRegE;
    mult_finishEM <= 0;
    instrEM <= 0;

    ALUoutEM2      <= 0;
    write_dataEM2  <= 0;
    //WriteRegEM2    <= 0;
	WriteRegEM2    <= WriteRegE2;
    instrEM2 <= 0;

    PC_EM <= 0;
    branching_addressEM <= 0;
  end
  else begin
    if(nEN == 1'b0)begin
    MemReadEM  <= MemReadE;
    RegWriteEM <= RegWriteE;
    MemtoRegEM <= MemtoRegE;
    MemWiteEM  <= MemWiteE;
    Out_selectEM  <= Out_selectE;
    mult_resultEM <= mult_resultE;
    ALUoutEM      <= ALUoutE;
   
    WriteRegEM    <= WriteRegE;
    mult_finishEM <= mult_finishE;
    instrEM <= InstrE;

    MemReadEM2  <= MemReadE2;
    RegWriteEM2 <= RegWriteE2;
    MemtoRegEM2 <= MemtoRegE2;
    MemWiteEM2  <= MemWiteE2;
    Out_selectEM2  <= Out_selectE2;
    ALUoutEM2      <= ALUoutE2;
    write_dataEM2  <= write_dataE2;
    
	WriteRegEM2    <= WriteRegE2;
    instrEM2 <= InstrE2;
    PC_EM <= PC_E;
    branching_addressEM <= branching_addressE;
    end
  end
end

  assign MemReadM  = MemReadEM;  
  assign RegWriteM = RegWriteEM; 
  assign MemtoRegM = MemtoRegEM; 
  assign MemWiteM  = MemWiteEM;  
  assign Out_selectM  =  Out_selectEM; 
  assign mult_resultM =  mult_resultEM;
  assign ALUoutM      =  ALUoutEM;     
  assign write_dataM  =  write_dataEM; 
  assign WriteRegM    =  WriteRegEM;  
  assign mult_finishM = mult_finishEM;
  assign InstrM = instrEM;

  assign MemReadM2  = MemReadEM2;  
  assign RegWriteM2 = RegWriteEM2; 
  assign MemtoRegM2 = MemtoRegEM2; 
  assign MemWiteM2  = MemWiteEM2;  
  assign Out_selectM2  =  Out_selectEM2; 
  assign ALUoutM2      =  ALUoutEM2;     
  assign write_dataM2  =  write_dataEM2; 
  assign WriteRegM2    =  WriteRegEM2;  
  assign InstrM2 = instrEM2;
	
  assign PC_M = PC_EM;
  assign branching_addressM = branching_addressEM;
endmodule


//Memory - Write
/*
RegWriteMW
MemtoRegMW
[1:0] Out_SelectMW
[31:0] ALUoutMW
[63:0] mult_resultMW
[31:0] ReadDataMW
lui_extendedMW
[4:0]WriteRegMW
*/
module Pipeline_RegMW(
 input CLK,
 input RST,  
 input nEN,
 input CLR,
 input [31:0] InstrM,
 output [31:0] InstrW,
 input  RegWriteM,
 output RegWriteW,
 input  MemtoRegM,
 output MemtoRegW,
 input [31:0] InstrM2,
 output [31:0] InstrW2,
 input  RegWriteM2,
 output RegWriteW2,
 input  MemtoRegM2,
 output MemtoRegW2,
 input mult_finishM,
 output mult_finishW,
 input  [1:0] Out_SelectM,
 output [1:0] Out_SelectW, 
 input  [31:0] ALUoutM,
 output [31:0] ALUoutW,
 input  [1:0] Out_SelectM2,
 output [1:0] Out_SelectW2, 
 input  [31:0] ALUoutM2,
 output [31:0] ALUoutW2,
 input  [63:0] mult_resultM,
 output [63:0] mult_resultW,
 input  [31:0] ReadDataM,
 output [31:0] ReadDataW,
 input  lui_extendedM,
 output lui_extendedW,
 input  [4:0]WriteRegM,
 output [4:0]WriteRegW,
 input  [31:0] ReadDataM2,
 output [31:0] ReadDataW2,
 input  lui_extendedM2,
 output lui_extendedW2,
 input  [4:0]WriteRegM2,
 output [4:0]WriteRegW2
);

  reg RegWriteMW;
  reg MemtoRegMW;
  reg mult_finishMW;
  reg [1:0] Out_SelectMW;
  reg [31:0] ALUoutMW;
  reg [63:0] mult_resultMW;
  reg [31:0] ReadDataMW;
  reg lui_extendedMW;
  reg [4:0]WriteRegMW;
  reg mfhiMW;
  reg mfloMW;
  reg [31:0] instrMW;

  reg RegWriteMW2;
  reg MemtoRegMW2;
  reg [1:0] Out_SelectMW2;
  reg [31:0] ALUoutMW2;
  reg [31:0] ReadDataMW2;
  reg lui_extendedMW2;
  reg [4:0]WriteRegMW2;
  reg [31:0] instrMW2;
always @(posedge CLK)begin
  /*if(CLR)begin
    RegWriteMW   <= 0;
    MemtoRegMW   <= 0;
    Out_SelectMW <= 0;
    ALUoutMW      <= 0;
    mult_resultMW <= 0;
    ReadDataMW <= 0;
    lui_extendedMW <= 0;
    WriteRegMW <= 0; 
    mult_finishMW <= 0;
    instrMW <= 0;
    
    RegWriteMW2   <= 0;
    MemtoRegMW2   <= 0;
    Out_SelectMW2 <= 0;
    ALUoutMW2      <= 0;
    ReadDataMW2 <= 0;
    lui_extendedMW2 <= 0;
    WriteRegMW2 <= 0; 
    instrMW2 <= 0;
  end*/
  
    if(nEN == 1'b0)begin
    RegWriteMW <= RegWriteM;
    MemtoRegMW <= MemtoRegM;
    Out_SelectMW <= Out_SelectM;
    ALUoutMW <= ALUoutM;
    mult_resultMW <= mult_resultM;
    ReadDataMW <= ReadDataM;
    lui_extendedMW <= lui_extendedM;
    WriteRegMW <= WriteRegM; 
    instrMW <= InstrM;

    RegWriteMW2 <= RegWriteM2;
    MemtoRegMW2 <= MemtoRegM2;
    Out_SelectMW2 <= Out_SelectM2;
    ALUoutMW2 <= ALUoutM2;
    ReadDataMW2 <= ReadDataM2;
    lui_extendedMW2 <= lui_extendedM2;
    WriteRegMW2 <= WriteRegM2; 
    instrMW2 <= InstrM2;

	if(CLR)begin
		RegWriteMW <= 0;
		RegWriteMW2 <= 0;
	end
	else begin
		RegWriteMW <= RegWriteM;
		RegWriteMW2 <= RegWriteM2;
	end
    
  end
end
	
  assign RegWriteW   = RegWriteMW;
  assign MemtoRegW   = MemtoRegMW;
  assign Out_SelectW = Out_SelectMW;
  assign ALUoutW     = ALUoutMW;
  assign mult_resultW = mult_resultMW;
  assign ReadDataW     = ReadDataMW;
  assign lui_extendedW = lui_extendedMW;
  assign WriteRegW     = WriteRegMW; 
  assign mult_finishW = mult_finishMW;
  assign InstrW = instrMW;

  assign RegWriteW2   = RegWriteMW2;
  assign MemtoRegW2   = MemtoRegMW2;
  assign Out_SelectW2 = Out_SelectMW2;
  assign ALUoutW2     = ALUoutMW2;
  assign ReadDataW2     = ReadDataMW2;
  assign lui_extendedW2 = lui_extendedMW2;
  assign WriteRegW2     = WriteRegMW2; 
  assign InstrW2 = instrMW2;
endmodule