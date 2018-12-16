//Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2018.2 (win64) Build 2258646 Thu Jun 14 20:03:12 MDT 2018
//Date        : Sun Dec 16 17:06:52 2018
//Host        : Ab-1 running 64-bit major release  (build 9200)
//Command     : generate_target sbc.bd
//Design      : sbc
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "sbc,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=sbc,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=2,numReposBlks=2,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=Global}" *) (* HW_HANDOFF = "sbc.hwdef" *) 
module sbc
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
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA_1 ADDR" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME BRAM_PORTA_1, MASTER_TYPE BRAM_CTRL, MEM_ECC NONE, MEM_SIZE 128, MEM_WIDTH 64, READ_WRITE_MODE READ_WRITE" *) input [8:0]BRAM_PORTA_1_addr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA_1 CLK" *) input BRAM_PORTA_1_clk;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA_1 DIN" *) input [63:0]BRAM_PORTA_1_din;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA_1 DOUT" *) output [63:0]BRAM_PORTA_1_dout;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA_1 EN" *) input BRAM_PORTA_1_en;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA_1 RST" *) input BRAM_PORTA_1_rst;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA_1 WE" *) input [7:0]BRAM_PORTA_1_we;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME BRAM_PORTA, MASTER_TYPE BRAM_CTRL, MEM_ECC NONE, MEM_SIZE 128, MEM_WIDTH 64, READ_WRITE_MODE READ_WRITE" *) input [8:0]BRAM_PORTA_addr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) input BRAM_PORTA_clk;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [31:0]BRAM_PORTA_din;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [31:0]BRAM_PORTA_dout;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA EN" *) input BRAM_PORTA_en;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA RST" *) input BRAM_PORTA_rst;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [3:0]BRAM_PORTA_we;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTB_1 ADDR" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME BRAM_PORTB_1, MASTER_TYPE BRAM_CTRL, MEM_ECC NONE, MEM_SIZE 128, MEM_WIDTH 64, READ_WRITE_MODE READ_WRITE" *) input [8:0]BRAM_PORTB_1_addr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTB_1 CLK" *) input BRAM_PORTB_1_clk;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTB_1 DIN" *) input [63:0]BRAM_PORTB_1_din;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTB_1 DOUT" *) output [63:0]BRAM_PORTB_1_dout;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTB_1 EN" *) input BRAM_PORTB_1_en;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTB_1 RST" *) input BRAM_PORTB_1_rst;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTB_1 WE" *) input [7:0]BRAM_PORTB_1_we;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTB ADDR" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME BRAM_PORTB, MASTER_TYPE BRAM_CTRL, MEM_ECC NONE, MEM_SIZE 128, MEM_WIDTH 64, READ_WRITE_MODE READ_WRITE" *) input [8:0]BRAM_PORTB_addr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTB CLK" *) input BRAM_PORTB_clk;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTB DIN" *) input [31:0]BRAM_PORTB_din;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTB DOUT" *) output [31:0]BRAM_PORTB_dout;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTB EN" *) input BRAM_PORTB_en;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTB RST" *) input BRAM_PORTB_rst;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTB WE" *) input [3:0]BRAM_PORTB_we;

  wire [8:0]BRAM_PORTA_1_1_ADDR;
  wire BRAM_PORTA_1_1_CLK;
  wire [63:0]BRAM_PORTA_1_1_DIN;
  wire [63:0]BRAM_PORTA_1_1_DOUT;
  wire BRAM_PORTA_1_1_EN;
  wire BRAM_PORTA_1_1_RST;
  wire [7:0]BRAM_PORTA_1_1_WE;
  wire [8:0]BRAM_PORTA_1_ADDR;
  wire BRAM_PORTA_1_CLK;
  wire [31:0]BRAM_PORTA_1_DIN;
  wire [31:0]BRAM_PORTA_1_DOUT;
  wire BRAM_PORTA_1_EN;
  wire BRAM_PORTA_1_RST;
  wire [3:0]BRAM_PORTA_1_WE;
  wire [8:0]BRAM_PORTB_1_1_ADDR;
  wire BRAM_PORTB_1_1_CLK;
  wire [63:0]BRAM_PORTB_1_1_DIN;
  wire [63:0]BRAM_PORTB_1_1_DOUT;
  wire BRAM_PORTB_1_1_EN;
  wire BRAM_PORTB_1_1_RST;
  wire [7:0]BRAM_PORTB_1_1_WE;
  wire [8:0]BRAM_PORTB_1_ADDR;
  wire BRAM_PORTB_1_CLK;
  wire [31:0]BRAM_PORTB_1_DIN;
  wire [31:0]BRAM_PORTB_1_DOUT;
  wire BRAM_PORTB_1_EN;
  wire BRAM_PORTB_1_RST;
  wire [3:0]BRAM_PORTB_1_WE;

  assign BRAM_PORTA_1_1_ADDR = BRAM_PORTA_1_addr[8:0];
  assign BRAM_PORTA_1_1_CLK = BRAM_PORTA_1_clk;
  assign BRAM_PORTA_1_1_DIN = BRAM_PORTA_1_din[63:0];
  assign BRAM_PORTA_1_1_EN = BRAM_PORTA_1_en;
  assign BRAM_PORTA_1_1_RST = BRAM_PORTA_1_rst;
  assign BRAM_PORTA_1_1_WE = BRAM_PORTA_1_we[7:0];
  assign BRAM_PORTA_1_ADDR = BRAM_PORTA_addr[8:0];
  assign BRAM_PORTA_1_CLK = BRAM_PORTA_clk;
  assign BRAM_PORTA_1_DIN = BRAM_PORTA_din[31:0];
  assign BRAM_PORTA_1_EN = BRAM_PORTA_en;
  assign BRAM_PORTA_1_RST = BRAM_PORTA_rst;
  assign BRAM_PORTA_1_WE = BRAM_PORTA_we[3:0];
  assign BRAM_PORTA_1_dout[63:0] = BRAM_PORTA_1_1_DOUT;
  assign BRAM_PORTA_dout[31:0] = BRAM_PORTA_1_DOUT;
  assign BRAM_PORTB_1_1_ADDR = BRAM_PORTB_1_addr[8:0];
  assign BRAM_PORTB_1_1_CLK = BRAM_PORTB_1_clk;
  assign BRAM_PORTB_1_1_DIN = BRAM_PORTB_1_din[63:0];
  assign BRAM_PORTB_1_1_EN = BRAM_PORTB_1_en;
  assign BRAM_PORTB_1_1_RST = BRAM_PORTB_1_rst;
  assign BRAM_PORTB_1_1_WE = BRAM_PORTB_1_we[7:0];
  assign BRAM_PORTB_1_ADDR = BRAM_PORTB_addr[8:0];
  assign BRAM_PORTB_1_CLK = BRAM_PORTB_clk;
  assign BRAM_PORTB_1_DIN = BRAM_PORTB_din[31:0];
  assign BRAM_PORTB_1_EN = BRAM_PORTB_en;
  assign BRAM_PORTB_1_RST = BRAM_PORTB_rst;
  assign BRAM_PORTB_1_WE = BRAM_PORTB_we[3:0];
  assign BRAM_PORTB_1_dout[63:0] = BRAM_PORTB_1_1_DOUT;
  assign BRAM_PORTB_dout[31:0] = BRAM_PORTB_1_DOUT;
  sbc_blk_mem_gen_0_0 blk_mem_gen_0
       (.addra(BRAM_PORTA_1_ADDR),
        .addrb(BRAM_PORTB_1_ADDR),
        .clka(BRAM_PORTA_1_CLK),
        .clkb(BRAM_PORTB_1_CLK),
        .dina(BRAM_PORTA_1_DIN),
        .dinb(BRAM_PORTB_1_DIN),
        .douta(BRAM_PORTA_1_DOUT),
        .doutb(BRAM_PORTB_1_DOUT),
        .ena(BRAM_PORTA_1_EN),
        .enb(BRAM_PORTB_1_EN),
        .rsta(BRAM_PORTA_1_RST),
        .rstb(BRAM_PORTB_1_RST),
        .wea(BRAM_PORTA_1_WE),
        .web(BRAM_PORTB_1_WE));
  sbc_blk_mem_gen_1_0 blk_mem_gen_1
       (.addra(BRAM_PORTA_1_1_ADDR),
        .addrb(BRAM_PORTB_1_1_ADDR),
        .clka(BRAM_PORTA_1_1_CLK),
        .clkb(BRAM_PORTB_1_1_CLK),
        .dina(BRAM_PORTA_1_1_DIN),
        .dinb(BRAM_PORTB_1_1_DIN),
        .douta(BRAM_PORTA_1_1_DOUT),
        .doutb(BRAM_PORTB_1_1_DOUT),
        .ena(BRAM_PORTA_1_1_EN),
        .enb(BRAM_PORTB_1_1_EN),
        .rsta(BRAM_PORTA_1_1_RST),
        .rstb(BRAM_PORTB_1_1_RST),
        .wea(BRAM_PORTA_1_1_WE),
        .web(BRAM_PORTB_1_1_WE));
endmodule
