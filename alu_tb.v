module alu_tb();

reg [31:0]sim_a,sim_b;
reg [3:0] sim_func;
wire [31:0]sim_ALUout;
reg [31:0]expected;
/*
The instruction looks like:
[3:0] Func
0000           A & B           and/andi
0001           A | B           or/ori
0010           A + B           add/addi/addu/addiu/lw/sw
0011           A ^ B           xor/xori
0100           A XNOR B
0101           A << 16         lui  
0110 
0111          SLT             slt/slti/sltu/sltiu
1000          A & ~B
1001          A | ~B
1010          A - B           sub/subu        
1011          A ^ ~B           
1100          A XNOR ~B
1101
1110          
1111    
*/
ALU ALU(
	.In1(sim_a),
	.In2(sim_b), 
	.Func(sim_func), 
	.ALUout(sim_ALUout)
);

initial begin
	//and
	sim_a = 32'b10110011001010101011110011111001;
	sim_b = 32'b10110011001010101010000110110110;
	sim_func = 32'b0000;
	expected = 32'b10110011001010101010000010110000;
	$display("sim_a:%b   sim_b:%b  sim_func:%b  result:%b",sim_a,sim_b,sim_func,sim_ALUout);
	#20;


	//or
	sim_a = 32'b10100000000000000000000001111001;
	sim_b = 32'b00000000000110000000000000010110;
	sim_func = 32'b0001;
	expected = 32'b10100000000110000000000001111111;
	$display("sim_a:%b   sim_b:%b  sim_func:%b  result:%b",sim_a,sim_b,sim_func,sim_ALUout);
	#20;

	//add
	sim_a = 32'd123;
	sim_b = 32'd12341;
	sim_func = 32'b0010;
	$display("sim_a:%b   sim_b:%b  sim_func:%b  result:%b",sim_a,sim_b,sim_func,sim_ALUout);
	expected = 32'd12464;
	#20;

	//xor
	sim_a = 32'b10110011001010101011110011111001;
	sim_b = 32'b10101010101010101010101010101010;
	sim_func = 32'b0011;
	expected = 32'b00011001100000000001011001010011;
	$display("sim_a:%b   sim_b:%b  sim_func:%b  result:%b",sim_a,sim_b,sim_func,sim_ALUout);
	#20;

	//xnor
	sim_a = 32'b10110011001010101011110011111001;
	sim_b = 32'b10101010101010101010101010101010;
	sim_func = 32'b0100;
	expected = 32'b11100110011111111110100110101100;
	$display("sim_a:%b   sim_b:%b  sim_func:%b  result:%b",sim_a,sim_b,sim_func,sim_ALUout);
	#20;

	//lui
	sim_a = 32'b11111111000000001111111111111111;
	sim_b = 32'b11111111000000000000000011111111;
	sim_func = 32'b0101;
	expected = 32'b11111111000000000000000011111111;
	$display("sim_a:%b   sim_b:%b  sim_func:%b  result:%b",sim_a,sim_b,sim_func,sim_ALUout);
	#20;

	//slt
	sim_a = 32'd53;
	sim_b = 32'd42;
	sim_func = 32'b0111;
	expected = 32'b0;
	$display("sim_a:%b   sim_b:%b  sim_func:%b  result:%b",sim_a,sim_b,sim_func,sim_ALUout);
	#20;

	//slt
	sim_a = 32'd129838;
	sim_b = 32'd3412;
	sim_func = 32'b1010;
	expected = 32'd126426;
	$display("sim_a:%b   sim_b:%b  sim_func:%b  result:%b",sim_a,sim_b,sim_func,sim_ALUout);
	#20;
end

endmodule
