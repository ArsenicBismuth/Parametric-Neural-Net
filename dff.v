// Async reset D-Flipflop

module dff(clk, rst, we, D, Q);

  parameter n = 32;

  input clk, rst, we;
  input [n-1:0] D;
  output reg [n-1:0] Q;

  always @(posedge clk or posedge rst)
    if (rst)
      Q = {n{1'b0}};  // Reset data
    else
      if (we)
        Q = D;  // Keep data
      
endmodule
  