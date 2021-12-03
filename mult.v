module mult(
	input clk, start, in_is_signed,
	input[31:0] in_a, in_b,
        output mult_status,
	output reg[63:0] s);


	reg status,is_signed;        
	localparam STATUS_GOING = 1'b1;	//macro defines the current status output to the pipeline reg
	localparam STATUS_FINISH = 1'b0;

	reg[4:0] state;
	reg [31:0] a;
        reg [31:0] b;
        reg [31:0] newb, newa;

	initial begin 		//at start signal, sum is cleared
	  if(start == 1) begin
	      s = 64'b0;        
	  end
	      state = 5'b0;	//state counter cleared to 0
	      status <= 1'b0;
	      is_signed <= 1'b0;
	end
       
	assign mult_status = status; 
        always@(posedge start)begin
          state <= 5'b0;
	  if( (in_a[31] == 1) && (in_b[31] ==1))//determine the sign of multiplication
	    is_signed = 1'b1;	//shows same sign, 1
	  else
	    is_signed = 1'b0;
          s = 64'b0;
          status = STATUS_GOING;
          a = in_a;
          b = in_b;
        end
	//starts the multiplication 
	always@(posedge clk) 
	begin
	if(is_signed == 0) begin
		if(state == 5'b00000) begin
			if(a[0] == 1) begin
		   		s = b;
			end
			else begin
				s = 0;
			end
		end
		if(state == 5'b00001) begin
			if(a[1] == 1) begin
		   		s = s + (b << 1);
			end
		end
		if(state == 5'b00010) begin
			if(a[2] == 1) begin
		   		s = s + (b << 2);
			end
		end
		if(state == 5'b00011) begin
			if(a[3] == 1) begin
		   		s = s + (b << 3);
			end
		end
		if(state == 5'b00100) begin
			if(a[4] == 1) begin
		   		s = s + (b << 4);
			end
		end
		if(state == 5'b00101) begin
			if(a[5] == 1) begin
		   		s = s + (b << 5);
			end
		end
		if(state == 5'b00110) begin
			if(a[6] == 1) begin
		   		s = s + (b << 6);
			end
		end
		if(state == 5'b00111) begin
			if(a[7] == 1) begin
		   		s = s + (b << 7);
			end
		end
		if(state == 5'b01000) begin
			if(a[8] == 1) begin
		   		s = s + (b << 8);
			end
		end
		if(state == 5'b01001) begin
			if(a[9] == 1) begin
		   		s = s + (b << 9);
			end
		end
		if(state == 5'b01010) begin
			if(a[10] == 1) begin
		   		s = s + (b << 10);
			end
		end
		if(state == 5'b01011) begin
			if(a[11] == 1) begin
		   		s = s + (b << 11);
			end
		end
		if(state == 5'b01100) begin
			if(a[12] == 1) begin
		   		s = s + (b << 12);
			end
		end
		if(state == 5'b01101) begin
			if(a[13] == 1) begin
		   		s = s + (b << 13);
			end
		end
		if(state == 5'b01110) begin
			if(a[14] == 1) begin
		   		s = s + (b << 14);
			end
		end
		if(state == 5'b01111) begin
			if(a[15] == 1) begin
		   		s = s + (b << 15);
			end
		end
		if(state == 5'b10000) begin
			if(a[16] == 1) begin
		   		s = s + (b << 16);
			end
		end
		if(state == 5'b10001) begin
			if(a[17] == 1) begin
		   		s = s + (b << 17);
			end
		end
		if(state == 5'b10010) begin
			if(a[18] == 1) begin
		   		s = s + (b << 18);
			end
		end
		if(state == 5'b10011) begin
			if(a[19] == 1) begin
		   		s = s + (b << 19);
			end
		end
		if(state == 5'b10100) begin
			if(a[20] == 1) begin
		   		s = s + (b << 20);
			end
		end
		if(state == 5'b10101) begin
			if(a[21] == 1) begin
		   		s = s + (b << 21);
			end
		end
		if(state == 5'b10110) begin
			if(a[22] == 1) begin
		   		s = s + (b << 22);
			end
		end
		if(state == 5'b10111) begin
			if(a[23] == 1) begin
		   		s = s + (b << 23);
			end
		end
		if(state == 5'b11000) begin
			if(a[24] == 1) begin
		   		s = s + (b << 24);
			end
		end
		if(state == 5'b11001) begin
			if(a[25] == 1) begin
		   		s = s + (b << 25);
			end
		end
		if(state == 5'b11010) begin
			if(a[26] == 1) begin
		   		s = s + (b << 26);
			end
		end
		if(state == 5'b11011) begin
			if(a[27] == 1) begin
		   		s = s + (b << 27);
			end
		end
		if(state == 5'b11100) begin
			if(a[28] == 1) begin
		   		s = s + (b << 28);
			end
		end
		if(state == 5'b11101) begin
			if(a[29] == 1) begin
		   		s = s + (b << 29);
			end
		end
		if(state == 5'b11110) begin
			if(a[30] == 1) begin
		   		s = s + (b << 30);
			end
		end
		if(state == 5'b11111) begin
			if(a[31] == 1) begin
		   		s = s + (b << 31);
			end
                        status = STATUS_FINISH;
			state <= 5'b0;
		end
		if(status == STATUS_GOING)
		state = state +1;
	end
	//if with reverse sign 
	else begin
		if(b[31] == 1 && a[31] == 0) begin
			newb = ~b + 1;
			newa = a;
		end
		else if(a[31] == 1 && b[31] == 0) begin
			newa = ~a +1;
			newb = b;
		end
		else if(a[31] == 1 && b[31] == 1)begin
			newa = ~a+1;
			newb = ~b+1;
		end
		else begin
			newa = a;
			newb = b;
		end
		if(state == 5'b00000) begin
			if(newa[0] == 1) begin
		   		s = newb;
			end
			else begin
				s = 0;
			end
		end
		if(state == 5'b00001) begin
			if(newa[1] == 1) begin
		   		s = s + (newb << 1);
			end
		end
		if(state == 5'b00010) begin
			if(newa[2] == 1) begin
		   		s = s + (newb << 2);
			end
		end
		if(state == 5'b00011) begin
			if(newa[3] == 1) begin
		   		s = s + (newb << 3);
			end
		end
		if(state == 5'b00100) begin
			if(newa[4] == 1) begin
		   		s = s + (newb << 4);
			end
		end
		if(state == 5'b00101) begin
			if(newa[5] == 1) begin
		   		s = s + (newb << 5);
			end
		end
		if(state == 5'b00110) begin
			if(newa[6] == 1) begin
		   		s = s + (newb << 6);
			end
		end
		if(state == 5'b00111) begin
			if(newa[7] == 1) begin
		   		s = s + (newb << 7);
			end
		end
		if(state == 5'b01000) begin
			if(newa[8] == 1) begin
		   		s = s + (newb << 8);
			end
		end
		if(state == 5'b01001) begin
			if(newa[9] == 1) begin
		   		s = s + (newb << 9);
			end
		end
		if(state == 5'b01010) begin
			if(newa[10] == 1) begin
		   		s = s + (newb << 10);
			end
		end
		if(state == 5'b01011) begin
			if(newa[11] == 1) begin
		   		s = s + (newb << 11);
			end
		end
		if(state == 5'b01100) begin
			if(newa[12] == 1) begin
		   		s = s + (newb << 12);
			end
		end
		if(state == 5'b01101) begin
			if(newa[13] == 1) begin
		   		s = s + (newb << 13);
			end
		end
		if(state == 5'b01110) begin
			if(newa[14] == 1) begin
		   		s = s + (newb << 14);
			end
		end
		if(state == 5'b01111) begin
			if(newa[15] == 1) begin
		   		s = s + (newb << 15);
			end
		end
		if(state == 5'b10000) begin
			if(newa[16] == 1) begin
		   		s = s + (newb << 16);
			end
		end
		if(state == 5'b10001) begin
			if(newa[17] == 1) begin
		   		s = s + (newb << 17);
			end
		end
		if(state == 5'b10010) begin
			if(newa[18] == 1) begin
		   		s = s + (newb << 18);
			end
		end
		if(state == 5'b10011) begin
			if(newa[19] == 1) begin
		   		s = s + (newb << 19);
			end
		end
		if(state == 5'b10100) begin
			if(newa[20] == 1) begin
		   		s = s + (newb << 20);
			end
		end
		if(state == 5'b10101) begin
			if(newa[21] == 1) begin
		   		s = s + (newb << 21);
			end
		end
		if(state == 5'b10110) begin
			if(newa[22] == 1) begin
		   		s = s + (newb << 22);
			end
		end
		if(state == 5'b10111) begin
			if(newa[23] == 1) begin
		   		s = s + (newb << 23);
			end
		end
		if(state == 5'b11000) begin
			if(newa[24] == 1) begin
		   		s = s + (newb << 24);
			end
		end
		if(state == 5'b11001) begin
			if(newa[25] == 1) begin
		   		s = s + (newb << 25);
			end
		end
		if(state == 5'b11010) begin
			if(newa[26] == 1) begin
		   		s = s + (newb << 26);
			end
		end
		if(state == 5'b11011) begin
			if(newa[27] == 1) begin
		   		s = s + (newb << 27);
			end
		end
		if(state == 5'b11100) begin
			if(newa[28] == 1) begin
		   		s = s + (newb << 28);
			end
		end
		if(state == 5'b11101) begin
			if(newa[29] == 1) begin
		   		s = s + (newb << 29);
			end
		end
		if(state == 5'b11110) begin
			//s = ~s+1;
			if(newa[30] == 1) begin
		   		s = s + (newb << 30);
			end
		end
		if(state == 5'b11111) begin
			//s = ~s+1;
			if(a[31] == 1 && b[31] == 1) begin
		   		s[63] = 0;
			end
			else if ((a[31] == 1 || b[31] == 1)) begin
				s = ~s+1;
				s[63] = 1;
			end
                        status <= STATUS_FINISH;	//output finish signal
			state <= 5'b0;
		end
                if(status == STATUS_GOING)
		state = state +1;		//otherwise increment state machine. 

	end
	end
	//assign start = 0;
endmodule