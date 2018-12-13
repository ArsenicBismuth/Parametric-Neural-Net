// Dafa Faris Muhammad / 13215044
// Testbench for activation function

module activation_tb;
  parameter n = 32;   // Bits
  parameter sx = 2;   // Size of x
  parameter f = 24;   // Fractions
  
  // Testing configs
  real euler = 2.71828;
//  wire signed [n-1-f:0-f] euler = 32'sb10101101111110000100110010;
  integer i;

  // Inputs
  reg clk, rst;
  reg signed [n-1-f:0-f] z; // MAC output cropped
  
  // Outputs
  wire signed [n-1-f:0-f] y; // Activation output
  
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
    
//     Defined input case, it's from high index to low index: {x[1], x[0]}
//     nx = {-32'd3, 32'd2};
//     nw = {32'd8, 32'd1};
//     b = 32'd2; 
    
//    nx = {32'sd1 << f, -32'sd3 << f};
//    nw = {32'sb000011111111001011100100, 32'sb010101011100001010001111}; // 0.335 0.0623
//    b = 32'sb11011001100110011001100110 >>> 2; // 3.4/2
    
  end
  
  always begin: CLOCK_GEN
    #5 clk = ~clk;  // Period = 10ns
  end
    
endmodule
