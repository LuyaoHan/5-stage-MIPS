/*
1. 32-bit input port for addressing 
2. 32-bit output port for loading instructions from the memory

$memread(?filename?,register_bank_name) inside an initial block in order
to initialize your instruction memory.
*/

module instr_memory(input [31:0] address, output [31:0] read_data, output [31:0] read_data2);
  reg [7:0] instr_mem [65535:0]; 	//ram size should be 65536(for 32 bit addresses) by 32 
  wire [31:0] address4;
  initial begin 
    $readmemb("bne_test.bin",instr_mem);	//loads the instructing problem encoing binary file 
  end
  assign address4 = address+32'd4;
  assign read_data = {instr_mem[address],instr_mem[address+1],instr_mem[address+2],instr_mem[address+3]};
  assign read_data2 = {instr_mem[address4],instr_mem[address4+1],instr_mem[address4+2],instr_mem[address4+3]};
endmodule
