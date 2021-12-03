module branch_target_predictor_buffer1(
	input clk,
	input [31:0] PC_F,			//PC at fetch stage for accessing the cache 
	input access,				//toggle high in fetch stage if a branch-type is detected 
	input update,				//update enables write to the branch buffer
        input [31:0] branchUpdatePC,		//in EX stage, used to register branch base address in entries
	input [31:0] branchUpdateTarget,	//in EX stage, used to register target address in entries
	input [1:0] history,			//connects to BHT
        output found,				//[DEMO purpose for explanation] signifies a prediction found signal 
	output [31:0] predictPC, 		//predicted PC from the branch cache
	output reg [1:0] state);		//real signal used to determine cache access hit

/*
The entries should have #rows of PC/4 because PC is incremented in 4 
	    should have #columns of 3 
			[33:32]: state (prediction state bit)
			[31:0] : predictPC 
			[49:34] : *DEBUG* signal, stores the lower 16 bits of PC
*/
reg [33:0] entries [7:0]; 	//33 bits * 64 rows
 
//define parameters for different access state
parameter N = 2'b00;
parameter NT = 2'b01;
parameter TN = 2'b10;
parameter T = 2'b11;


//initialize other state registers
//initialize entries
integer i;
initial begin
    for(i=0;i<8;i=i+1) begin	//replicate initializing the memory block  
      entries[i] <= -34'd1;
    end
end

//the reason updatePC is separated from PC_F is that when update, it is already in the execution stage
//wire [31:0] branchUpdatePC_plus4;
//assign branchUpdatePC_plus4 = branchUpdatePC + 4;

wire [2:0] entry_addr;
assign entry_addr[2] = (update)?(branchUpdatePC[0]):(PC_F[0]);
assign entry_addr[1:0]  = history;
	//entry address = input PC[7:0] >> 2

reg [33:0] __that_whole_entry;  //*just for DEBUG purpose! not used any where else

assign predictPC = (access) ? entries[entry_addr][31:0] : 32'b0;
assign found = (entries[entry_addr][31:0] != -1) && access;

always@(posedge clk)begin
	/*
	if(access)begin
		__that_whole_entry <= entries[entry_addr];
		if(entries[entry_addr][31:0] != 32'b0)begin	//output predict PC
			predictPC <= entries[entry_addr][31:0];
			found <= 1'b1; //used to update SM
		end
		else begin
			found <= 1'b0;
		end
	end
	*/
	/*update State Machine*/
        if(update)begin
	case (entries[entry_addr][33:32])
		N: begin					//not taken, major
		  if(found)						//hit
			entries[entry_addr][33:32] <= NT;	
		  else 
			entries[entry_addr][33:32] <= N;		//not hit
		end
		NT: begin					//not taken, minor
		  if(found)						//hit
			entries[entry_addr][33:32] <= TN;
		  else 
			entries[entry_addr][33:32] <= N;
		end
		TN: begin
		 if(found)						//hit
			entries[entry_addr][33:32] <= T;	//not taken, major
		 else 
			entries[entry_addr][33:32] <= NT;
		end
		T: begin					//not taken, minor
		  if(found)						//hit				
			entries[entry_addr][33:32] <= T;
		  else 
			entries[entry_addr][33:32] <= TN;		//not hit
		end
	endcase
        end
 
	//write to the branch buffer
	if(update)begin
		entries[entry_addr][31:0] <= branchUpdateTarget ; //Enter branch instruction address and next PC into branch-target buffer. 
		
	end


	
	//assign state for datapath. In datapath state is used to recognize if flush are needed for book keep instructions
	assign state = entries[entry_addr][33:32];
end



endmodule
