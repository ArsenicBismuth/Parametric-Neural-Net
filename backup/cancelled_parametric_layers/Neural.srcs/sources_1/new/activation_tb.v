// Dafa Faris Muhammad / 13215044
// Testbench for activation function

`include "fixed_point.vh"

module activation_tb;
  
  parameter n = `n;   // Bit
  parameter f = `f;   // Fraction
  parameter i = `i;   // Integer
  
  // Testing configs
  real euler = 2.71828;
//  wire signed [i-1:0-f] euler = 32'sb10101101111110000100110010;
  integer i;

  // Inputs
  reg clk, rst;
  reg signed [i-1:0-f] z; // MAC output cropped
  
  // Outputs
  wire signed [i-1:0-f] y; // Activation output
  
  // DUT, port mapping by order
  activation a1();
  assign y = a1.sigmoid(z);
  
  
  
  // Sameness test (waveform)
  
  // Fraction test (waveform)
  real ref_y;
  real error;
  
  always @* begin
    ref_y = 1 / (1 + euler**(-z * 2.0**-f));
    error = (y * 2.0**-f) - ref_y;
  end
  
  
  
  // Fraction test (transcript)
//  always @* begin
//    $display("y = %f", 1 / (1 + 2.71828**(-y * 2.0**-f)));
//    $display();
//  end
  
  
  
  initial begin: CLOCK_INIT // Block name for later R/W
    clk = 1'b0;
    rst = 1'b0;
    
    #10; rst = 1'b1;	// Activate everything
    
    // Random input case
    z = 32'sb0; 
    // Range -3.0 to 3.0, incremented 0.125
    for (i=-24; i<=24; i=i+1) begin
      z = i << (f-3);
      #10;
    end
    #20;
  end
  
  always begin: CLOCK_GEN
    #5 clk = ~clk;  // Period = 10ns
  end
    
endmodule
