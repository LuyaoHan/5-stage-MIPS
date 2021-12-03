/*
three 32-bit input ports:
1. writing data into memory, 
2. reading data from memory
3. specifying memory address
4. enable or disable write operation 
5. clock signal
*/

module data_memory(
	input clk, 
	input write, 
	input [31:0] read_address,
	input write2, 
	input [31:0] read_address2, 
	input [4:0] count, 
	input [31:0] write_address, 
	input [127:0] write_data, 
	output [127:0] read_data,
	input [31:0] write_address2, 
	input [127:0] write_data2, 
	output [127:0] read_data2) ;
  wire [31:0] BB;
  wire [31:0] S;
  wire   cout;
  reg [1:0] zero, one, two, three;
  reg [31:0] w0, w1, w2, w3, r0, r1, r2, r3;
  reg [127:0] read_buffer;
 wire [31:0] BB2;
  wire [31:0] S2;
  wire   cout2;
  reg [31:0] w02, w12, w22, w32, r02, r12, r22, r32;
  reg [127:0] read_buffer2;
  reg [31:0] mem [65535:0]; 	//ram size should be 65536(for 32 bit addresses) by 32  
  integer i;
  initial begin  
    //for(i=0;i<65536;i=i+1)begin	//replicate initializing the memory block  
      //mem[i] <= 32'h0;
    //end
    zero = 2'b0;		//load instal parameters to be used to specify specify word in the block
    one = 2'b01;
    two = 2'b10;
    three = 2'b11;
  end

initial begin
    mem[0] <= 32'd1;		//initial values to be used in the interesting program. The program is expected to lw first. 
    mem[1] <= 32'd1; 
    mem[2] <= 32'd1;
    mem[3] <= 32'd10;
    mem[4] <= 32'd8;
    mem[5] <= 32'd5;
end


  always@(*) begin 
    if (count == 5'b0 ) 	begin	//if write is enabled
	w0[31:2] = write_address[31:2];	//write word0-3 from the block write address
	w0[1:0] = zero;
	w1[31:2] = write_address[31:2];
	w1[1:0] = one;
	w2[31:2] = write_address[31:2];
	w2[1:0] = two;
	w3[31:2] = write_address[31:2];
	w3[1:0] = three;
	mem[w0] <= write_data[31:0];  		//write data to memory address
	mem[w1] <= write_data[63:32];
	mem[w2] <= write_data[95:64];
	mem[w3] <= write_data[127:96];
    end
   else begin
	r0[31:2] = read_address[31:2];	//read block r0-r3 from read_addresses
	r0[1:0] = zero;
	r1[31:2] = read_address[31:2];
	r1[1:0] = one;
	r2[31:2] = read_address[31:2];
	r2[1:0] = two;
	r3[31:2] = read_address[31:2];
	r3[1:0] = three;
	read_buffer[31:0] = mem[r0];
	read_buffer[63:32] = mem[r1];
	read_buffer[95:64] = mem[r2];
	read_buffer[127:96] = mem[r3];
  end
end 
  assign read_data = read_buffer;	//assign output from the buffer 

always@(*) begin 
    if (count == 5'b0 ) 	begin	//if write is enabled
	w02[31:2] = write_address2[31:2];	//write word0-3 from the block write address
	w02[1:0] = zero;
	w12[31:2] = write_address2[31:2];
	w12[1:0] = one;
	w22[31:2] = write_address2[31:2];
	w22[1:0] = two;
	w32[31:2] = write_address2[31:2];
	w32[1:0] = three;
	mem[w02] <= write_data2[31:0];  		//write data to memory address
	mem[w12] <= write_data2[63:32];
	mem[w22] <= write_data2[95:64];
	mem[w32] <= write_data2[127:96];
    end
   else begin
	r02[31:2] = read_address2[31:2];	//read block r0-r3 from read_addresses
	r02[1:0] = zero;
	r12[31:2] = read_address2[31:2];
	r12[1:0] = one;
	r22[31:2] = read_address2[31:2];
	r22[1:0] = two;
	r32[31:2] = read_address2[31:2];
	r32[1:0] = three;
	read_buffer2[31:0] = mem[r02];
	read_buffer2[63:32] = mem[r12];
	read_buffer2[95:64] = mem[r22];
	read_buffer2[127:96] = mem[r32];
  end
end 
  assign read_data2 = read_buffer2;	//assign output from the buffer 

endmodule