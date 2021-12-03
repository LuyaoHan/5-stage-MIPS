module controller_tb();

reg [5:0] sim_op, sim_Func;
wire sim_Eq_ne, sim_MemRead , sim_MemWrite , sim_RegWrite , sim_ALUSrcA , sim_se_ze , sim_RegDst , 
sim_start_mult ,sim_mult_sign, sim_MemtoReg,sim_Output_branch;
wire [1:0] sim_Out_select;
wire [3:0] sim_ALU_op; 

controller controller(
  .op(sim_op),       					
  .Func(sim_Func),     					
  .Eq_ne(sim_Eq_ne),	        		
  .PC_source(sim_PC_source),      		
  .MemRead(sim_MemRead), 
  .MemWrite(sim_MemWrite), 				
  .RegWrite(sim_RegWrite),          	
  .ALUSrcA(sim_ALUSrcA), 
  .ALUSrcB(sim_ALUSrcB),  				
  .se_ze(sim_se_ze),             		
  .RegDst(sim_RegDst),            		
  .start_mult(sim_start_mult),       
  .mult_sign(sim_mult_sign),
  .MemtoReg(sim_MemtoReg),
  .Out_select(sim_Out_select),  		
  .ALU_op(sim_ALU_op),      			
  .Output_branch(sim_Output_branch)    	
);



always@(*)begin
	/*
	addi
	12'b001000xxxxxx
	*/
	$display("testing ADDI: ");
	sim_op = 6'b001000;
	sim_Func = 6'b000000;
	#20;
	$display("	ALU_op: %b",sim_ALU_op);
	$display("	MemRead: %b",sim_MemRead);
	$display("	MemWrite: %b",sim_MemWrite);
	$display("	RegWrite: %b",sim_RegWrite);
	$display("	ALUSrcA: %b",sim_ALUSrcA);
	$display("	se_ze: %b",sim_se_ze);
	$display("	RegDst: %b",sim_RegDst);
	$display("	start_mult: %b",sim_start_mult);
	$display("	MemtoReg: %b",sim_MemtoReg);
	$display("	Out_select: %b",sim_Out_select);
	$display("	Output_branch: %b",sim_Output_branch);
	$display("	Eq_ne: %b",sim_Eq_ne);
	/*
	addiu
	12'b001001xxxxxx
	*/
	$display("testing ADDIU: ");
	sim_op = 6'b001001;
	sim_Func = 6'b000000;
	#20;
	$display("	ALU_op: %b",sim_ALU_op);
	$display("	MemRead: %b",sim_MemRead);
	$display("	MemWrite: %b",sim_MemWrite);
	$display("	RegWrite: %b",sim_RegWrite);
	$display("	ALUSrcA: %b",sim_ALUSrcA);
	$display("	se_ze: %b",sim_se_ze);
	$display("	RegDst: %b",sim_RegDst);
	$display("	start_mult: %b",sim_start_mult);
	$display("	MemtoReg: %b",sim_MemtoReg);
	$display("	Out_select: %b",sim_Out_select);
	$display("	Output_branch: %b",sim_Output_branch);
	$display("	Eq_ne: %b",sim_Eq_ne);
	/*
	andi
	12'b001100xxxxxx
	*/
	$display("testing ANDI: ");
	sim_op = 6'b001100;
	sim_Func = 6'b000000;
	#20;
	$display("	ALU_op: %b",sim_ALU_op);
	$display("	MemRead: %b",sim_MemRead);
	$display("	MemWrite: %b",sim_MemWrite);
	$display("	RegWrite: %b",sim_RegWrite);
	$display("	ALUSrcA: %b",sim_ALUSrcA);
	$display("	se_ze: %b",sim_se_ze);
	$display("	RegDst: %b",sim_RegDst);
	$display("	start_mult: %b",sim_start_mult);
	$display("	MemtoReg: %b",sim_MemtoReg);
	$display("	Out_select: %b",sim_Out_select);
	$display("	Output_branch: %b",sim_Output_branch);
	$display("	Eq_ne: %b",sim_Eq_ne);
	/*
	ori
	12'b001101xxxxxx
	*/
	$display("testing ORI: ");
	sim_op = 6'b001101;
	sim_Func = 6'b000000;
	#20;
	$display("	ALU_op: %b",sim_ALU_op);
	$display("	MemRead: %b",sim_MemRead);
	$display("	MemWrite: %b",sim_MemWrite);
	$display("	RegWrite: %b",sim_RegWrite);
	$display("	ALUSrcA: %b",sim_ALUSrcA);
	$display("	se_ze: %b",sim_se_ze);
	$display("	RegDst: %b",sim_RegDst);
	$display("	start_mult: %b",sim_start_mult);
	$display("	MemtoReg: %b",sim_MemtoReg);
	$display("	Out_select: %b",sim_Out_select);
	$display("	Output_branch: %b",sim_Output_branch);
	$display("	Eq_ne: %b",sim_Eq_ne);
	/*
	xori
	12'b001110xxxxxx
	*/
	$display("testing XORI: ");
	sim_op = 6'b001110;
	sim_Func = 6'b000000;
	#20;
	$display("	ALU_op: %b",sim_ALU_op);
	$display("	MemRead: %b",sim_MemRead);
	$display("	MemWrite: %b",sim_MemWrite);
	$display("	RegWrite: %b",sim_RegWrite);
	$display("	ALUSrcA: %b",sim_ALUSrcA);
	$display("	se_ze: %b",sim_se_ze);
	$display("	RegDst: %b",sim_RegDst);
	$display("	start_mult: %b",sim_start_mult);
	$display("	MemtoReg: %b",sim_MemtoReg);
	$display("	Out_select: %b",sim_Out_select);
	$display("	Output_branch: %b",sim_Output_branch);
	$display("	Eq_ne: %b",sim_Eq_ne);
	/*
	slti
	12'b001010xxxxxx
	*/
	$display("testing SLTI: ");
	sim_op = 6'b001010;
	sim_Func = 6'b000000;
	#20;
	$display("	ALU_op: %b",sim_ALU_op);
	$display("	MemRead: %b",sim_MemRead);
	$display("	MemWrite: %b",sim_MemWrite);
	$display("	RegWrite: %b",sim_RegWrite);
	$display("	ALUSrcA: %b",sim_ALUSrcA);
	$display("	se_ze: %b",sim_se_ze);
	$display("	RegDst: %b",sim_RegDst);
	$display("	start_mult: %b",sim_start_mult);
	$display("	MemtoReg: %b",sim_MemtoReg);
	$display("	Out_select: %b",sim_Out_select);
	$display("	Output_branch: %b",sim_Output_branch);
	$display("	Eq_ne: %b",sim_Eq_ne);
	/*
	sltiu
	12'b001011xxxxxx
	*/
	$display("testing SLTIU: ");
	sim_op = 6'b001011;
	sim_Func = 6'b000000;
	#20;
	$display("	ALU_op: %b",sim_ALU_op);
	$display("	MemRead: %b",sim_MemRead);
	$display("	MemWrite: %b",sim_MemWrite);
	$display("	RegWrite: %b",sim_RegWrite);
	$display("	ALUSrcA: %b",sim_ALUSrcA);
	$display("	se_ze: %b",sim_se_ze);
	$display("	RegDst: %b",sim_RegDst);
	$display("	start_mult: %b",sim_start_mult);
	$display("	MemtoReg: %b",sim_MemtoReg);
	$display("	Out_select: %b",sim_Out_select);
	$display("	Output_branch: %b",sim_Output_branch);
	$display("	Eq_ne: %b",sim_Eq_ne);
	/*
	lw
	12'b100011xxxxxx
	*/
	$display("testing LW: ");
	sim_op = 6'b100011;
	sim_Func = 6'b000000;
	#20;
	$display("	ALU_op: %b",sim_ALU_op);
	$display("	MemRead: %b",sim_MemRead);
	$display("	MemWrite: %b",sim_MemWrite);
	$display("	RegWrite: %b",sim_RegWrite);
	$display("	ALUSrcA: %b",sim_ALUSrcA);
	$display("	se_ze: %b",sim_se_ze);
	$display("	RegDst: %b",sim_RegDst);
	$display("	start_mult: %b",sim_start_mult);
	$display("	MemtoReg: %b",sim_MemtoReg);
	$display("	Out_select: %b",sim_Out_select);
	$display("	Output_branch: %b",sim_Output_branch);
	$display("	Eq_ne: %b",sim_Eq_ne);
	/*
	sw
	12'b101011xxxxxx
	*/
	$display("testing SW: ");
	sim_op = 6'b101011;
	sim_Func = 6'b000000;
	#20;
	$display("	ALU_op: %b",sim_ALU_op);
	$display("	MemRead: %b",sim_MemRead);
	$display("	MemWrite: %b",sim_MemWrite);
	$display("	RegWrite: %b",sim_RegWrite);
	$display("	ALUSrcA: %b",sim_ALUSrcA);
	$display("	se_ze: %b",sim_se_ze);
	$display("	RegDst: %b",sim_RegDst);
	$display("	start_mult: %b",sim_start_mult);
	$display("	MemtoReg: %b",sim_MemtoReg);
	$display("	Out_select: %b",sim_Out_select);
	$display("	Output_branch: %b",sim_Output_branch);
	$display("	Eq_ne: %b",sim_Eq_ne);
	/*
	lui
	12'b001111xxxxxx
	*/
	$display("testing LUI: ");
	sim_op = 6'b001111;
	sim_Func = 6'b000000;
	#20;
	$display("	ALU_op: %b",sim_ALU_op);
	$display("	MemRead: %b",sim_MemRead);
	$display("	MemWrite: %b",sim_MemWrite);
	$display("	RegWrite: %b",sim_RegWrite);
	$display("	ALUSrcA: %b",sim_ALUSrcA);
	$display("	se_ze: %b",sim_se_ze);
	$display("	RegDst: %b",sim_RegDst);
	$display("	start_mult: %b",sim_start_mult);
	$display("	MemtoReg: %b",sim_MemtoReg);
	$display("	Out_select: %b",sim_Out_select);
	$display("	Output_branch: %b",sim_Output_branch);
	$display("	Eq_ne: %b",sim_Eq_ne);
	/*
	j
	12'b000010xxxxxx
	*/
	$display("testing J: ");
	sim_op = 6'b000010;
	sim_Func = 6'b000000;
	#20;
	$display("	ALU_op: %b",sim_ALU_op);
	$display("	MemRead: %b",sim_MemRead);
	$display("	MemWrite: %b",sim_MemWrite);
	$display("	RegWrite: %b",sim_RegWrite);
	$display("	ALUSrcA: %b",sim_ALUSrcA);
	$display("	se_ze: %b",sim_se_ze);
	$display("	RegDst: %b",sim_RegDst);
	$display("	start_mult: %b",sim_start_mult);
	$display("	MemtoReg: %b",sim_MemtoReg);
	$display("	Out_select: %b",sim_Out_select);
	$display("	Output_branch: %b",sim_Output_branch);
	$display("	Eq_ne: %b",sim_Eq_ne);
	/*
	bne
	12'b000101xxxxxx
	*/
	$display("testing BNE: ");
	sim_op = 6'b000101;
	sim_Func = 6'b000000;
	#20;
	$display("	ALU_op: %b",sim_ALU_op);
	$display("	MemRead: %b",sim_MemRead);
	$display("	MemWrite: %b",sim_MemWrite);
	$display("	RegWrite: %b",sim_RegWrite);
	$display("	ALUSrcA: %b",sim_ALUSrcA);
	$display("	se_ze: %b",sim_se_ze);
	$display("	RegDst: %b",sim_RegDst);
	$display("	start_mult: %b",sim_start_mult);
	$display("	MemtoReg: %b",sim_MemtoReg);
	$display("	Out_select: %b",sim_Out_select);
	$display("	Output_branch: %b",sim_Output_branch);
	$display("	Eq_ne: %b",sim_Eq_ne);
	/*
	beq
	12'b000100xxxxxx
	*/
	$display("testing BEQ: ");
	sim_op = 6'b000100;
	sim_Func = 6'b000000;
	#20;
	$display("	ALU_op: %b",sim_ALU_op);
	$display("	MemRead: %b",sim_MemRead);
	$display("	MemWrite: %b",sim_MemWrite);
	$display("	RegWrite: %b",sim_RegWrite);
	$display("	ALUSrcA: %b",sim_ALUSrcA);
	$display("	se_ze: %b",sim_se_ze);
	$display("	RegDst: %b",sim_RegDst);
	$display("	start_mult: %b",sim_start_mult);
	$display("	MemtoReg: %b",sim_MemtoReg);
	$display("	Out_select: %b",sim_Out_select);
	$display("	Output_branch: %b",sim_Output_branch);
	$display("	Eq_ne: %b",sim_Eq_ne);
	/*
	mult
	12'b000000011000
	*/
	$display("testing MULT: ");
	sim_op = 6'b000000;
	sim_Func = 6'b011000;
	#20;
	$display("	ALU_op: %b",sim_ALU_op);
	$display("	MemRead: %b",sim_MemRead);
	$display("	MemWrite: %b",sim_MemWrite);
	$display("	RegWrite: %b",sim_RegWrite);
	$display("	ALUSrcA: %b",sim_ALUSrcA);
	$display("	se_ze: %b",sim_se_ze);
	$display("	RegDst: %b",sim_RegDst);
	$display("	start_mult: %b",sim_start_mult);
	$display("	MemtoReg: %b",sim_MemtoReg);
	$display("	Out_select: %b",sim_Out_select);
	$display("	Output_branch: %b",sim_Output_branch);
	$display("	Eq_ne: %b",sim_Eq_ne);
	/*
	multu
	12'b000000011001
	*/
	$display("testing MULTU: ");
	sim_op = 6'b000000;
	sim_Func = 6'b011001;
	#20;
	$display("	ALU_op: %b",sim_ALU_op);
	$display("	MemRead: %b",sim_MemRead);
	$display("	MemWrite: %b",sim_MemWrite);
	$display("	RegWrite: %b",sim_RegWrite);
	$display("	ALUSrcA: %b",sim_ALUSrcA);
	$display("	se_ze: %b",sim_se_ze);
	$display("	RegDst: %b",sim_RegDst);
	$display("	start_mult: %b",sim_start_mult);
	$display("	MemtoReg: %b",sim_MemtoReg);
	$display("	Out_select: %b",sim_Out_select);
	$display("	Output_branch: %b",sim_Output_branch);
	$display("	Eq_ne: %b",sim_Eq_ne);
	/*
	add
	12'b000000100000
	*/
	$display("testing ADD: ");
	sim_op = 6'b000000;
	sim_Func = 6'b100000;
	#20;
	$display("	ALU_op: %b",sim_ALU_op);
	$display("	MemRead: %b",sim_MemRead);
	$display("	MemWrite: %b",sim_MemWrite);
	$display("	RegWrite: %b",sim_RegWrite);
	$display("	ALUSrcA: %b",sim_ALUSrcA);
	$display("	se_ze: %b",sim_se_ze);
	$display("	RegDst: %b",sim_RegDst);
	$display("	start_mult: %b",sim_start_mult);
	$display("	MemtoReg: %b",sim_MemtoReg);
	$display("	Out_select: %b",sim_Out_select);
	$display("	Output_branch: %b",sim_Output_branch);
	$display("	Eq_ne: %b",sim_Eq_ne);
	/*
	addu
	12'b000000100001
	*/
	$display("testing ADDU: ");
	sim_op = 6'b000000;
	sim_Func = 6'b100001;
	#20;
	$display("	ALU_op: %b",sim_ALU_op);
	$display("	MemRead: %b",sim_MemRead);
	$display("	MemWrite: %b",sim_MemWrite);
	$display("	RegWrite: %b",sim_RegWrite);
	$display("	ALUSrcA: %b",sim_ALUSrcA);
	$display("	se_ze: %b",sim_se_ze);
	$display("	RegDst: %b",sim_RegDst);
	$display("	start_mult: %b",sim_start_mult);
	$display("	MemtoReg: %b",sim_MemtoReg);
	$display("	Out_select: %b",sim_Out_select);
	$display("	Output_branch: %b",sim_Output_branch);
	$display("	Eq_ne: %b",sim_Eq_ne);
	/*
	sub
	12'b000000100010
	*/
	$display("testing SUB: ");
	sim_op = 6'b000000;
	sim_Func = 6'b100010;
	#20;
	$display("	ALU_op: %b",sim_ALU_op);
	$display("	MemRead: %b",sim_MemRead);
	$display("	MemWrite: %b",sim_MemWrite);
	$display("	RegWrite: %b",sim_RegWrite);
	$display("	ALUSrcA: %b",sim_ALUSrcA);
	$display("	se_ze: %b",sim_se_ze);
	$display("	RegDst: %b",sim_RegDst);
	$display("	start_mult: %b",sim_start_mult);
	$display("	MemtoReg: %b",sim_MemtoReg);
	$display("	Out_select: %b",sim_Out_select);
	$display("	Output_branch: %b",sim_Output_branch);
	$display("	Eq_ne: %b",sim_Eq_ne);
	/*
	subu
	12'b000000100011
	*/
	$display("testing SUBU: ");
	sim_op = 6'b000000;
	sim_Func = 6'b100011;
	#20;
	$display("	ALU_op: %b",sim_ALU_op);
	$display("	MemRead: %b",sim_MemRead);
	$display("	MemWrite: %b",sim_MemWrite);
	$display("	RegWrite: %b",sim_RegWrite);
	$display("	ALUSrcA: %b",sim_ALUSrcA);
	$display("	se_ze: %b",sim_se_ze);
	$display("	RegDst: %b",sim_RegDst);
	$display("	start_mult: %b",sim_start_mult);
	$display("	MemtoReg: %b",sim_MemtoReg);
	$display("	Out_select: %b",sim_Out_select);
	$display("	Output_branch: %b",sim_Output_branch);
	$display("	Eq_ne: %b",sim_Eq_ne);
	/*
	and
	12'b000000100100
	*/
	$display("testing AND: ");
	sim_op = 6'b000000;
	sim_Func = 6'b100100;
	#20;
	$display("	ALU_op: %b",sim_ALU_op);
	$display("	MemRead: %b",sim_MemRead);
	$display("	MemWrite: %b",sim_MemWrite);
	$display("	RegWrite: %b",sim_RegWrite);
	$display("	ALUSrcA: %b",sim_ALUSrcA);
	$display("	se_ze: %b",sim_se_ze);
	$display("	RegDst: %b",sim_RegDst);
	$display("	start_mult: %b",sim_start_mult);
	$display("	MemtoReg: %b",sim_MemtoReg);
	$display("	Out_select: %b",sim_Out_select);
	$display("	Output_branch: %b",sim_Output_branch);
	$display("	Eq_ne: %b",sim_Eq_ne);
	/*
	or
	12'b000000100101
	*/
	$display("testing OR: ");
	sim_op = 6'b000000;
	sim_Func = 6'b100101;
	#20;
	$display("	ALU_op: %b",sim_ALU_op);
	$display("	MemRead: %b",sim_MemRead);
	$display("	MemWrite: %b",sim_MemWrite);
	$display("	RegWrite: %b",sim_RegWrite);
	$display("	ALUSrcA: %b",sim_ALUSrcA);
	$display("	se_ze: %b",sim_se_ze);
	$display("	RegDst: %b",sim_RegDst);
	$display("	start_mult: %b",sim_start_mult);
	$display("	MemtoReg: %b",sim_MemtoReg);
	$display("	Out_select: %b",sim_Out_select);
	$display("	Output_branch: %b",sim_Output_branch);
	$display("	Eq_ne: %b",sim_Eq_ne);
	/*
	xor
	12'b000000100110
	*/
	$display("testing XOR: ");
	sim_op = 6'b000000;
	sim_Func = 6'b100110;
	#20;
	$display("	ALU_op: %b",sim_ALU_op);
	$display("	MemRead: %b",sim_MemRead);
	$display("	MemWrite: %b",sim_MemWrite);
	$display("	RegWrite: %b",sim_RegWrite);
	$display("	ALUSrcA: %b",sim_ALUSrcA);
	$display("	se_ze: %b",sim_se_ze);
	$display("	RegDst: %b",sim_RegDst);
	$display("	start_mult: %b",sim_start_mult);
	$display("	MemtoReg: %b",sim_MemtoReg);
	$display("	Out_select: %b",sim_Out_select);
	$display("	Output_branch: %b",sim_Output_branch);
	$display("	Eq_ne: %b",sim_Eq_ne);
	/*
	slt
	12'b000000101010
	*/
	$display("testing SLT: ");
	sim_op = 6'b000000;
	sim_Func = 6'b101010;
	#20;
	$display("	ALU_op: %b",sim_ALU_op);
	$display("	MemRead: %b",sim_MemRead);
	$display("	MemWrite: %b",sim_MemWrite);
	$display("	RegWrite: %b",sim_RegWrite);
	$display("	ALUSrcA: %b",sim_ALUSrcA);
	$display("	se_ze: %b",sim_se_ze);
	$display("	RegDst: %b",sim_RegDst);
	$display("	start_mult: %b",sim_start_mult);
	$display("	MemtoReg: %b",sim_MemtoReg);
	$display("	Out_select: %b",sim_Out_select);
	$display("	Output_branch: %b",sim_Output_branch);
	$display("	Eq_ne: %b",sim_Eq_ne);
	/*
	sltu
	12'b000000101011
	*/
	$display("testing SLTU: ");
	sim_op = 6'b000000;
	sim_Func = 6'b101011;
	#20;
	$display("	ALU_op: %b",sim_ALU_op);
	$display("	MemRead: %b",sim_MemRead);
	$display("	MemWrite: %b",sim_MemWrite);
	$display("	RegWrite: %b",sim_RegWrite);
	$display("	ALUSrcA: %b",sim_ALUSrcA);
	$display("	se_ze: %b",sim_se_ze);
	$display("	RegDst: %b",sim_RegDst);
	$display("	start_mult: %b",sim_start_mult);
	$display("	MemtoReg: %b",sim_MemtoReg);
	$display("	Out_select: %b",sim_Out_select);
	$display("	Output_branch: %b",sim_Output_branch);
	$display("	Eq_ne: %b",sim_Eq_ne);
	/*
	mfhi
	12'b000000010000
	*/
	$display("testing MFHI: ");
	sim_op = 6'b000000;
	sim_Func = 6'b010000;
	#20;
	$display("	ALU_op: %b",sim_ALU_op);
	$display("	MemRead: %b",sim_MemRead);
	$display("	MemWrite: %b",sim_MemWrite);
	$display("	RegWrite: %b",sim_RegWrite);
	$display("	ALUSrcA: %b",sim_ALUSrcA);
	$display("	se_ze: %b",sim_se_ze);
	$display("	RegDst: %b",sim_RegDst);
	$display("	start_mult: %b",sim_start_mult);
	$display("	MemtoReg: %b",sim_MemtoReg);
	$display("	Out_select: %b",sim_Out_select);
	$display("	Output_branch: %b",sim_Output_branch);
	$display("	Eq_ne: %b",sim_Eq_ne);
	/*
	mflo
	12'b000000010010
	*/
	$display("testing MFLO: ");
	sim_op = 6'b000000;
	sim_Func = 6'b010010;
	#20;
	$display("	ALU_op: %b",sim_ALU_op);
	$display("	MemRead: %b",sim_MemRead);
	$display("	MemWrite: %b",sim_MemWrite);
	$display("	RegWrite: %b",sim_RegWrite);
	$display("	ALUSrcA: %b",sim_ALUSrcA);
	$display("	se_ze: %b",sim_se_ze);
	$display("	RegDst: %b",sim_RegDst);
	$display("	start_mult: %b",sim_start_mult);
	$display("	MemtoReg: %b",sim_MemtoReg);
	$display("	Out_select: %b",sim_Out_select);
	$display("	Output_branch: %b",sim_Output_branch);
	$display("	Eq_ne: %b",sim_Eq_ne);
end
endmodule