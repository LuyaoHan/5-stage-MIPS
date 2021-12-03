module cache(
	input [31:0] address, write_data_in, //address is the address we are dealing with, data is what will be written in a write instr
	input [127:0] mem_input,   //mem input is what will be stored in the cache when we fetch from mem
	input write_in, clk, read_in, //We need to specify what we are doing in the cache. (Either read or write) for everything that we want to do in the cach
	input [31:0] address2, write_data_in2, //address is the address we are dealing with, data is what will be written in a write instr
	input [127:0] mem_input2,   //mem input is what will be stored in the cache when we fetch from mem
	input write_in2, clk2, read_in2, //We need to specify what we are doing in the cache. (Either read or write) for everything that we want to do in the cach
	output [31:0] read_data2, mem_read_address2, mem_write_address2, //read_data is what is read on a read instruction. mem_access_address is what we are fetchin from mem in the case of a miss in the cache
	output [31:0] read_data, mem_read_address, mem_write_address, //read_data is what is read on a read instruction. mem_access_address is what we are fetchin from mem in the case of a miss in the cache
	output mem_access_status,
	output mem_write,
	output [4:0] countR,
	output [127:0] mem_write_data,
	output reg loc_access,
	output mem_write2,
	output [127:0] mem_write_data2); //mem access status is going to be used in the hazard to stall processor for 20 cycles during mem access. Mem_write is going to be used to write to the mem from the cache

reg mem_writeR, mem_access_statusR;
reg [31:0] read_dataR, mem_read_addressR, mem_write_addressR;
reg [127:0] mem_write_dataR;
reg [148:0] way1[1023:0]; //way1 and way2 are the 2-way implementation. Two sperate regs are used to implement it
reg [148:0] way2[1023:0];
reg [4:0] count;//This is used to stall during mem access
reg [9:0] set; //used to find the block address in the cache
reg [19:0] tag; //tag is essentially the id of the address in the cache. It is necessary to compare to find correct things
reg [1:0] word; //word is used once we have found the block to select the proper word from the block
reg [127:0] block; //this is the block
reg [19:0] temp_tag; //debuggin purposes

reg mem_writeR2;
reg [31:0] read_dataR2, mem_read_addressR2, mem_write_addressR2;
reg [127:0] mem_write_dataR2;
reg [9:0] set2; //used to find the block address in the cache
reg [19:0] tag2; //tag is essentially the id of the address in the cache. It is necessary to compare to find correct things
reg [1:0] word2; //word is used once we have found the block to select the proper word from the block
reg [127:0] block2; //this is the block

reg write,read;
reg [31:0] write_data;


reg write2,read2;
reg [31:0] write_data2;

assign countR = count;
assign mem_access_status = mem_access_statusR;
assign mem_write = mem_writeR;
assign read_data = read_dataR;
assign mem_read_address = mem_read_addressR;
assign mem_write_address = mem_write_addressR;
assign mem_write_data = mem_write_dataR;

assign mem_write2 = mem_writeR2;
assign read_data2 = read_dataR2;
assign mem_read_address2 = mem_read_addressR2;
assign mem_write_address2 = mem_write_addressR2;
assign mem_write_data2 = mem_write_dataR2;

integer i;
initial begin
	count = 5'd0;
	mem_access_statusR <= 1'b0;
	loc_access = 0;
	for(i = 0; i < 1023; i = i + 1) begin
		way1[i] = -1;
		way2[i] = -1;
	end
end
always@(posedge mem_access_status)begin
   write_data <= write_data_in;
   write_data2 <= write_data_in2;
end

always@(negedge clk) begin
	if(mem_access_statusR == 1'b0)begin
	write <= write_in;
	read <= read_in;
	write2 <= write_in2;
	read2 <= read_in2;
	end
end

always@(posedge clk) begin
	set = address[11:2]; //use this to find what the block is going to be in the cache. There are 1023 blocks
	tag = address[31:12]; //This is the tag that is going to be stored in the block with it
	word = address[1:0];
	if(read == 1'b1) begin //read from cache
		//temp_tag = way1[set][31:12];
		//mem_access_statusR = 1'b1;
		if(way1[set][147:128] == tag) begin //if the block is already is way1, then choose the right word in the multipexer, and switched the last accesses bit, v.
			block = way1[set][127:0];
			way1[set][148] = 1'b1;//These two lines are the v bit for last used
			way2[set][148] = 1'b0;
			if(word == 2'b00) begin //multiplexer to choose the correct word to read out
				way1[set][31:0] = write_data;
			end
			else if(word == 2'b01) begin
				way1[set][63:32] = write_data;
			end
			else if(word == 2'b10) begin
				way1[set][95:64] = write_data;
			end
			else if(word == 2'b11) begin
				way1[set][127:96] = write_data;
			end
			loc_access = 1;
		end
		else if(way2[set][147:128] == tag) begin //if the block is alread in way2, then select with mux and then switched the last accessed bit
			$display("way2[set][147:128] == tag");
			block = way2[set][127:0];
			way2[set][148] = 1'b1;//These two lines are the v bit for last used
			way1[set][148] = 1'b0;
			if(word == 2'b00) begin
				read_dataR = way2[set][31:0];
			end
			else if(word == 2'b01) begin
				read_dataR = way2[set][63:32];
			end
			else if(word == 2'b10) begin
				read_dataR = way2[set][95:64];
			end
			else if(word == 2'b11) begin
				read_dataR = way2[set][127:96];
			end
			loc_access = 1;					
		end				
		else begin //if value is not found in either of the ways, we must fetch it from mem, and then store the block we are replacing in mem. THen we select the correct word and output it.
			$display("first else begin");
			if(way1[set][148] == 1'b1) begin // replace the one that was accessed not last
				if(count < 20) begin
					mem_access_statusR = 1'b1; //this will be sent to hazard for stalling pipelines etc.
					if(count == 5'b10010) begin
						mem_read_addressR = address; // in the second to last cycle, fetch the block we want from mem
					end
					if(count == 5'b10011) begin //in the last cycle send the block we are replacing to mem to be stored, and then use mux to select output from new block we fetched
						block = mem_input;
						mem_write_dataR = way2[set][127:0];
						mem_write_addressR[31:12] = way2[set][147:128];
						mem_write_addressR[11:2] = set;
						mem_writeR = 1'b1;
						mem_access_statusR = 1'b0;
						count = -1;
						way2[set][148] = 1'b1;
						way1[set][148] = 1'b0;
						way2[set][127:0] = block;
						way2[set][147:128] = tag;
						if(word == 2'b00) begin
							read_dataR = way2[set][31:0];
						end
						else if(word == 2'b01) begin
							read_dataR = way2[set][63:32];
						end
						else if(word == 2'b10) begin
							read_dataR = way2[set][95:64];
						end
						else if(word == 2'b11) begin
							read_dataR = way2[set][127:96];
						end
	
					end
					count = count + 1;
				end
				loc_access = 0;
			end
			else begin //same as above implementation but for when way2 was last accessed
				if(count <20) begin
					mem_access_statusR = 1'b1;
					if(count == 5'b10010) begin
						mem_read_addressR = address;
							
					end
					if(count == 5'b10011) begin
						block = mem_input;
						mem_write_dataR = way1[set][127:0];
						mem_write_addressR[31:12] = way1[set][147:128];
						mem_write_addressR[11:2] = set;
						mem_writeR = 1'b1;
						count = -1;
						mem_access_statusR = 1'b0;
						way1[set][127:0] = block;
						if(word == 2'b00) begin
							read_dataR = way1[set][31:0];
						end
						else if(word == 2'b01) begin
							read_dataR = way1[set][63:32];
						end
						else if(word == 2'b10) begin
							read_dataR = way1[set][95:64];
						end
						else if(word == 2'b11) begin
							read_dataR = way1[set][127:96];
						end
						way1[set][148] = 1'b1;
						way2[set][148] = 1'b0;
						way1[set][147:128] = tag;
					end
					count = count + 1;
				end
				loc_access = 0;
			end
		end
	end





/*write is almost identical to  read. In fact, it is identical to when we are trying to read a missing block, and we have to go fetch and write to memory.
The only difference is once we have swapped the blocks, we then write to the new block instead of storing it in read_data
if either of the two ways are empty for a set, there is not need to fetch. We can simply write to the empty clock
*/
	else if(write == 1'b1) begin //
		$display("**is write data");
		$display("*count is:%d",count);
		if(way1[set][147:128] != tag && way2[set][147:128] != tag) begin
			$display("*1:way1[set][147:128] != tag && way2[set][147:128] != tag"); 
			if(way1[set] != 149'b0 && way2[set] != 149'b0) begin
				$display("*2:way1[set] != 149'b0 && way2[set] != 149'b0");
				if(way1[set][148] == 1'b1) begin
					$display("*3:way1[set][148] == 1'b1");
					if(count < 20) begin
						mem_access_statusR = 1'b1;
						if(count == 5'b10010) begin
							mem_write_addressR = address;
							$display("count 18: mem_write_addressR prepared");
							 //this is wrong, Come back and fix this
						end
						if(count == 5'b10011 && mem_access_statusR) begin
							block <= mem_input;
							//mem_write_addressR[31:12] <= way2[set][147:128];
							//mem_write_addressR[11:2] <= set;
							mem_writeR <= 1'b1;
							mem_access_statusR <= 1'b0;
							count <= 0;
							way2[set][148] <= 1'b1;
							way1[set][148] <= 1'b0;
							way2[set][127:0] <= block;
							way2[set][147:128] <= tag;
							if(word == 2'b00) begin
								way2[set][31:0] <= write_data;
								mem_write_dataR <= (mem_write_dataR & 128'hxxxxxxxxxxxxxxxxxxxxxxxx00000000) |  write_data;
							end
							else if(word == 2'b01) begin
								way2[set][63:32] <= write_data;
								mem_write_dataR <= (mem_write_dataR & 128'hxxxxxxxxxxxxxxxx00000000xxxxxxxx) |  write_data;

							end
							else if(word == 2'b10) begin
								way2[set][95:64] <= write_data;
								mem_write_dataR <= (mem_write_dataR & 128'hxxxxxxxx00000000xxxxxxxxxxxxxxxx) |  write_data;
							end
							else if(word == 2'b11) begin
								way2[set][127:96] <= write_data;
								mem_write_dataR <= (mem_write_dataR & 128'h00000000xxxxxxxxxxxxxxxxxxxxxxxx) |  write_data;
							end
						end
						count = count + 1;
					end
				end
				else begin
					if(count <20) begin
						mem_access_statusR = 1'b1;
						if(count == 5'b10010) begin
							mem_write_addressR = address;
							
						end
						if(count == 5'b10011) begin
							block = mem_input; 
							way1[set][148] = 1'b1;
							way2[set][148] = 1'b0;
							mem_write_dataR = way1[set][127:0];
							mem_write_addressR[31:12] = way1[set][147:128];
							mem_write_addressR[11:2] = set;
							mem_writeR = 1'b1;
							count = -1;
							mem_access_statusR = 1'b0;
							way1[set][127:0] = block;
							way1[set][147:128] = tag;
							if(word == 2'b00) begin
								way1[set][31:0] = write_data;
							end
							else if(word == 2'b01) begin
								way1[set][63:32] = write_data;
							end
							else if(word == 2'b10) begin
								way1[set][95:64] = write_data;
							end
							else if(word == 2'b11) begin
								way1[set][127:96] = write_data;
							end
						end
						count = count + 1;
					end
				end
			end
			else if(way1[set] == 149'b0) begin
				way1[set][147:128] = tag;
				if(word == 2'b00) begin
					way1[set][31:0] = write_data;
				end
				else if(word == 2'b01) begin
					way1[set][63:32] = write_data;
				end
				else if(word == 2'b10) begin
				way1[set][95:64] = write_data;
				end
				else if(word == 2'b11) begin
					way1[set][127:96] = write_data;
				end
				way1[set][148] = 1'b1;
				way2[set][148] = 1'b0;
			end
			else begin
				way2[set][147:128] = tag;
				if(word == 2'b00) begin
					way2[set][31:0] = write_data;
				end
				else if(word == 2'b01) begin
					way2[set][63:32] = write_data;
				end
				else if(word == 2'b10) begin
					way2[set][95:64] = write_data;
				end
				else if(word == 2'b11) begin
					way2[set][127:96] = write_data;
				end
				way2[set][148] = 1'b1;
				way1[set][148] = 1'b0;
			end
		end
		else if(way1[set][147:128] == tag) begin
			if(word == 2'b00) begin
				way1[set][31:0] = write_data;
			end
			else if(word == 2'b01) begin
				way1[set][63:32] = write_data;
			end
			else if(word == 2'b10) begin
				way1[set][95:64] = write_data;
			end
			else if(word == 2'b11) begin
				way1[set][127:96] = write_data;
			end
			way1[set][148] = 1'b1;
			way2[set][148] = 1'b0;
		end
		else begin
			if(word == 2'b00) begin
				way2[set][31:0] = write_data;
			end
			else if(word == 2'b01) begin
				way2[set][63:32] = write_data;
			end
			else if(word == 2'b10) begin
				way2[set][95:64] = write_data;
			end
			else if(word == 2'b11) begin
				way2[set][127:96] = write_data;
			end
			way2[set][148] = 1'b1;
			way1[set][148] = 1'b0;
		end
	end
		
end	


always@(posedge clk) begin
	set2 = address2[11:2]; //use this to find what the block is going to be in the cache. There are 1023 blocks
	tag2 = address2[31:12]; //This is the tag that is going to be stored in the block with it
	word2 = address2[1:0];
	if(read2 == 1'b1) begin //read from cache
		//temp_tag = way1[set][31:12];
		//mem_access_statusR = 1'b1;
		if(way1[set2][147:128] == tag2) begin //if the block is already is way1, then choose the right word in the multipexer, and switched the last accesses bit, v.
			block2 = way1[set2][127:0];
			way1[set2][148] = 1'b1;//These two lines are the v bit for last used
			way2[set2][148] = 1'b0;
			if(word2 == 2'b00) begin //multiplexer to choose the correct word to read out
				way1[set2][31:0] = write_data2;
			end
			else if(word2 == 2'b01) begin
				way1[set2][63:32] = write_data2;
			end
			else if(word2 == 2'b10) begin
				way1[set2][95:64] = write_data2;
			end
			else if(word2 == 2'b11) begin
				way1[set2][127:96] = write_data2;
			end
			loc_access = 1;
		end
		else if(way2[set2][147:128] == tag2) begin //if the block is alread in way2, then select with mux and then switched the last accessed bit
			$display("way2[set2][147:128] == tag");
			block2 = way2[set2][127:0];
			way2[set2][148] = 1'b1;//These two lines are the v bit for last used
			way1[set2][148] = 1'b0;
			if(word2 == 2'b00) begin
				read_dataR2 = way2[set2][31:0];
			end
			else if(word2 == 2'b01) begin
				read_dataR2 = way2[set2][63:32];
			end
			else if(word2 == 2'b10) begin
				read_dataR2 = way2[set2][95:64];
			end
			else if(word2 == 2'b11) begin
				read_dataR2 = way2[set2][127:96];
			end
			loc_access = 1;					
		end				
		else begin //if value is not found in either of the ways, we must fetch it from mem, and then store the block we are replacing in mem. THen we select the correct word and output it.
			$display("first else begin");
			if(way1[set2][148] == 1'b1) begin // replace the one that was accessed not last
				if(count < 20) begin
					mem_access_statusR = 1'b1; //this will be sent to hazard for stalling pipelines etc.
					if(count == 5'b10010) begin
						mem_read_addressR2 = address2; // in the second to last cycle, fetch the block we want from mem
					end
					if(count == 5'b10011) begin //in the last cycle send the block we are replacing to mem to be stored, and then use mux to select output from new block we fetched
						block2 = mem_input2;
						mem_write_dataR2 = way2[set2][127:0];
						mem_write_addressR2[31:12] = way2[set2][147:128];
						mem_write_addressR2[11:2] = set2;
						mem_writeR2 = 1'b1;
						mem_access_statusR = 1'b0;
						count = -1;
						way2[set2][148] = 1'b1;
						way1[set2][148] = 1'b0;
						way2[set2][127:0] = block2;
						way2[set2][147:128] = tag2;
						if(word2 == 2'b00) begin
							read_dataR2 = way2[set2][31:0];
						end
						else if(word2 == 2'b01) begin
							read_dataR2 = way2[set2][63:32];
						end
						else if(word2 == 2'b10) begin
							read_dataR2 = way2[set2][95:64];
						end
						else if(word2 == 2'b11) begin
							read_dataR2 = way2[set2][127:96];
						end
	
					end
					count = count + 1;
				end
				loc_access = 0;
			end
			else begin //same as above implementation but for when way2 was last accessed
				if(count <20) begin
					mem_access_statusR = 1'b1;
					if(count == 5'b10010) begin
						mem_read_addressR2 = address;
							
					end
					if(count == 5'b10011) begin
						block2 = mem_input2;
						mem_write_dataR2 = way1[set2][127:0];
						mem_write_addressR2[31:12] = way1[set2][147:128];
						mem_write_addressR2[11:2] = set2;
						mem_writeR2 = 1'b1;
						count = -1;
						mem_access_statusR = 1'b0;
						way1[set2][127:0] = block2;
						if(word2 == 2'b00) begin
							read_dataR2 = way1[set2][31:0];
						end
						else if(word2 == 2'b01) begin
							read_dataR2 = way1[set2][63:32];
						end
						else if(word2 == 2'b10) begin
							read_dataR2 = way1[set2][95:64];
						end
						else if(word2 == 2'b11) begin
							read_dataR2 = way1[set2][127:96];
						end
						way1[set2][148] = 1'b1;
						way2[set2][148] = 1'b0;
						way1[set2][147:128] = tag2;
					end
					count = count + 1;
				end
				loc_access = 0;
			end
		end
	end





/*write is almost identical to  read. In fact, it is identical to when we are trying to read a missing block, and we have to go fetch and write to memory.
The only difference is once we have swapped the blocks, we then write to the new block instead of storing it in read_data
if either of the two ways are empty for a set, there is not need to fetch. We can simply write to the empty clock
*/
	else if(write == 1'b1) begin //
		$display("**is write data");
		$display("*count is:%d",count);
		if(way1[set2][147:128] != tag2 && way2[set2][147:128] != tag2) begin
			$display("*1:way1[set2][147:128] != tag2 && way2[set2][147:128] != tag2"); 
			if(way1[set2] != 149'b0 && way2[set2] != 149'b0) begin
				$display("*2:way1[set] != 149'b0 && way2[set] != 149'b0");
				if(way1[set2][148] == 1'b1) begin
					$display("*3:way1[set][148] == 1'b1");
					if(count < 20) begin
						mem_access_statusR = 1'b1;
						if(count == 5'b10010) begin
							mem_write_addressR2 = address;
							$display("count 18: mem_write_addressR prepared");
							 //this is wrong, Come back and fix this
						end
						if(count == 5'b10011 && mem_access_statusR) begin
							block2 <= mem_input2;
							//mem_write_addressR2[31:12] <= way2[set2][147:128];
							//mem_write_addressR2[11:2] <= set2;
							mem_writeR2 <= 1'b1;
							mem_access_statusR <= 1'b0;
							count <= 0;
							way2[set2][148] <= 1'b1;
							way1[set2][148] <= 1'b0;
							way2[set2][127:0] <= block2;
							way2[set2][147:128] <= tag2;
							if(word2 == 2'b00) begin
								way2[set2][31:0] <= write_data2;
								mem_write_dataR2<= (mem_write_dataR2 & 128'hxxxxxxxxxxxxxxxxxxxxxxxx00000000) |  write_data2;
							end
							else if(word2 == 2'b01) begin
								way2[set2][63:32] <= write_data;
								mem_write_dataR2 <= (mem_write_dataR2 & 128'hxxxxxxxxxxxxxxxx00000000xxxxxxxx) |  write_data2;

							end
							else if(word2 == 2'b10) begin
								way2[set2][95:64] <= write_data2;
								mem_write_dataR2 <= (mem_write_dataR2 & 128'hxxxxxxxx00000000xxxxxxxxxxxxxxxx) |  write_data2;
							end
							else if(word2 == 2'b11) begin
								way2[set2][127:96] <= write_data2;
								mem_write_dataR2 <= (mem_write_dataR2 & 128'h00000000xxxxxxxxxxxxxxxxxxxxxxxx) |  write_data2;
							end
						end
						count = count + 1;
					end
				end
				else begin
					if(count <20) begin
						mem_access_statusR = 1'b1;
						if(count == 5'b10010) begin
							mem_write_addressR2 = address2;
							
						end
						if(count == 5'b10011) begin
							block2 = mem_input2; 
							way1[set2][148] = 1'b1;
							way2[set2][148] = 1'b0;
							mem_write_dataR2 = way1[set2][127:0];
							mem_write_addressR2[31:12] = way1[set2][147:128];
							mem_write_addressR2[11:2] = set2;
							mem_writeR2 = 1'b1;
							count = -1;
							mem_access_statusR = 1'b0;
							way1[set2][127:0] = block2;
							way1[set2][147:128] = tag2;
							if(word2 == 2'b00) begin
								way1[set2][31:0] = write_data2;
							end
							else if(word2 == 2'b01) begin
								way1[set2][63:32] = write_data2;
							end
							else if(word2 == 2'b10) begin
								way1[set2][95:64] = write_data2;
							end
							else if(word2 == 2'b11) begin
								way1[set2][127:96] = write_data2;
							end
						end
						count = count + 1;
					end
				end
			end
			else if(way1[set2] == 149'b0) begin
				way1[set2][147:128] = tag2;
				if(word2 == 2'b00) begin
					way1[set2][31:0] = write_data2;
				end
				else if(word2 == 2'b01) begin
					way1[set2][63:32] = write_data2;
				end
				else if(word2 == 2'b10) begin
				way1[set2][95:64] = write_data2;
				end
				else if(word2 == 2'b11) begin
					way1[set2][127:96] = write_data2;
				end
				way1[set2][148] = 1'b1;
				way2[set2][148] = 1'b0;
			end
			else begin
				way2[set2][147:128] = tag2;
				if(word2 == 2'b00) begin
					way2[set2][31:0] = write_data2;
				end
				else if(word2 == 2'b01) begin
					way2[set2][63:32] = write_data2;
				end
				else if(word2 == 2'b10) begin
					way2[set2][95:64] = write_data2;
				end
				else if(word2 == 2'b11) begin
					way2[set2][127:96] = write_data2;
				end
				way2[set2][148] = 1'b1;
				way1[set2][148] = 1'b0;
			end
		end
		else if(way1[set2][147:128] == tag2) begin
			if(word2 == 2'b00) begin
				way1[set2][31:0] = write_data2;
			end
			else if(word2 == 2'b01) begin
				way1[set2][63:32] = write_data2;
			end
			else if(word2 == 2'b10) begin
				way1[set2][95:64] = write_data2;
			end
			else if(word2 == 2'b11) begin
				way1[set2][127:96] = write_data2;
			end
			way1[set2][148] = 1'b1;
			way2[set2][148] = 1'b0;
		end
		else begin
			if(word2 == 2'b00) begin
				way2[set2][31:0] = write_data2;
			end
			else if(word2 == 2'b01) begin
				way2[set2][63:32] = write_data2;
			end
			else if(word2 == 2'b10) begin
				way2[set2][95:64] = write_data2;
			end
			else if(word2 == 2'b11) begin
				way2[set2][127:96] = write_data2;
			end
			way2[set2][148] = 1'b1;
			way1[set2][148] = 1'b0;
		end
	end
		
end	
endmodule