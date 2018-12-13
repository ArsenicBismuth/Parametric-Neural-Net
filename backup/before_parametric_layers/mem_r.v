// Dafa Faris Muhammad / 13215044
// Read-only memory

`include "fixed_point.vh"

module  mem_r(add, data);
  parameter list = "memory.list";
  parameter bits = `n;
  
  input [7:0] add;
  output signed [bits-1:0] data;
  
  reg signed [bits-1:0] memory [0:255];

  initial begin
    $readmemh(list, memory);
  end

  assign data = memory[add];
  
endmodule
