module test2
(
	input	[15:0]   	data,	
	output	wire	[7:0]	gray
);

wire    [15:0] r,g,b;
wire    [15:0] a;

assign r = data[15:8] * 8'd77;
assign g = data[10:5] * 8'd150;
assign b = data[4:0]  * 8'd29;
assign a = r + g + b;

assign gray = a[15:8];
	
endmodule