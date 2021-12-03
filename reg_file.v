module regfile(
    input Clk, Write, Write2,
    input Reset,
    input [4:0] PR1, PR2, WR,
    input [31:0] WD,
    input [4:0] PR12, PR22, WR2,
    input [31:0] WD2,
    output [31:0] RD12, RD22,
    output [31:0] RD1, RD2);
    
    reg [31:0] rf[31:0];
    integer i;
	//initialize reg file at reset 
    always @(*) begin
	if(Reset) begin
          for(i = 0; i<32; i=i+1)
            rf[i] = 32'd0;
	end
    end
    
    assign RD1 = (PR1 == 0)? 32'b0:rf[PR1];  //$zero registre is special
    assign RD2 = (PR2 == 0)? 32'b0:rf[PR2];

    assign RD12 = (PR12 == 0)? 32'b0:rf[PR12];  //$zero registre is special
    assign RD22 = (PR22 == 0)? 32'b0:rf[PR22];
    
    always @(posedge Clk) begin
      if(WR != 0) begin  //shouldn't write to $0 register
        if (Write) rf[WR] = WD;
      end
      if(WR2 != 0) begin  //shouldn't write to $0 register
        if (Write2) rf[WR2] = WD2;
      end
    end
endmodule