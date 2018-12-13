// Dafa Faris Muhammad / 13215044
// Testbench for 2D convolution system

`include "fixed_point.vh"
   
module node_tb;

  parameter sx = 2;   // Size of x
  parameter n = `n; // Bit
  parameter f = `f; // Fraction
  parameter i = `i; // Integer
  
  // Testing configs
  real euler = 2.71828;
//  wire signed [i-1:0-f] euler = 32'sb10101101111110000100110010;
  wire signed [2*n:0] zeros = 64'b0;  // Zeros
  integer seed = 1;
  integer j;

  // Inputs
  reg clk, rst;
  reg signed [n*sx-1:0] nx; // Concatenation of sx amount of x (input)
  reg signed [n*sx-1:0] nw; // Concatenation of sx amount of w (weight)
  reg signed [i-1:0-f] b; // Bias
  
  // Outputs
  wire signed [i-1:0-f] y;
  
  // DUT, port mapping by order
  node node11(nx, nw, b, y);
  
  // DUT wires, not actual j/O but only for testing
  wire signed [(i-1)*2:(0-f)*2] mac = node11.mac;
  wire signed [i-1:0-f] z = node11.z;
  
  
  
  // Sameness test (waveform)
  
  // Connections (not registers), made again here since 2D array isn't passable
  reg signed [i-1:0-f] x [0:sx-1];  // Separated nx into array of sx x
  reg signed [i-1:0-f] w [0:sx-1];  // Separated nw into array of sx w
  
  // Separating inputs. Parallel. Made again here since 2D array isn't passable
  always @(*) begin
    for (j=0; j<sx; j=j+1) begin
//       [a +: b] means a offset with b width
      x[j] <= nx[j*n +: n];
      w[j] <= nw[j*n +: n];
    end
  end
  
  // Fraction test (waveform)
  wire signed [(i-1)*2:(0-f)*2] ref_mac = (x[1]*w[1] + x[0]*w[0]) + (b << 24);
//  wire signed [(i-1)*2:(0-f)*2] ref = (nx[63:32]*nw[63:32] + nx[31:0]*nw[31:0] + b);
  wire signed [i-1:0-f] ref_z = ref_mac[i-1:0-f];
  real ref_y;
  
  always @* begin
    ref_y = 1 / (1 + euler**(-ref_z * 2.0**-f));
  end
//  wire signed [15:0] error = z - ref;
  
  
  
  // Fraction test (transcript)
  always @* begin
    $display();
    $display("x = {%f, %f}", x[1] * 2.0**-f, x[0] * 2.0**-f);
    $display("w = {%f, %f}", w[1] * 2.0**-f, w[0] * 2.0**-f);
    $display("b = %f", b * 2.0**-f);
    $display("mac = %f | z = %f", mac * 2.0**-(2*f), z * 2.0**-f);
    $display("y = %f", y * 2.0**-f);
    $display("\nReferences:");
    $display("mac = %f | z = %f", ref_mac * 2.0**-(2*f), ref_z * 2.0**-f);
    $display("z = %f", (x[0] * 2.0**-f) * (w[0] * 2.0**-f) + (x[1] * 2.0**-f) * (w[1] * 2.0**-f) + (b * 2.0**-f));
    $display("y = %f", 1 / (1 + 2.71828**(-ref_z * 2.0**-f)));
    $display();
  end
  
  
  
  initial begin: CLOCK_INIT // Block name for later R/W
    clk = 1'b0;
    rst = 1'b0;
    
    #10; rst = 1'b1;	// Activate everything
    
    repeat(10) begin
      // Random input case, $random can only create up to 32-bit
       for (j=0; j<sx; j=j+1) begin
         // [a +: b] means a offset with b width
         nx[j*n +: n] = ($random(seed) % (5 << f));  // Range -5 to 5
         nw[j*n +: n] = ($random(seed) % (5 << f));  // Range -5 to 5
       end
       b = $random(seed) % (5 << f);
       #20;
    end
    
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
