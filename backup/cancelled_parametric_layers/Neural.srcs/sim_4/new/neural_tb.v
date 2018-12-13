`timescale 1ns / 1ps
module neural_tb();

  reg clk, rst;
  
  neural neu(clk, rst);
  
  localparam T = 10;
  
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