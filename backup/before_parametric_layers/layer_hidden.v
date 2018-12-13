// Hidden layer, may contains multiple layers.

`include "fixed_point.vh"

module layer_hidden(nx, ly);
  
  // Warning, parameter here is only the default value. 
  // Check the parent if there's any override.
  parameter sx = 3;   // Size of inputs (or nodes in prev layer)
  parameter sl = 2;   // Total node of last layer
  parameter list = "rom.list";
  
  input signed [`n*sx-1:0] nx;  // Concatenation of sx amount of first x    
  output signed [`n*sl-1:0] ly;  // Concatenation of sl amount of last y
  
//  // Multi layer, configured here.
//  // The second parameter (input count) must be equal 
//  // to the second parameter (node count) of prev layer.
//  parameter sl1 = 4;
//  parameter sl2 = 4;
  
  // Layering
  // sx | sl-1 ... sl-n | sl
  
//  wire signed [`n*sl1-1:0] ly1;  // Concatenation of sl amount of y1
//  wire signed [`n*sl2-1:0] ly2;  // Concatenation of sl amount of y2
  
//  layer #(sx, sl1, "lay_hid1.list") lhid1(nx, ly1);
//  layer #(sl1, sl2, "lay_hid2.list") lhid2(ly1, ly2);
//  layer #(sl2, sl, "lay_hid3.list") lhid3(ly2, ly);
  
endmodule
