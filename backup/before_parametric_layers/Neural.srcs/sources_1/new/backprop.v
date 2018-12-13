// Top level design of Neural Network

`include "fixed_point.vh"

module backprop(clk, rst, batch, we, dtb, bus, yall, wall, lt, cost);

  parameter sx = 99;      // Size of inputs
  parameter sl1 = 99;
  parameter sl2 = 99;
  parameter sl = 99;      // Total node of last layer
  parameter nd = 99;      // Total all nodes
  parameter wt = 99;      // Total all weights
  
  localparam n = `n; // Bit
  localparam f = `f; // Fraction
  localparam i = `i; // Integer
  
  integer j, k;
  
  input clk, rst;
  input signed [n-1:0] batch;
  input [nd-1:0] we;      // Control dff & buffer for each backprop node
  input dtb;              // 0: we enable writing to dff, 1: we enable bus buffer
  inout [n-1:0] bus;
  input [n*nd-1:0] yall;
  input [n*wt-1:0] wall;
  input [n*sl-1:0] lt;
  output reg signed [i-1:0-f] cost;
  
  // Connections (not registers)
  reg signed [i-1:0-f] y [0:nd-1];  // Separated yall into array of nd y
  reg signed [i-1:0-f] w [0:nd-1];  // Separated wall into array of nd z
  reg signed [i-1:0-f] t [0:sl-1];  // Separated lt into array of sl t
  wire signed [i-1:0-f] c_p;        // Previous c
  
  // Separating inputs. Parallel.
  always @(*) begin
    for (j=0; j<nd; j=j+1) begin
      // LSBs (right) are the frontmost layers (left).
      // Layer defines the LSBs as the first data (top node).
      // [a +: b] means a offset with b width
      y[j] <= yall[j*n +: n];
    end
    
    for (j=0; j<sx*sl1 + sl1*sl; j=j+1) begin
      // n LSBs are the first data
      w[j] <= zall[j*n +: n];
    end
    
    for (j=0; j<sl; j=j+1) begin
      // n LSBs are the first data
      t[j] <= lt[j*n +: n];
    end
  end
  
  // Cost function
  // Some use 2*n size since operation performed in n-bit
  reg signed [i-1:0-f] sub [0:sl-1];  // Subtraction
  reg signed [(i-1)*2:(0-f)*2] sq_t [0:sl-1]; // Square
  reg signed [i-1:0-f] sq [0:sl-1];           // Square truncated
  reg signed [i-1:0-f] sum;          // Summation
  
  wire signed [(i-1)*2:(0-f)*2] div = sum / (batch << f);  // Divided
  wire signed [i-1:0-f] cn = div[i-1:0-f];  // Divided truncated
  
  always @(*) begin
  
    sum = {n{1'b0}};
    for (j=0; j<sl; j=j+1) begin
      sub[j] = y[nd-sl+j] - t[j]; 
      sq_t[j] = sub[j] * sub[j];
      sq[j] = sq_t[j][i-1:0-f];
      sum = sum + sq[j]; 
    end
    
    // Calculation for current batch is complete, sum
    cost = cost + cn; 
    
  end
  
  // Error
  reg signed [(i-1)*2:(0-f)*2] y_der_t [0:nd-1];  // Derivate
  reg signed [i-1:0-f] y_der [0:nd-1];            // Derivate truncated
  reg signed [(i-1)*2:(0-f)*2] errw_t [0:nd-1];   // Error times weight
  reg signed [i-1:0-f] errw [0:nd-1];   // Error times weight truncated
  reg signed [i-1:0-f] errw_sum [0:nd-1];   // Error times sum
  reg signed [(i-1)*2:(0-f)*2] err_t [0:nd-1];    // Error
  reg signed [i-1:0-f] err [0:nd-1];      // Error truncated
  
  always @(*) begin
    // Output layer
    for (j=nd-sl; j<nd; j=j+1) begin
       y_der_t[j] = (({{2*n{1'sb0}}, 1'sb1} << f) - y[j]) * y[j]; // Sigmoid, (1-a)*a
//       y_der_t[j] = y[j] >= {n{1'b0}} ? ({{2*n{1'b0}}, 1'b1} << 2*f) : {2*n{1'b0}}; // ReLu, step
       y_der[j] = y_der_t[j][i-1:0-f];
       err_t[j] = (y[j] - y[j]) * y_der[j];
       err[j] = err_t[j][i-1:0-f];
    end
    
    // Hidden layers
    // For every layers, must create a new loop
    for (j=nd-sl-sl1; j<nd-sl; j=j+1) begin
        y_der_t[j] = (({{2*n{1'sb0}}, 1'sb1} << f) - y[j]) * y[j]; // Sigmoid, (1-a)*a
//       y_der_t[j] = y[j] >= {n{1'b0}} ? ({{2*n{1'b0}}, 1'b1} << 2*f) : {2*n{1'b0}}; // ReLu, step
        y_der[j] = y_der_t[j][i-1:0-f];
        
        
        // Loop based on the layer after it
        for (k=nd-sl; k<nd; k=k+1) begin
          errw_t[
        end
        
        err_t[j] = (y[j] - y[j]) * y_der[j];
        err[j] = err_t[j][i-1:0-f];
    end
    
  end
  
  
  // Modules
  dff d_cn(clk, rst, 1'b1, cost, cost);
  
  // Weight & bias modules. Parallel
//  genvar m;
//  generate
//    for (m=0; m<nd; m=m+1) begin : nodes
//      dff coef(clk, rst, 1'b1, bus, c_p);
//    end
//  endgenerate
    
endmodule