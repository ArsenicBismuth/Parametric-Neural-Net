// Output layer, just a wrapper.

`include "fixed_point.vh"

module layer_output(nx, ly);
  
  // Warning, parameter here is only the default value. 
  // Check the parent if there's any override.
  parameter sx = 3;   // Size of inputs (or nodes in prev layer)
  parameter sl = 2;   // Total node of layer
  parameter list = "rom.list";
  
  input signed [`n*sx-1:0] nx;  // Concatenation of sx amount of x    
  output signed [`n*sl-1:0] ly;  // Concatenation of sl amount of y
  
  // Single layer
//  layer #(sx, sl, list) lout(nx, ly);
  
endmodule
