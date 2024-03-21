module test
(
	input	[15:0]   	data,	
	output	wire	[7:0]	gray
);

test1 i_test1
(
	.data      (data),	
	.gray      (gray)
);

test2 i_test2
(
	.data      (data),	
	.gray      (gray)
);

endmodule