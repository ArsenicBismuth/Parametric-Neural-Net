// Dafa Faris Muhammad / 13215044
// Left shift register, shifting n bits to the left every clock.

module shift_register(clk, rst, we, x, y);

  parameter m = 4;    // m amount of n-bit numbers
  parameter n = 32;
  
  // I/O
  input clk, rst;
  input we;
  input [n-1:0] x;
  output reg [m*n-1:0] y;
    
  // D-FlipFlop
  always @(posedge clk or posedge rst)
    if (rst) // Init to zeros
      y <= {m*n{1'b0}};
    else
      if (we) begin // Shift right n-bit: n bits of x and m*n - n MSB of prev y
        $write("%.4f | ", x * 2.0**-24);
        y <= {x, y[m*n-1:n]};
      end
  
  always @(negedge we) begin
    $display("");
  end
   
  
endmodule