//Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2018.2 (win64) Build 2258646 Thu Jun 14 20:03:12 MDT 2018
//Date        : Mon Dec 17 18:04:12 2018
//Host        : Ab-1 running 64-bit major release  (build 9200)
//Command     : generate_target sbc_wrapper.bd
//Design      : sbc_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module sbc_wrapper
   (BRAM_PORTA_1_addr,
    BRAM_PORTA_1_clk,
    BRAM_PORTA_1_din,
    BRAM_PORTA_1_dout,
    BRAM_PORTA_1_en,
    BRAM_PORTA_1_rst,
    BRAM_PORTA_1_we,
    BRAM_PORTA_addr,
    BRAM_PORTA_clk,
    BRAM_PORTA_din,
    BRAM_PORTA_dout,
    BRAM_PORTA_en,
    BRAM_PORTA_rst,
    BRAM_PORTA_we,
    BRAM_PORTB_1_addr,
    BRAM_PORTB_1_clk,
    BRAM_PORTB_1_din,
    BRAM_PORTB_1_dout,
    BRAM_PORTB_1_en,
    BRAM_PORTB_1_rst,
    BRAM_PORTB_1_we,
    BRAM_PORTB_addr,
    BRAM_PORTB_clk,
    BRAM_PORTB_din,
    BRAM_PORTB_dout,
    BRAM_PORTB_en,
    BRAM_PORTB_rst,
    BRAM_PORTB_we);
  input [8:0]BRAM_PORTA_1_addr;
  input BRAM_PORTA_1_clk;
  input [63:0]BRAM_PORTA_1_din;
  output [63:0]BRAM_PORTA_1_dout;
  input BRAM_PORTA_1_en;
  input BRAM_PORTA_1_rst;
  input [7:0]BRAM_PORTA_1_we;
  input [8:0]BRAM_PORTA_addr;
  input BRAM_PORTA_clk;
  input [31:0]BRAM_PORTA_din;
  output [31:0]BRAM_PORTA_dout;
  input BRAM_PORTA_en;
  input BRAM_PORTA_rst;
  input [3:0]BRAM_PORTA_we;
  input [8:0]BRAM_PORTB_1_addr;
  input BRAM_PORTB_1_clk;
  input [63:0]BRAM_PORTB_1_din;
  output [63:0]BRAM_PORTB_1_dout;
  input BRAM_PORTB_1_en;
  input BRAM_PORTB_1_rst;
  input [7:0]BRAM_PORTB_1_we;
  input [8:0]BRAM_PORTB_addr;
  input BRAM_PORTB_clk;
  input [31:0]BRAM_PORTB_din;
  output [31:0]BRAM_PORTB_dout;
  input BRAM_PORTB_en;
  input BRAM_PORTB_rst;
  input [3:0]BRAM_PORTB_we;

  wire [8:0]BRAM_PORTA_1_addr;
  wire BRAM_PORTA_1_clk;
  wire [63:0]BRAM_PORTA_1_din;
  wire [63:0]BRAM_PORTA_1_dout;
  wire BRAM_PORTA_1_en;
  wire BRAM_PORTA_1_rst;
  wire [7:0]BRAM_PORTA_1_we;
  wire [8:0]BRAM_PORTA_addr;
  wire BRAM_PORTA_clk;
  wire [31:0]BRAM_PORTA_din;
  wire [31:0]BRAM_PORTA_dout;
  wire BRAM_PORTA_en;
  wire BRAM_PORTA_rst;
  wire [3:0]BRAM_PORTA_we;
  wire [8:0]BRAM_PORTB_1_addr;
  wire BRAM_PORTB_1_clk;
  wire [63:0]BRAM_PORTB_1_din;
  wire [63:0]BRAM_PORTB_1_dout;
  wire BRAM_PORTB_1_en;
  wire BRAM_PORTB_1_rst;
  wire [7:0]BRAM_PORTB_1_we;
  wire [8:0]BRAM_PORTB_addr;
  wire BRAM_PORTB_clk;
  wire [31:0]BRAM_PORTB_din;
  wire [31:0]BRAM_PORTB_dout;
  wire BRAM_PORTB_en;
  wire BRAM_PORTB_rst;
  wire [3:0]BRAM_PORTB_we;

  sbc sbc_i
       (.BRAM_PORTA_1_addr(BRAM_PORTA_1_addr),
        .BRAM_PORTA_1_clk(BRAM_PORTA_1_clk),
        .BRAM_PORTA_1_din(BRAM_PORTA_1_din),
        .BRAM_PORTA_1_dout(BRAM_PORTA_1_dout),
        .BRAM_PORTA_1_en(BRAM_PORTA_1_en),
        .BRAM_PORTA_1_rst(BRAM_PORTA_1_rst),
        .BRAM_PORTA_1_we(BRAM_PORTA_1_we),
        .BRAM_PORTA_addr(BRAM_PORTA_addr),
        .BRAM_PORTA_clk(BRAM_PORTA_clk),
        .BRAM_PORTA_din(BRAM_PORTA_din),
        .BRAM_PORTA_dout(BRAM_PORTA_dout),
        .BRAM_PORTA_en(BRAM_PORTA_en),
        .BRAM_PORTA_rst(BRAM_PORTA_rst),
        .BRAM_PORTA_we(BRAM_PORTA_we),
        .BRAM_PORTB_1_addr(BRAM_PORTB_1_addr),
        .BRAM_PORTB_1_clk(BRAM_PORTB_1_clk),
        .BRAM_PORTB_1_din(BRAM_PORTB_1_din),
        .BRAM_PORTB_1_dout(BRAM_PORTB_1_dout),
        .BRAM_PORTB_1_en(BRAM_PORTB_1_en),
        .BRAM_PORTB_1_rst(BRAM_PORTB_1_rst),
        .BRAM_PORTB_1_we(BRAM_PORTB_1_we),
        .BRAM_PORTB_addr(BRAM_PORTB_addr),
        .BRAM_PORTB_clk(BRAM_PORTB_clk),
        .BRAM_PORTB_din(BRAM_PORTB_din),
        .BRAM_PORTB_dout(BRAM_PORTB_dout),
        .BRAM_PORTB_en(BRAM_PORTB_en),
        .BRAM_PORTB_rst(BRAM_PORTB_rst),
        .BRAM_PORTB_we(BRAM_PORTB_we));
endmodule
