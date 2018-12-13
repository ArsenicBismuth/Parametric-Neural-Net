// Dafa Faris Muhammad / 13215044
// Write-only memory

`include "fixed_point.vh"

module  mem_w(clk, rst, write, add, data);
  parameter list = "memory.list";
  parameter bits = `n;
  
  input clk, rst, write; // Enable write
  input [7:0] add;
  input signed [bits-1:0] data;
  
  reg signed [bits-1:0] memory [0:127];
  
  integer i;
  
  // Storing data
  always @(posedge clk or negedge rst)
    if (!rst) begin
      // Reset
      for (i=0; i<128; i=i+1) memory[i] <= 16'h0000;
    end else begin
      
      if (write) begin
        memory[add] <= data;		// The actual memory
      end
        
    end
  
  always @(negedge write)
    if (!write) begin
      $writememh(list, memory);		// Store to text. Only used for checking.
    end
  
endmodule
