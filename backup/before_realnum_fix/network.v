// Network, combination of different layers

`include "fixed_point.vh"

module network(nx, ly);

  // Warning, parameter here is only the default value. 
  // Check the parent if there's any override.
  parameter sx = 5;     // Size of inputs, node of input layer
  parameter sl = 2;     // Total node of last layer
  
//  parameter slin = sx;   // Total node of input layer
  parameter slhid = 3;  // Total node of last hidden layer
  
  input signed [`n*sx-1:0] nx;  // Concatenation of sx amount of x    
  output signed [`n*sl-1:0] ly;  // Concatenation of sl amount of y
  
//  wire signed [`n*slin-1:0] lyin;
  wire signed [`n*slhid-1:0] lyhid;

//  layer_input #(sx, slin, "lay_in.list") layin(nx, lyin);       // Every parameter can be configured here.
//  layer_hidden #(slin, slhid) layhid(lyin, lyhid);              // Individual Layer must be manually configured.

  // Input layer IS the input, not the first layer.
//  layer_hidden #(sx, slhid) layhid(nx, lyhid);              // Individual Layer must be manually configured.
//  layer_output #(slhid, sl, "lay_out.list") layout(lyhid, ly);  // Every parameter can be configured here.
  
endmodule
