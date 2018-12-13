// Top level and datapath of neural network.

`timescale 1ns / 1ps

`include "fixed_point.vh"

module neural(clk, rst, batch);
  
  parameter a = 32; // Address width
  localparam n = `n; // Bit
  localparam f = `f; // Fraction
  localparam i = `i; // Integer
  
  // Layer params
  parameter ltot = 3;   // Total of layers, including input & output
  parameter [0:8*ltot-1] lr = {8'd2, 8'd3, 8'd2}; // Size of inputs, hidden layers, outputs. Access with lr[8*id + 8]
  
  localparam sx = lr[8*0 + 8];            // Size of inputs     
  localparam sl = lr[8*(ltot-1) + 8];     // Total node of last layer
  //  parameter sl1 = 3;
  //  parameter sl2 = 0;
  
  localparam nd = lr[8*1 + 8] + lr[8*2 + 8];       // Total all nodes
  localparam wt = lr[8*0 + 8]*lr[8*1 + 8] + lr[8*1 + 8]*lr[8*2 + 8];  // Total all weights
  
  input clk, rst;
  input [n-1:0] batch;  // Number of data each iteration
  
  wire [n*sx-1:0] bus;  // Bus max width is sx*n, but some (like node) only use n.
  
  // Memory wires, see diagram or updated wrapper
  wire [a:0] x_addr;
  wire [a:0] y_addr;
  wire [a:0] t_addr;
  wire [n*sx-1:0] x_din, x_dout;
  wire [n*sl-1:0] y_din, y_dout;
  wire [n*sl-1:0] t_din, t_dout;
  
  wire [a:0] nd_addr;
  wire [n-1:0] nd_din, nd_dout;
  
  // Layer & backprop wires
  wire [n*sx-1:0] nx;  // Concatenation of sx amount of x    
  wire [n*sl-1:0] ly;  // Concatenation of sl amount of y
  wire [n*sl-1:0] lt;  // Concatenation of sl amount of t
  
  wire [n*nd-1:0] yall;
  wire [n*nd-1:0] wall;
  
  wire [n-1:0] cost;
  
  // Control signals (wires)
  wire [2:0] state;
  wire e_x, e_y, e_nd;  // Control signals for memory buffers
  wire [nd-1:0] we;     // Layer nodes coeffs, also one for backprop mode
  
  wire [7:0] x_we, y_we, t_we;
  wire [7:0] nd_we;
  
  wire [nd-1:0] bp_we;
  wire dtb;  // 0: bp_we enable writing to dff, 1: bp_we enable bus buffer
  
  // Buffers for bus inputs
//  assign bus = (e_x) ? x_dout : {n*sx{1'bz}}; // Directly to ai_top
  assign bus = (e_y) ? y_dout : {n*sx{1'bz}};
  assign bus = (e_nd) ? {{n*(sx-1){1'b0}}, nd_dout} : {n*sx{1'bz}};
  
  assign x_din = bus;
//  assign y_din = bus; // Directly from ai_top
  assign nd_din = bus;
  
  assign nx = x_dout;
  assign y_din = ly;
  assign lt = t_dout;
  
  // Modules
  control_unit #(sx, sl, nd, a) cu(clk, rst, batch, x_dout, nd_dout, x_addr, y_addr, t_addr, nd_addr, state, e_x, e_y, e_nd, we, x_we, y_we, nd_we, t_we, bp_we, dtb);
  ai_top #(ltot, lr, nd, wt) ai(clk, rst, we, bus, nx, ly, yall, wall);
  backprop #(ltot, lr, nd, wt) bp(clk, rst, batch, bp_we, dtb, bus, yall, wall, lt, cost);
  
  ram_wrapper ram_node
    (.BRAM_PORTA_addr(nd_addr),
    .BRAM_PORTA_clk(clk),
    .BRAM_PORTA_din(nd_din),
    .BRAM_PORTA_dout(nd_dout),
    .BRAM_PORTA_en(1'b1),
//    .BRAM_PORTA_en(nd_en),
    .BRAM_PORTA_rst(rst),
    .BRAM_PORTA_we(nd_we)//,
//    .BRAM_PORTB_addr(BRAM_PORTB_addr),
//    .BRAM_PORTB_clk(BRAM_PORTB_clk),
//    .BRAM_PORTB_din(BRAM_PORTB_din),
//    .BRAM_PORTB_dout(BRAM_PORTB_dout),
//    .BRAM_PORTB_en(BRAM_PORTB_en),
//    .BRAM_PORTB_rst(BRAM_PORTB_rst),
//    .BRAM_PORTB_we(BRAM_PORTB_we)
  );
  
  sbc_wrapper sbc_w
    (.BRAM_PORTA_addr(x_addr),
    .BRAM_PORTA_clk(clk),
    .BRAM_PORTA_din(x_din),
    .BRAM_PORTA_dout(x_dout),
    .BRAM_PORTA_en(1'b1),
    .BRAM_PORTA_rst(rst),
    .BRAM_PORTA_we(x_we),
    .BRAM_PORTA_1_addr(y_addr),
    .BRAM_PORTA_1_clk(clk),
    .BRAM_PORTA_1_din(y_din),
    .BRAM_PORTA_1_dout(y_dout),
    .BRAM_PORTA_1_en(1'b1),
    .BRAM_PORTA_1_rst(rst),
    .BRAM_PORTA_1_we(y_we),
//    .BRAM_PORTB_addr(BRAM_PORTB_addr),
//    .BRAM_PORTB_clk(BRAM_PORTB_clk),
//    .BRAM_PORTB_din(BRAM_PORTB_din),
//    .BRAM_PORTB_dout(BRAM_PORTB_dout),
//    .BRAM_PORTB_en(BRAM_PORTB_en),
//    .BRAM_PORTB_rst(BRAM_PORTB_rst),
//    .BRAM_PORTB_we(BRAM_PORTB_we),
    .BRAM_PORTB_1_addr(t_addr),
    .BRAM_PORTB_1_clk(clk),
    .BRAM_PORTB_1_din(t_din),
    .BRAM_PORTB_1_dout(t_dout),
    .BRAM_PORTB_1_en(1'b1),
    .BRAM_PORTB_1_rst(rst),
    .BRAM_PORTB_1_we(t_we)
  );
  
endmodule
