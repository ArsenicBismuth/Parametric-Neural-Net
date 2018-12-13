// Async reset D-Flipflop

module dff(clk, rst, we, D, Q);

  parameter n = 32;

  input clk, rst, we;
  input [n-1:0] D;
  output reg [n-1:0] Q;

  always @(posedge clk or negedge rst)
    if (rst)
      if (we)
        Q = D;  // Keep data
    else
      Q = {n{1'b0}};  // Reset data
    
endmodule
  