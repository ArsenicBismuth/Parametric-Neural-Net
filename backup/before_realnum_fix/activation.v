// Dafa Faris Muhammad / 13215044
// Activation function using sigmoid
// Converter: https://www.exploringbinary.com/binary-converter/

/* Used for testing separately only. Full implementation is combined 
 * with node.v because hirearchical names are unsynthesizeable.
 * https://stackoverflow.com/questions/31042484
 *
 * Previously one would call using:
 *  activation a1();
 *  assign y = a1.linear(z);
*/

`include "fixed_point.vh"

module activation();
  
  parameter n = `n;   // Bit
  parameter f = `f;   // Fraction
  parameter i = `i;   // Integer
  
  function [i-1:0-f] relu;
      input signed [i-1:0-f] x;
      begin
        if (x < 32'sd0) relu = 0;
        else relu = x; 
      end
  endfunction
  
  // Lack of middle bits selection in Verilog multiplication complexify everything.
  // Thus, for every multiplication, temp wire is needed to avoid unintended truncation.
  function [i-1:0-f] sigmoid;
    input signed [i-1:0-f] x;
    
    // Everything is wire if implemented.
    // Power reults and their truncation.
    // all use 2*n size since operation performed in n-bit
    reg signed [(i-1)*2:(0-f)*2] x_2; reg signed [i-1:0-f] x_2t;
    reg signed [(i-1)*2:(0-f)*2] x_3; reg signed [i-1:0-f] x_3t;
    reg signed [(i-1)*2:(0-f)*2] x_5; reg signed [i-1:0-f] x_5t;
    reg signed [(i-1)*2:(0-f)*2] x_7; reg signed [i-1:0-f] x_7t;
    reg signed [(i-1)*2:(0-f)*2] x_9; reg signed [i-1:0-f] x_9t;
    
    // Sigmoid parts and their truncation.
    reg signed [(i-1)*2:(0-f)*2] sig3; reg signed [i-1:0-f] sig3t;
    reg signed [(i-1)*2:(0-f)*2] sig5; reg signed [i-1:0-f] sig5t;
    reg signed [(i-1)*2:(0-f)*2] sig7; reg signed [i-1:0-f] sig7t;
    reg signed [(i-1)*2:(0-f)*2] sig9; reg signed [i-1:0-f] sig9t;
    
    // Truncation stored in a variable is necessary to maintain SIGNED. 
    
    // Sigmoid using first 10 of its Maclaurin series
    // 1/2 + x/4 - x^3/48 + x^5/480 - 17x^7/80640 + 31x^9/1451520
    
    // Represented, hardcoded for fixed-point 24
    // Using multiplication against constant since shifting would result in zero.
    // Constant division representation obtained from ex: 17/80640 * 2^24 rounded.  
    begin
      x_2 = x * x;        x_2t = x_2[i-1:0-f];  // Calculate then truncate
      x_3 = x_2t * x;     x_3t = x_3[i-1:0-f];
      x_5 = x_3t * x_2t;  x_5t = x_5[i-1:0-f];
      x_7 = x_5t * x_2t;  x_7t = x_7[i-1:0-f];
      x_9 = x_7t * x_2t;  x_9t = x_9[i-1:0-f];
      
      sig3 = x_3t * 32'sd349525;  sig3t = sig3[i-1:0-f];
      sig5 = x_5t * 32'sd34952;   sig5t = sig5[i-1:0-f];
      sig7 = x_7t * 32'sd3536;    sig7t = sig7[i-1:0-f];
      sig9 = x_9t * 32'sd358;     sig9t = sig9[i-1:0-f];
      
//      $display("%f %f %f %f %f %f | %f %f %f %f", 
//        x * 2.0**-f, x_2t * 2.0**-f, x_3t * 2.0**-f, x_5t * 2.0**-f, x_7t * 2.0**-f, x_9t * 2.0**-f,
//        sig3t * 2.0**-f, sig5t * 2.0**-f, sig7t * 2.0**-f, sig9t * 2.0**-f);
//      $display();
      
      // 2.5 upper limit and -2.5 lower limit
      if (x > (32'sd5 << (f-1))) sigmoid = 32'h1 << f;
      else if (x < (-32'sd5 << (f-1))) sigmoid = 32'h0;
      else sigmoid = (32'sh1 << (f-1)) + (x >>> 2) - sig3t + sig5t - sig7t + sig9t;
//      else sigmoid = (32'sh1 << (f-1)) + (x >>> 2) - (x_3t * 32'sd349525) + (x_5t * 32'sd34952) - ((32'sd17 << f) * x_7t * 32'sd208) + ((32'sd31 << f) * x_9t * 32'sd12);
//      else sigmoid = (32'sh1 << (f-1)) + (x >>> 2) - (x_3t >>> 24) + (x_5t >>> 240) - ((32'sd17 << f)*x_7t >>> 40320) + ((32'sd31 << f)*x_9t >>> 725760);
//      else sigmoid = (32'sh1 << 23) + (x >>> 2) - (x**3 >>> 24) + (x**5 >>> 240) - (32'sd17 << 24)*(x**7 >>> 40320) + (32'sd31 << 24)*(x**9 >>> 725760);
    end
  endfunction
  
  function [i-1:0-f] linear;
    input signed [i-1:0-f] x;
    begin
      // 2 upper limit and 0 lower limit
      if (x >= (32'sd2 << f)) linear = 32'h1 << f;
      else if (x <= 32'sd0) linear = 32'h0;
      else linear = x * (32'sb1 << (f-1));  // Divide by two
    end
  endfunction
  
  function [i-1:0-f] test;
    input signed [i-1:0-f] x;
    begin
      test = 32'd3 << 24;
    end
  endfunction
  
endmodule