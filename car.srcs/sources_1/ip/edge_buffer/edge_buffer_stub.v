// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
// Date        : Fri Jun  2 11:31:21 2023
// Host        : DESKTOP-0TSH46O running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               f:/Study/FPGA/Project/digit_reco11/digit_reco11.srcs/sources_1/ip/edge_buffer/edge_buffer_stub.v
// Design      : edge_buffer
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tftg256-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_2,Vivado 2018.3" *)
module edge_buffer(clka, ena, wea, addra, dina, clkb, addrb, doutb)
/* synthesis syn_black_box black_box_pad_pin="clka,ena,wea[0:0],addra[16:0],dina[0:0],clkb,addrb[16:0],doutb[0:0]" */;
  input clka;
  input ena;
  input [0:0]wea;
  input [16:0]addra;
  input [0:0]dina;
  input clkb;
  input [16:0]addrb;
  output [0:0]doutb;
endmodule
