// Control unit of neural network.

`timescale 1ns / 1ps

`include "fixed_point.vh"

module control_unit(clk, rst, batch, x_dout, nd_dout, x_addr, y_addr, t_addr, nd_addr, state, e_x, e_y, e_nd, we, x_we, y_we, nd_we, t_we, bp_we, dtb);
  
  parameter sx = 99;  // Size of inputs
  parameter sl = 99;  // Total node of last layer
  parameter nd = 99;  // Total node all layers
  
  parameter a = 99; // Address width
  
  // Below are params that will be set to signals later
  localparam max_epoch = 10;
  localparam mode = 2;  // 1 feedforward, 2 backprop
  
  localparam n = `n; // Bit
  localparam f = `f; // Fraction
  localparam i = `i; // Integer

  input clk, rst;
  input [n-1:0] batch;
  input [n*sx-1:0] x_dout;
  input [n-1:0] nd_dout;
  output reg [a:0] x_addr;
  output reg [a:0] y_addr;
  output reg [a:0] t_addr;
  output reg [a:0] nd_addr;
  
  // Control signals (wires)
  output reg [2:0] state;
  output reg e_x, e_y, e_nd;  // Control signals for memory buffers
  output reg [nd-1:0] we;        // Layer nodes coeffs
  
  output reg [7:0] x_we, y_we, t_we;
  output reg [7:0] nd_we;
  
  output reg [nd-1:0] bp_we;
  output reg dtb;  // 0: bp_we enable writing to dff, 1: bp_we enable bus buffer
  
  integer epoch;
  
  // Counters
  reg [n-1:0] data;
  dff d_batch(clk, rst, 1'b1, data, data);
  
  // Control unit
  always @(posedge clk or posedge rst) begin
    if (rst) begin
    
      // Reset
      state = 2'd0;
      we = {nd{1'b0}};
      e_x = 1'b0;
      e_y = 1'b0;
      e_nd = 1'b0;
      
      x_addr = {n{1'b0}};
      y_addr = {n{1'b0}};
      t_addr = {{n-4{1'b0}}, 4'd10};
      nd_addr = {n{1'b0}};
      
      data = {n{1'b0}};
      
      bp_we = {nd{1'b0}};
      dtb = 0;
      
    end else begin
      
      if (state == 2'd0)
      
        state = 2'd1;
        
      // Load data    
      else if (state == 2'd1) begin
        
        
        // Weights and biases
        e_nd = 1'b1;
              
        if (nd_dout == {{n-12{1'b0}}, 12'h888}) we = we >> 1;  // Next layer if reading 888 (non-frac)
        else if (nd_dout == {{n-12{1'b0}}, 12'h999}) begin   // Stop
          we = {nd{1'b0}};
          state =  mode;
        end else if (we == {nd{1'b0}}) we = 1'b1 << (nd-1);  // First hidden layer
        
        // Increment node address
        nd_addr = nd_addr + 1'd1;
      
      
      // Feedforward
      end else if (state == 2'd2) begin
      
      
        y_we = 1'b1;  // Write last output
        
        // Increment in out address
        if (x_dout != {{sx*n-12{1'b0}}, 12'h888}) begin   // Continue if not reading 888 (non-frac)
          x_addr = x_addr + 1'd1;
          y_addr = y_addr + 1'd1;
        end
        
        
      // Backpropagation  
      end else if (state == 2'd3) begin
      
        
        for (epoch=0; epoch<max_epoch; epoch=epoch+epoch) begin
          if (data < batch) begin
            
            y_we = 1'b1;  // Write last output
                  
            // Increment in out address
            if (x_dout != {{sx*n-12{1'b0}}, 12'h888}) begin   // Continue if not reading 888 (non-frac)
              x_addr = x_addr + 1'd1;
              y_addr = y_addr + 1'd1;
              t_addr = t_addr + 1'd1;
            end
            
            data = data + 1'd1;
            
          end else begin
          
            x_addr = 0;
            y_addr = 0;
            t_addr = 0;
            
            data = {n{1'b0}}; // Reset
                                  
          end
        end
        
      
      end
      
    end
  end
  
endmodule
