// Top level design of Neural Network

`include "fixed_point.vh"

/* Hirearchy
 * > ai_top
 *   multiple layers
 *
 * > layer
 *   multiple nodes with their shift registers
 */

module ai_top(clk, rst, batch, we, bus, nx, ly, yall, wall);

//  parameter sx = 99;      // Size of inputs
//  parameter sl1 = 99;
//  parameter sl2 = 99;
//  parameter sl = 99;      // Total node of last layer
  parameter ltot = 99;      // Total of layers, including input & output
  parameter [0:8*ltot-1] lr = 99; // Size of inputs, hidden layers, outputs. Access with lr[8*id + 8].
  parameter nd = 99;      // Total all nodes
  parameter wt = 99;      // Total all weights
  
  localparam sx = lr[8*0 + 8];      // Size of inputs
  localparam sl = lr[8*(ltot-1) + 8];     // Total node of last layer
  
  localparam n = `n; // Bit
  
  input clk, rst;
  input [n-1:0] batch;
  input [nd-1:0] we;      // Control shift register of each node
  input signed [n-1:0] bus;
  input [n*sx-1:0] nx;   // Concatenation of sx amount of x    
  
  // Network, every parameter can be configured here.
  // The second parameter (input count) must be equal to the second parameter (node count) of prev layer.
  // Layers, last (output using ly) is output layer. Rest are hidden layers.
  
  genvar k;
  generate
    for (k=0; k<ltot; k=k+1) begin : layers
      layer #(sx, sl1) lay(clk, rst, we[up[k]:dn[k]], bus, nx[k], nx[k+1], lw[k]);
    end
  endgenerate
  
  localparam up1 = nd-1;
  localparam dn1 = up1-sl1+1;
  wire [n*sl1-1:0] ly1;  // Concatenation of sl amount of y1
  wire [n*sx*sl1-1:0] lw1;  // Concatenation of sl amount of z1
  layer #(sx, sl1) lhid1(clk, rst, we[up1:dn1], bus, nx, ly1, lw1);
  
  localparam up2 = dn1-1;
  localparam dn2 = up2-sl2+1;
  output [n*sl-1:0] ly;  // Concatenation of sl amount of y
  wire [n*sl1*sl-1:0] lw;    // Concatenation of sl amount of z
  layer #(sl1, sl2) lhid2(clk, rst, we[up2:dn2], bus, ly1, ly, lw);
  
//  localparam up3 = dn2-1;
//  localparam dn3 = up3-sl+1;
//  output [n*sl-1:0] ly;  // Concatenation of sl amount of y
//  wire [n*sl-1:0] lz;    // Concatenation of sl amount of z
//  layer #(sl2, sl) lout(clk, rst, we[up3:dn3], bus, ly2, ly, lz);
  
  // Wiring used for backprop
  // LSBs (right) are the frontmost layers (left).
  // Layer defines the LSBs as the first data (top node). 
  output [n*nd-1:0] yall; assign yall = {ly, ly1};
  output [n*wt-1:0] wall; assign wall = {lw, lw1}; 
    
endmodule