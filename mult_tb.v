module mult_tb();
reg sim_clk, sim_start, sim_is_signed;
reg [31:0] sim_a,sim_b;
wire [63:0] sim_s;

mult mult(
 .clk(sim_clk),
 .start(sim_start),
 .is_signed(sim_is_signed),
 .a(sim_a),
 .b(sim_b),
 .s(sim_s)
);


initial begin
sim_clk = 1;
sim_start = 1;
#1 
sim_start = 0;
sim_is_signed = 0;
sim_a = 32'd5;
sim_b = 32'd7;
forever #10 sim_clk = ~sim_clk;
end



endmodule