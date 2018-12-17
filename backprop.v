// Top level design of Neural Network

`include "fixed_point.vh"

module backprop(clk, rst, batch, we, dtb, bus, nx, yall, wall, ball, lt, cost);

  parameter ltot = 99;
  parameter [32*ltot-1:0] lr = 99;
  parameter sx = 99;  // Size of inputs
  parameter sl1 = 99;  // Size of inputs
  parameter sl2 = 99;  // Size of inputs
  parameter sl = 99;  // Total node of last layer
  
  parameter nd = 99;      // Total all nodes
  parameter wt = 99;      // Total all weights
//  parameter signed rate = 32'h199999;  //0.1
  
//  localparam sx = lr[0*32 +: 32];      // Size of inputs
//  localparam sl1 = lr[1*32 +: 32];
//  localparam sl2 = 0;
//  localparam sl = lr[2*32 +: 32];      // Total node of last layer
  
  localparam n = `n; // Bit
  localparam f = `f; // Fraction
  localparam i = `i; // Integer
  
  wire signed [n-1:0] rate;
//  assign rate = 32'h199999; // 0,1 
  assign rate = 32'h4189; // 0,001 
//  assign rate = 32'h1999; 
  
  integer j, k, m, o, p;
  
  input clk, rst;
  input signed [n-1:0] batch;
  input [wt+nd-1:0] we;   // Control dff & buffer for each constant
  input dtb;              // 0: we enable writing to dff, 1: we enable bus buffer
  inout [2*n-1:0] bus;
  input [n*sx-1:0] nx;
  input [n*nd-1:0] yall;
  input [n*wt-1:0] wall;
  input [n*nd-1:0] ball;
  input [n*sl-1:0] lt;
  output signed [i:-f] cost;  // Real register
    
  // Connections (not registers)
  reg signed [i:-f] x [0:sx-1];  // Separated yall into array of sx x
  reg signed [i:-f] y [0:nd-1];  // Separated yall into array of nd y
  reg signed [i:-f] w [0:wt-1];  // Separated wall into array of wt w
  reg signed [i:-f] b [0:nd-1];  // Separated ball into array of nd b
  reg signed [i:-f] t [0:sl-1];  // Separated lt into array of sl t
  
  // Separating inputs. Parallel.
  always @(*) begin
    for (j=0; j<sx; j=j+1) begin
      // LSBs (right) are the frontmost layers (left).
      // Layer defines the LSBs as the first data (top node).
      // [a +: b] means a offset with b width
      x[j] <= nx[j*n +: n];
    end
    
    // n LSBs are the first data
    for (j=0; j<nd; j=j+1) y[j] <= yall[j*n +: n];
    for (j=0; j<wt; j=j+1) w[j] <= wall[j*n +: n];
    for (j=0; j<nd; j=j+1) b[j] <= ball[j*n +: n];
    for (j=0; j<sl; j=j+1) t[j] <= lt[j*n +: n];
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
    $display("cost=%.4f", cost * 2.0**-f); // Because the last cn is yet to be sum
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
//      y_der_t[j] <= (({{2*n{1'sb0}}, 1'sb1} << f) - y[j]) * y[j]; // Sigmoid, (1-a)*a
      y_der_t[j] = y[j] >= {n{1'b0}} ? ({{2*n{1'b0}}, 1'b1} << 2*f) : {2*n{1'b0}}; // ReLu, step
//      y_der_t[j] = ({{2*n{1'b0}}, 1'b1} << 2*f);  // Linear, 1
      y_der[j] <= y_der_t[j][i:-f];      
    end
  
    // Output layer
    // Start from MSB, the end of the end
    for (j=nd-1; j>=nd-sl; j=j-1) begin
       err_t[j] = sub[j-sl1-sl2] * y_der[j];  // Sub is only sl-width
       err[j] = err_t[j][i:-f];
//       $display("Error-3: %f", err[j] * 2.0**-f);
    end
    
    // Hidden layers
    // For every layer, must manually create a new loop
    
    // J moving forward, for every node in this layer
    for (j=sl1; j<sl1+sl2; j=j+1) begin
        
      // K moving forward, for every node in prev layer
      errw_sum[j] = {n{1'b0}};
      for (k=0; k<sl; k=k+1) begin
        m = nd - sl + k;   // Index of the previous layer error
        o = sx*sl1 + sl1*sl2 + (j-sl1) + k*(sl1+1); // Index of the weight
        p = j*sl + k;              // Current, relative weight
        errw_t[p] = err[m] * w[o];
        errw[p] = errw_t[p][i:-f];
        errw_sum[j] = errw_sum[j] + errw[p];  
      end
      
      err_t[j] = errw_sum[j] * y_der[j];
      err[j] = err_t[j][i:-f];
        
//      $display("Error-2: %f", err[j] * 2.0**-f);
    end
    
    for (j=0; j<sl1; j=j+1) begin
    
      // K moving forward, for every node in prev layer
      errw_sum[j] = {n{1'b0}};
      for (k=0; k<sl2; k=k+1) begin
        m = nd - sl - sl2 + k;   // Index of the previous layer error
        o = sx*sl1 + j + k*(sx+1); // Index of the weight
        p = j*sl2 + k;              // Current, relative weight
        errw_t[p] = err[m] * w[o];
        errw[p] = errw_t[p][i:-f];
        errw_sum[j] = errw_sum[j] + errw[p];  
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
        o = 0 + j + k*(sx);     // Index of the weight
        ea_t[o] = err[k] * x[j];
        ea[o] = ea_t[o][i:-f];
        eas[o] = deas[o] + ea[o];
        
        dw_t[o] = rate * deas[o];
        dw[o] = dw_t[o][i:-f]; 
      end
    end
    
    for (j=0; j<sl1; j=j+1) begin
      // K moving forward, for every node in next layer (hidden-1)
      for (k=0; k<sl2; k=k+1) begin
        o = sx*sl1 + j + k*(sl1);     // Index of the weight
        ea_t[o] = err[k+sl1] * y[j];
        ea[o] = ea_t[o][i:-f];
        eas[o] = deas[o] + ea[o];
        
        dw_t[o] = rate * deas[o];
        dw[o] = dw_t[o][i:-f]; 
//        dw[o] = {o[7:0], k[3:0], j[3:0]}; 
      end
    end
    
    for (j=0; j<sl2; j=j+1) begin
      for (k=0; k<sl; k=k+1) begin
        o = sx*sl1 + sl1*sl2 + j + k*(sl2);     // Index of the weight
        ea_t[o] = err[k+sl1+sl2] * y[j+sl1];
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
//    k = 0; m = 0; o = 0;
//    for (j=0; j<(sx+1)*sl1; j=j+1) begin
//      if ((j+1) % (sx+1) != 0) begin
//        bus <= dtb && we[k] ? w[m] - dw[m] : {2*n{1'bz}};
//        m = m + 1;
//        k = k + 1;
//      end else begin
//        bus <= dtb && we[k] ? b[o] - dd[o] : {2*n{1'bz}};
//        o = o + 1;
//        k = k + 1;
//      end
//    end
    
//    for (j=0; j<(sl1+1)*sl2; j=j+1) begin
//      if ((j+1) % (sl1+1) != 0) begin
//        bus = dtb && we[k] ? w[m] - dw[m] : {2*n{1'bz}};
//        m = m + 1;
//        k = k + 1;
//      end else begin
//        bus = dtb && we[k] ? b[o] - dd[o] : {2*n{1'bz}};
//        o = o + 1;
//        k = k + 1;
//      end
//    end
    
//    for (j=0; j<(sl2+1)*sl; j=j+1) begin
//      if ((j+1) % (sl2+1) != 0) begin
//        bus = dtb && we[k] ? w[m] - dw[m] : {2*n{1'bz}};
//        m = m + 1;
//        k = k + 1;
//      end else begin
//        bus = dtb && we[k] ? b[o] - dd[o] : {2*n{1'bz}};
//        o = o + 1;
//        k = k + 1;
//      end
//    end
    
  end
  
  // So, basically, bias is represented in negative for the formula in LSICon
  // Thus adding to bias means it's more negative.
  
  // Created using a C program: https://ideone.com/QvFwRf
  
  assign bus = dtb && we[0] ? w[0] - dw[0] : {2*n{1'bz}};
  assign bus = dtb && we[1] ? w[1] - dw[1] : {2*n{1'bz}};
  assign bus = dtb && we[2] ? w[2] - dw[2] : {2*n{1'bz}};
  assign bus = dtb && we[3] ? w[3] - dw[3] : {2*n{1'bz}};
  assign bus = dtb && we[4] ? w[4] - dw[4] : {2*n{1'bz}};
  assign bus = dtb && we[5] ? b[0] - dd[0] : {2*n{1'bz}};
  assign bus = dtb && we[6] ? w[5] - dw[5] : {2*n{1'bz}};
  assign bus = dtb && we[7] ? w[6] - dw[6] : {2*n{1'bz}};
  assign bus = dtb && we[8] ? w[7] - dw[7] : {2*n{1'bz}};
  assign bus = dtb && we[9] ? w[8] - dw[8] : {2*n{1'bz}};
  assign bus = dtb && we[10] ? w[9] - dw[9] : {2*n{1'bz}};
  assign bus = dtb && we[11] ? b[1] - dd[1] : {2*n{1'bz}};
  assign bus = dtb && we[12] ? w[10] - dw[10] : {2*n{1'bz}};
  assign bus = dtb && we[13] ? w[11] - dw[11] : {2*n{1'bz}};
  assign bus = dtb && we[14] ? w[12] - dw[12] : {2*n{1'bz}};
  assign bus = dtb && we[15] ? w[13] - dw[13] : {2*n{1'bz}};
  assign bus = dtb && we[16] ? w[14] - dw[14] : {2*n{1'bz}};
  assign bus = dtb && we[17] ? b[2] - dd[2] : {2*n{1'bz}};
  assign bus = dtb && we[18] ? w[15] - dw[15] : {2*n{1'bz}};
  assign bus = dtb && we[19] ? w[16] - dw[16] : {2*n{1'bz}};
  assign bus = dtb && we[20] ? w[17] - dw[17] : {2*n{1'bz}};
  assign bus = dtb && we[21] ? w[18] - dw[18] : {2*n{1'bz}};
  assign bus = dtb && we[22] ? w[19] - dw[19] : {2*n{1'bz}};
  assign bus = dtb && we[23] ? b[3] - dd[3] : {2*n{1'bz}};
  assign bus = dtb && we[24] ? w[20] - dw[20] : {2*n{1'bz}};
  assign bus = dtb && we[25] ? w[21] - dw[21] : {2*n{1'bz}};
  assign bus = dtb && we[26] ? w[22] - dw[22] : {2*n{1'bz}};
  assign bus = dtb && we[27] ? w[23] - dw[23] : {2*n{1'bz}};
  assign bus = dtb && we[28] ? w[24] - dw[24] : {2*n{1'bz}};
  assign bus = dtb && we[29] ? b[4] - dd[4] : {2*n{1'bz}};
  assign bus = dtb && we[30] ? w[25] - dw[25] : {2*n{1'bz}};
  assign bus = dtb && we[31] ? w[26] - dw[26] : {2*n{1'bz}};
  assign bus = dtb && we[32] ? w[27] - dw[27] : {2*n{1'bz}};
  assign bus = dtb && we[33] ? w[28] - dw[28] : {2*n{1'bz}};
  assign bus = dtb && we[34] ? w[29] - dw[29] : {2*n{1'bz}};
  assign bus = dtb && we[35] ? b[5] - dd[5] : {2*n{1'bz}};
  assign bus = dtb && we[36] ? w[30] - dw[30] : {2*n{1'bz}};
  assign bus = dtb && we[37] ? w[31] - dw[31] : {2*n{1'bz}};
  assign bus = dtb && we[38] ? w[32] - dw[32] : {2*n{1'bz}};
  assign bus = dtb && we[39] ? w[33] - dw[33] : {2*n{1'bz}};
  assign bus = dtb && we[40] ? w[34] - dw[34] : {2*n{1'bz}};
  assign bus = dtb && we[41] ? b[6] - dd[6] : {2*n{1'bz}};
  
  assign bus = dtb && we[42] ? w[35] - dw[35] : {2*n{1'bz}};
  assign bus = dtb && we[43] ? w[36] - dw[36] : {2*n{1'bz}};
  assign bus = dtb && we[44] ? w[37] - dw[37] : {2*n{1'bz}};
  assign bus = dtb && we[45] ? w[38] - dw[38] : {2*n{1'bz}};
  assign bus = dtb && we[46] ? w[39] - dw[39] : {2*n{1'bz}};
  assign bus = dtb && we[47] ? w[40] - dw[40] : {2*n{1'bz}};
  assign bus = dtb && we[48] ? w[41] - dw[41] : {2*n{1'bz}};
  assign bus = dtb && we[49] ? b[7] - dd[7] : {2*n{1'bz}};
  assign bus = dtb && we[50] ? w[42] - dw[42] : {2*n{1'bz}};
  assign bus = dtb && we[51] ? w[43] - dw[43] : {2*n{1'bz}};
  assign bus = dtb && we[52] ? w[44] - dw[44] : {2*n{1'bz}};
  assign bus = dtb && we[53] ? w[45] - dw[45] : {2*n{1'bz}};
  assign bus = dtb && we[54] ? w[46] - dw[46] : {2*n{1'bz}};
  assign bus = dtb && we[55] ? w[47] - dw[47] : {2*n{1'bz}};
  assign bus = dtb && we[56] ? w[48] - dw[48] : {2*n{1'bz}};
  assign bus = dtb && we[57] ? b[8] - dd[8] : {2*n{1'bz}};
  assign bus = dtb && we[58] ? w[49] - dw[49] : {2*n{1'bz}};
  assign bus = dtb && we[59] ? w[50] - dw[50] : {2*n{1'bz}};
  assign bus = dtb && we[60] ? w[51] - dw[51] : {2*n{1'bz}};
  assign bus = dtb && we[61] ? w[52] - dw[52] : {2*n{1'bz}};
  assign bus = dtb && we[62] ? w[53] - dw[53] : {2*n{1'bz}};
  assign bus = dtb && we[63] ? w[54] - dw[54] : {2*n{1'bz}};
  assign bus = dtb && we[64] ? w[55] - dw[55] : {2*n{1'bz}};
  assign bus = dtb && we[65] ? b[9] - dd[9] : {2*n{1'bz}};
  assign bus = dtb && we[66] ? w[56] - dw[56] : {2*n{1'bz}};
  assign bus = dtb && we[67] ? w[57] - dw[57] : {2*n{1'bz}};
  assign bus = dtb && we[68] ? w[58] - dw[58] : {2*n{1'bz}};
  assign bus = dtb && we[69] ? w[59] - dw[59] : {2*n{1'bz}};
  assign bus = dtb && we[70] ? w[60] - dw[60] : {2*n{1'bz}};
  assign bus = dtb && we[71] ? w[61] - dw[61] : {2*n{1'bz}};
  assign bus = dtb && we[72] ? w[62] - dw[62] : {2*n{1'bz}};
  assign bus = dtb && we[73] ? b[10] - dd[10] : {2*n{1'bz}};
  assign bus = dtb && we[74] ? w[63] - dw[63] : {2*n{1'bz}};
  assign bus = dtb && we[75] ? w[64] - dw[64] : {2*n{1'bz}};
  assign bus = dtb && we[76] ? w[65] - dw[65] : {2*n{1'bz}};
  assign bus = dtb && we[77] ? w[66] - dw[66] : {2*n{1'bz}};
  assign bus = dtb && we[78] ? w[67] - dw[67] : {2*n{1'bz}};
  assign bus = dtb && we[79] ? w[68] - dw[68] : {2*n{1'bz}};
  assign bus = dtb && we[80] ? w[69] - dw[69] : {2*n{1'bz}};
  assign bus = dtb && we[81] ? b[11] - dd[11] : {2*n{1'bz}};
  assign bus = dtb && we[82] ? w[70] - dw[70] : {2*n{1'bz}};
  assign bus = dtb && we[83] ? w[71] - dw[71] : {2*n{1'bz}};
  assign bus = dtb && we[84] ? w[72] - dw[72] : {2*n{1'bz}};
  assign bus = dtb && we[85] ? w[73] - dw[73] : {2*n{1'bz}};
  assign bus = dtb && we[86] ? w[74] - dw[74] : {2*n{1'bz}};
  assign bus = dtb && we[87] ? w[75] - dw[75] : {2*n{1'bz}};
  assign bus = dtb && we[88] ? w[76] - dw[76] : {2*n{1'bz}};
  assign bus = dtb && we[89] ? b[12] - dd[12] : {2*n{1'bz}};
  assign bus = dtb && we[90] ? w[77] - dw[77] : {2*n{1'bz}};
  assign bus = dtb && we[91] ? w[78] - dw[78] : {2*n{1'bz}};
  assign bus = dtb && we[92] ? w[79] - dw[79] : {2*n{1'bz}};
  assign bus = dtb && we[93] ? w[80] - dw[80] : {2*n{1'bz}};
  assign bus = dtb && we[94] ? w[81] - dw[81] : {2*n{1'bz}};
  assign bus = dtb && we[95] ? w[82] - dw[82] : {2*n{1'bz}};
  assign bus = dtb && we[96] ? w[83] - dw[83] : {2*n{1'bz}};
  assign bus = dtb && we[97] ? b[13] - dd[13] : {2*n{1'bz}};
  
  assign bus = dtb && we[98] ? w[84] - dw[84] : {2*n{1'bz}};
  assign bus = dtb && we[99] ? w[85] - dw[85] : {2*n{1'bz}};
  assign bus = dtb && we[100] ? w[86] - dw[86] : {2*n{1'bz}};
  assign bus = dtb && we[101] ? w[87] - dw[87] : {2*n{1'bz}};
  assign bus = dtb && we[102] ? w[88] - dw[88] : {2*n{1'bz}};
  assign bus = dtb && we[103] ? w[89] - dw[89] : {2*n{1'bz}};
  assign bus = dtb && we[104] ? w[90] - dw[90] : {2*n{1'bz}};
  assign bus = dtb && we[105] ? b[14] - dd[14] : {2*n{1'bz}};
  
//  assign bus = dtb && we[0] ? w[0] - dw[0] : {2*n{1'bz}};
//  assign bus = dtb && we[1] ? w[1] - dw[1] : {2*n{1'bz}};
//  assign bus = dtb && we[2] ? b[0] - dd[0] : {2*n{1'bz}};
//  assign bus = dtb && we[3] ? w[2] - dw[2] : {2*n{1'bz}};
//  assign bus = dtb && we[4] ? w[3] - dw[3] : {2*n{1'bz}};
//  assign bus = dtb && we[5] ? b[1] - dd[1] : {2*n{1'bz}};
//  assign bus = dtb && we[6] ? w[4] - dw[4] : {2*n{1'bz}};
//  assign bus = dtb && we[7] ? w[5] - dw[5] : {2*n{1'bz}};
//  assign bus = dtb && we[8] ? b[2] - dd[2] : {2*n{1'bz}};
  
//  assign bus = dtb && we[9] ? w[6] - dw[6] : {2*n{1'bz}};
//  assign bus = dtb && we[10] ? w[7] - dw[7] : {2*n{1'bz}};
//  assign bus = dtb && we[11] ? w[8] - dw[8] : {2*n{1'bz}};
//  assign bus = dtb && we[12] ? b[3] - dd[3] : {2*n{1'bz}};
//  assign bus = dtb && we[13] ? w[9] - dw[9] : {2*n{1'bz}};
//  assign bus = dtb && we[14] ? w[10] - dw[10] : {2*n{1'bz}};
//  assign bus = dtb && we[15] ? w[11] - dw[11] : {2*n{1'bz}};
//  assign bus = dtb && we[16] ? b[4] - dd[4] : {2*n{1'bz}};
    
    
    
endmodule