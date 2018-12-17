`timescale 1ps / 1ps

module neural_bp_tb();

  reg clk, rst;
  
  neural neu(clk, rst, 20-1);
  
  localparam T = 10000;
  
  always begin
    // Clock
    clk = 0;
    #(T/2);
    clk = 1;
    #(T/2);
  end
  
  initial begin
  
      // Init
      
      // Reset
      rst = 1;
      #(T*6);
      rst = 0;
      #(T*6);
          
    end
  
endmodule