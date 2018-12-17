// Individual layer

`include "fixed_point.vh"

// TODO: Remove extra shift register (variable data) that contains

module layer(clk, rst, we, bus, nx, ly, lnw, lb);

  // Warning, parameter here is only the default value. 
  // Check the parent if there's any override.
  parameter sx = 99;   // Size of inputs (or nodes in prev layer)
  parameter sl = 99;   // Total node of layer
  
  localparam n = `n;   // Bit
  localparam f = `f;   // Fraction
  localparam i = `i;   // Integer
  
  integer j;
  
  input clk, rst;
  input [sl-1:0] we;              // Control shift register of each node
  inout signed [2*n-1:0] bus;
  input signed [n*sx-1:0] nx;   // Concatenation of sx amount of x

  // Connections (not registers)
  output reg signed [n*sl-1:0] ly;  // Concatenation of sl amount of a
  output reg signed [n*sx*sl-1:0] lnw;  // Concatenation of node amount of weights
  output reg signed [n*sl-1:0] lb;  // Concatenation of sl amount of biases
  
  // Parameter for each node, in array.
//  wire signed [n*(sx+1+1)-1:0] data [0:sl-1];  // Data for each node, {end, b, nw}. FIX THE LOADING MECHANISM SO THAT THIS ISN'T NECESSARY
  wire signed [n*(sx+1)-1:0] data [0:sl-1];  // Data for each node, {b, nw}.
  reg signed [n*sx-1:0] nw [0:sl-1]; // Array of sl nw
  reg signed [i:-f] b [0:sl-1];   // Array of sl b
  wire signed [i:-f] y [0:sl-1];   // Array of sl y.
  wire signed [i:-f] z [0:sl-1];   // Array of sl z.
  
//  reg signed [n*sl-1:0] con;  // Temp concatenation of sl amount of y
  
  // Memory modules. Parallel.
  // The data for the whole layer is a long strip of number.
//  mem_r #(list, sl*n*(sx+1)) mr(0, rom);
  
  // One shift register for each node. Parallel.
  genvar k;
  generate
    for (k=0; k<sl; k=k+1) begin : shiftregs
      // Data start from LSB
      shift_register #(sx+1) sr(clk, rst, we[sl-k-1], bus, data[k]);  // Data for each node, {b, nw}.
                                                                      // Total of sx+1 n-bit data for sx*w and b
    end
  endgenerate
  
  // Separating memory data. Parallel.
  always @(*) begin
    for (j=0; j<sl; j=j+1) begin
      // [a +: b] means a offset with b width
      // Data for each node, {b, nw}, ex: {b, w2, w1, w0}.
      nw[j] <= data[j][n*sx-1:0]; // Thus nw are from [0] to [sx] and b is [sx+1].
      b[j] <= data[j][n*(sx+1)-1:n*sx];
    end
  end
  
  // Node modules. Parallel
  generate
    for (k=0; k<sl; k=k+1) begin : nodes
      node #(sx) nd(nx, nw[k], b[k], y[k], z[k]);
    end
  endgenerate
  
  // Output concenation. Parallel.
  always @(*) begin 
    for (j=0; j<sl; j=j+1) begin
      // [a +: b] means a offset with b width, thus first input are the n LSBs 
      ly[j*n +: n] <= y[j];
      lnw[j*n*sx +: n*sx] <= nw[j];
      lb[j*n +: n] <= b[j];
    end
  end
    
endmodule
