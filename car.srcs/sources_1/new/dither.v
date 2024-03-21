`timescale 1ns / 1ps

module dither(
    input clk,
    input rst_n,
    output reg [8:0] x,
    output reg [8:0] y,
    input [7:0] gray,
    output reg data
    );
    
reg [3:0] Bayer[7:0][7:0];

initial begin // 数组初始化
//Bayer = [ 0 32  8 40  2 34 10 42; 48 16 56 24 50 18 58 26
//         12 44  4 36 14 46  6 38; 60 28 52 20 62 30 54 22
//          3 35 11 43  1 33  9 41; 51 19 59 27 49 17 57 25
//         15 47  7 39 13 45  5 37; 63 31 55 23 61 29 53 21];
end

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		data <= 1'd0;
	else if((gray >> 4) < Bayer[x % 8][y % 8])
		data <= 1'd1;
	else
		data <= 1'b0;
end
	
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		x <= 1'd0;
	else if(x==320)
		x <= 1'b0;
	else
		x <= x + 1'd1;
end

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		y <= 1'd0;
	else if(!x)
		y <= y + 1'd1;
	else
		y <= 1'b0;
end

endmodule
