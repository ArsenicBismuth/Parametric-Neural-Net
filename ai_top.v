// Top level design of Neural Network

`include "fixed_point.vh"

/* Hirearchy
 * > ai_top
 *   multiple layers
 *
 * > layer
 *   multiple nodes with their shift registers
 */

module ai_top(clk, rst, batch, we, bus, nx, ly, yall, wall, ball);

  parameter sx = 99;      // Size of inputs
  parameter sl1 = 99;
  parameter sl2 = 99;
  parameter sl = 99;      // Total node of last layer
  
  parameter nd = 99;      // Total all nodes
  parameter wt = 99;      // Total all weights
  
  localparam n = `n; // Bit
  
  input clk, rst;
  input [n-1:0] batch;
  input [nd-1:0] we;      // Control shift register of each node
  inout signed [2*n-1:0] bus;
  input [n*sx-1:0] nx;   // Concatenation of sx amount of x    
  
//  network #(sx, sl) net(nx, ly);
  
  // Network, every parameter can be configured here.
  
  // The second parameter (input count) must be equal to the second parameter (node count) of prev layer.
  
  // Layers, last (output using ly) is output layer. Rest are hidden layers.
  localparam up1 = nd-1;
  localparam dn1 = up1-sl1+1;
  // Concatenation of output, weights, and biases in this layer
  wire [n*sl1-1:0] ly1;
  wire [n*sx*sl1-1:0] lnw1;
  wire [n*sl1-1:0] lb1;
  layer #(sx, sl1) lhid1(clk, rst, we[up1:dn1], bus, nx, ly1, lnw1, lb1);
  
  localparam up2 = dn1-1;
  localparam dn2 = up2-sl2+1;
  // Concatenation of output, weights, and biases in this layer
  wire [n*sl2-1:0] ly2;
  wire [n*sl1*sl2-1:0] lnw2;
  wire [n*sl2-1:0] lb2;
  layer #(sl1, sl2) lhid2(clk, rst, we[up2:dn2], bus, ly1, ly2, lnw2, lb2);
  
  localparam up3 = dn2-1;
  localparam dn3 = up3-sl+1;
  // Concatenation of output, weights, and biases in this layer
  output [n*sl-1:0] ly;
  wire [n*sl2*sl-1:0] lnw;
  wire [n*sl-1:0] lb;
  layer #(sl2, sl) lout(clk, rst, we[up3:dn3], bus, ly2, ly, lnw, lb);
  
  // Wiring used for backprop
  // LSBs (right) are the frontmost layers (left).
  // Layer defines the LSBs as the first data (top node). 
  output [n*nd-1:0] yall; assign yall = {ly, ly2, ly1};
  output [n*wt-1:0] wall; assign wall = {lnw, lnw2, lnw1};
  output [n*nd-1:0] ball; assign ball = {lb, lb2, lb1};
    
endmodule