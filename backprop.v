// Top level design of Neural Network

`include "fixed_point.vh"

module backprop(clk, rst, batch, we, dtb, bus, nx, yall, wall, lt, cost);

  parameter ltot = 99;
  parameter [32*ltot-1:0] lr = 99;
  parameter sx = 99;  // Size of inputs
  parameter sl1 = 99;  // Size of inputs
  parameter sl = 99;  // Total node of last layer
  
  parameter nd = 99;      // Total all nodes
  parameter wt = 99;      // Total all weights
//  parameter signed rate = 32'h199999;  //0.1
  
//  localparam sx =  lr[0*32 +: 32];      // Size of inputs
////  localparam sx =  2;      // Size of inputs
//  localparam sl1 = lr[1*32 +: 32];
////  localparam sl1 = 3;
//  localparam sl2 = 0;
//  localparam sl = lr[2*32 +: 32];      // Total node of last layer
//  localparam sl = 2;      // Total node of last layer
  
  localparam n = `n; // Bit
  localparam f = `f; // Fraction
  localparam i = `i; // Integer
  
  wire signed [n-1:0] rate;
  assign rate = 32'h199999; 
//  assign rate = 32'h1999; 
  
  integer j, k, m, o;
  
  input clk, rst;
  input signed [n-1:0] batch;
  input [wt+nd-1:0] we;   // Control dff & buffer for each constant
  input dtb;              // 0: we enable writing to dff, 1: we enable bus buffer
  inout [2*n-1:0] bus;
  input [n*sx-1:0] nx;
  input [n*nd-1:0] yall;
  input [n*wt-1:0] wall;
  input [n*sl-1:0] lt;
  output signed [i:-f] cost;  // Real register
    
  // Connections (not registers)
  reg signed [i:-f] x [0:sx-1];  // Separated yall into array of sx x
  reg signed [i:-f] y [0:nd-1];  // Separated yall into array of nd y
  reg signed [i:-f] w [0:wt-1];  // Separated wall into array of wt w
  reg signed [i:-f] t [0:sl-1];  // Separated lt into array of sl t
  
  // Separating inputs. Parallel.
  always @(*) begin
    for (j=0; j<sx; j=j+1) begin
      // LSBs (right) are the frontmost layers (left).
      // Layer defines the LSBs as the first data (top node).
      // [a +: b] means a offset with b width
      x[j] <= nx[j*n +: n];
    end
    
    for (j=0; j<nd; j=j+1) begin
      // n LSBs are the first data
      y[j] <= yall[j*n +: n];
    end
    
    for (j=0; j<wt; j=j+1) begin
      // n LSBs are the first data
      w[j] <= wall[j*n +: n];
    end
    
    for (j=0; j<sl; j=j+1) begin
      // n LSBs are the first data
      t[j] <= lt[j*n +: n];
    end
  end
  
  // Cost function
  // Some use 2*n size since operation performed in n-bit
  reg signed [i:-f] sub [0:sl-1];  // Subtraction
  reg signed [i*2+1:(-f)*2] sq_t [0:sl-1]; // Square
  reg signed [i:-f] sq [0:sl-1];           // Square truncated
  reg signed [i:-f] sum;              // Summation
  wire signed [i:-f] cn;
  wire e_cost;
//  wire signed [i*2+1:(-f)*2] div;     // Divided
  
  always @(*) begin
    sum = {n{1'b0}};  
    for (j=0; j<sl; j=j+1) begin
      sub[j] = y[nd-sl+j] - t[j]; 
      sq_t[j] = sub[j] * sub[j];
      sq[j] = sq_t[j][i:-f];
      sum = sum + sq[j]; 
    end 
  end
  
  //  assign div = sum / (sl << f);
  assign cn = sum >> (sl/2); // Output must be multiple of 2
  //  assign cn = div[i:-f];
  
  // Cost calculation, reset on rst or during saving data to memory
  assign e_cost = we[wt+nd-1] & we[0];                                  // WARNING, ugly 
  dff dcost(clk, (rst | dtb), e_cost, cost + cn, cost);
  
  always @(posedge dtb) begin
    $display("cost=%.4f", (cost + cn) * 2.0**-f); // Because the last cn is yet to be sum
  end
  
  // Error
  reg signed [i*2+1:(-f)*2] y_der_t [0:nd-1];  // Derivate
  reg signed [i:-f] y_der [0:nd-1];            // Derivate truncated
  reg signed [i*2+1:(-f)*2] errw_t [0:wt-sx*sl1-1];   // Error times weight (every node except input)
  reg signed [i:-f] errw [0:wt-sx*sl1-1];             // Error times weight truncated
  reg signed [i:-f] errw_sum [0:nd-sl-1];      // Error times sum (every node except output (and input, already excluded in nd))
  reg signed [i*2+1:(-f)*2] err_t [0:nd-1];    // Error
  reg signed [i:-f] err [0:nd-1];      // Error truncated
  
  // Delta
  reg signed [i*2+1:(-f)*2] ea_t [0:wt-1];  // Error times node outputs
  reg signed [i:-f] ea [0:wt-1];    // Truncated
  wire signed [i:-f] deas [0:wt-1]; // Dff output
  reg signed [i:-f] eas [0:wt-1];   // Summed
  reg signed [i*2+1:(-f)*2] dw_t [0:wt-1];  // Times rate
  reg signed [i:-f] dw [0:wt-1];    // Truncated
  
  wire signed [i:-f] des [0:nd-1];  // Dff output
  reg signed [i:-f] es [0:nd-1];    // Error summed
  reg signed [i*2+1:(-f)*2] dd_t [0:nd-1];  // Times rate
  reg signed [i:-f] dd [0:nd-1];    // Truncated
  
  // Modules
  // Weight delta. Parallel
  genvar r;
  generate
    for (r=0; r<wt; r=r+1) begin : wei
      dff cw(clk, rst, (~dtb && we[r]), eas[r], deas[r]);
    end
  endgenerate
  
  // Bias delta. Parallel
  generate
    for (r=0; r<nd; r=r+1) begin : bias
      dff cb(clk, rst, (~dtb && we[r+wt]), es[r], des[r]);
    end
  endgenerate
  
  always @(*) begin
  
    //// Error calcs
    
    // Activation derivatives
    for (j=0; j<nd; j=j+1) begin
      y_der_t[j] <= (({{2*n{1'sb0}}, 1'sb1} << f) - y[j]) * y[j]; // Sigmoid, (1-a)*a
//      y_der_t[j] = y[j] >= {n{1'b0}} ? ({{2*n{1'b0}}, 1'b1} << 2*f) : {2*n{1'b0}}; // ReLu, step
//      y_der_t[j] = ({{2*n{1'b0}}, 1'b1} << 2*f);  // Linear, 1
      y_der[j] <= y_der_t[j][i:-f];      
    end
  
    // Output layer
    // Start from MSB, the end of the end
    for (j=nd-1; j>=nd-sl; j=j-1) begin
       err_t[j] = sub[j-sl1] * y_der[j];  // Sub is only sl-width
       err[j] = err_t[j][i:-f];
       
//       $display("Error-3: %f", err[j] * 2.0**-f);
    end
    
    // Hidden layers
    // For every layer, must manually create a new loop
    
    // J moving backward, for every node in this layer
    for (j=nd-sl-1; j>=nd-sl-sl1; j=j-1) begin
    
      // K moving forward, for every node in prev layer
      errw_sum[j] = {n{1'b0}};
      for (k=0; k<sl; k=k+1) begin
        m = nd - sl + k;  // Index of the previous layer error
        o = j*sl + k;     // Index of the weight
        errw_t[o] = err[m];
        errw[o] = errw_t[o][i:-f];
        errw_sum[j] = errw_sum[j] + errw[o];  
      end
      
      err_t[j] = errw_sum[j] * y_der[j];
      err[j] = err_t[j][i:-f];
        
//      $display("Error-2: %f", err[j] * 2.0**-f);
    end
    
    //// New value calcs
    
    // New weight calc
    // J moving forward, for every node in this layer (input)
    for (j=0; j<sx; j=j+1) begin
      // K moving forward, for every node in next layer (hidden-1)
      for (k=0; k<sl1; k=k+1) begin
        o = j*sl1 + k;     // Index of the weight
        ea_t[o] = err[k] * x[j];
        ea[o] = ea_t[o][i:-f];
        eas[o] = deas[o] + ea[o];
        dw_t[o] = rate * eas[o];
        dw[o] = dw_t[o][i:-f]; 
      end
    end
    
    for (j=sx; j<sx+sl1; j=j+1) begin
      for (k=0; k<sl; k=k+1) begin
        o = sx + j*sl + k;     // Index of the weight
        ea_t[o] = err[k+sl1] * y[j-sx];
        ea[o] = ea_t[o][i:-f];
        eas[o] = deas[o] + ea[o];
        dw_t[o] = rate * deas[o];
        dw[o] = dw_t[o][i:-f];
      end
    end
  
    // New bias calc
    for (j=0; j<nd; j=j+1) begin
      es[j] = des[j] + err[j];
      dd_t[j] = rate * des[j];
      dd[j] = dd_t[j][i:-f];
    end
    
    // Buffer to bus
    
//    for (j=0; j<wt; j=j+1) begin
//      if (dtb && we[j]) bus = eas[o]
//      else
//    end
    
  end
  
  // So, basically, bias is represented in negative for the formula in LSICon
  // Thus adding to bias means it's more negative.
  assign bus = dtb && we[16] ? w[0] - dw[0] : {2*n{1'bz}};
  assign bus = dtb && we[15] ? w[1] - dw[1] : {2*n{1'bz}};
  assign bus = dtb && we[14] ? (-1'b1 << f) - dd[0] : {2*n{1'bz}};
  assign bus = dtb && we[13] ? w[2] - dw[2] : {2*n{1'bz}};
  assign bus = dtb && we[12] ? w[3] - dw[3] : {2*n{1'bz}};
  assign bus = dtb && we[11] ? (-1'b1 << f) - dd[1] : {2*n{1'bz}};
  assign bus = dtb && we[10] ? w[4] - dw[4] : {2*n{1'bz}};
  assign bus = dtb && we[9] ? w[5] - dw[5] : {2*n{1'bz}};
  assign bus = dtb && we[8] ? (-1'b1 << f) - dd[2] : {2*n{1'bz}};
  assign bus = dtb && we[7] ? w[6] - dw[6] : {2*n{1'bz}};
  assign bus = dtb && we[6] ? w[7] - dw[7] : {2*n{1'bz}};
  assign bus = dtb && we[5] ? w[8] - dw[8] : {2*n{1'bz}};
  assign bus = dtb && we[4] ? (-1'b1 << f) - dd[3] : {2*n{1'bz}};
  assign bus = dtb && we[3] ? w[9] - dw[9] : {2*n{1'bz}};
  assign bus = dtb && we[2] ? w[10] - dw[10] : {2*n{1'bz}};
  assign bus = dtb && we[1] ? w[11] - dw[11] : {2*n{1'bz}};
  assign bus = dtb && we[0] ? (-1'b1 << f) - dd[4] : {2*n{1'bz}};
    
endmodule