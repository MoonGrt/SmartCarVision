`timescale 1ns/1ns
module sobel_edge_detector
#(
	parameter	[8:0]	IMG_HDISP = 9'd320,	//320*240
	parameter	[7:0]	IMG_VDISP = 8'd240
)
(
	//global clock
	input	wire			clk,  				//cmos video pixel clock
	input	wire			rst_n,				//global reset
	
	//user interface
	input	wire	[7:0]	sobel_threshold,	//Sobel Threshold for image edge detect

	//Image data prepred to be processd
	input	wire			per_frame_vsync,	//Prepared Image data vsync valid signal
	input	wire			per_frame_href,		//Prepared Image data href vaild  signal
	input	wire			per_frame_clken,	//Prepared Image data output/capture enable clock
	input	wire	[7:0]	per_img,			//Prepared Image brightness input
	
	//Image data has been processd
	output	wire			post_frame_vsync,	//Processed Image data vsync valid signal
	output	wire			post_frame_href,	//Processed Image data href vaild  signal
	output	wire	[16:0]	post_frame_addr,
	output	wire			post_frame_clken,	//Processed Image data output/capture enable clock
	output	wire			post_img_bit		//Processed Image Bit flag outout(1: Value, 0:inValid)
);

	//----------------------------------------------------
	//Generate 8Bit 3X3 Matrix for Video Image Processor.
	//Image data has been processd
	wire			matrix_frame_vsync;	//Prepared Image data vsync valid signal
	wire			matrix_frame_href;	//Prepared Image data href vaild  signal
	wire			matrix_frame_clken;	//Prepared Image data output/capture enable clock	
	wire	[7:0]	matrix_p11, matrix_p12, matrix_p13;	//3X3 Matrix output
	wire	[7:0]	matrix_p21, matrix_p22, matrix_p23;
	wire	[7:0]	matrix_p31, matrix_p32, matrix_p33;
	
	matrix_generate_3x3	
	#(
		.IMG_HDISP	(IMG_HDISP),
		.IMG_VDISP	(IMG_VDISP)
	)
	matrix_generate_3x3_inst
	(
		//global clock
		.clk					(clk),  				//cmos video pixel clock
		.rst_n					(rst_n),				//global reset

		//Image data prepred to be processd
		.per_frame_vsync		(per_frame_vsync),		//Prepared Image data vsync valid signal
		.per_frame_href			(per_frame_href),		//Prepared Image data href vaild  signal
		.per_frame_clken		(per_frame_clken),		//Prepared Image data output/capture enable clock
		.per_img				(per_img),			//Prepared Image brightness input

		//Image data has been processd
		.matrix_frame_vsync		(matrix_frame_vsync),	//Processed Image data vsync valid signal
		.matrix_frame_href		(matrix_frame_href),	//Processed Image data href vaild  signal
		.matrix_frame_clken		(matrix_frame_clken),	//Processed Image data output/capture enable clock	
		.matrix_p11(matrix_p11),	.matrix_p12(matrix_p12), 	.matrix_p13(matrix_p13),	//3X3 Matrix output
		.matrix_p21(matrix_p21), 	.matrix_p22(matrix_p22), 	.matrix_p23(matrix_p23),
		.matrix_p31(matrix_p31), 	.matrix_p32(matrix_p32), 	.matrix_p33(matrix_p33)
	);

	//---------------------------------------
	//Sobel Parameter
	//       Gx                Gy				Pixel
	// [ -1   0   +1 ]   [ +1  +2  +1 ]   [ P11  P12  P13 ]
	// [ -2   0   +2 ]   [  0   0   0 ]   [ P21  P22  P23 ]
	// [ -1   0   +1 ]   [ -1  -2  -1 ]   [ P31  P32  P33 ]
	//Caculate horizontal Grade with |abs|
	reg		[9:0]	Gx_temp1;	//positive result
	reg		[9:0]	Gx_temp2;	//negetive result
	reg		[9:0]	Gx_data;	//Horizontal grade data
	
	always@(posedge clk or negedge rst_n)
	begin
		if(!rst_n) begin
			Gx_temp1 <= 0;
			Gx_temp2 <= 0;
			Gx_data <= 0;
		end
		else begin
			Gx_temp1 <= matrix_p13 + (matrix_p23 << 1) + matrix_p33;	//positive result
			Gx_temp2 <= matrix_p11 + (matrix_p21 << 1) + matrix_p31;	//negetive result
			Gx_data <= (Gx_temp1 >= Gx_temp2) ? Gx_temp1 - Gx_temp2 : Gx_temp2 - Gx_temp1;
		end
	end

	//---------------------------------------
	//Caculate vertical Grade with |abs|
	reg		[9:0]	Gy_temp1;	//positive result
	reg		[9:0]	Gy_temp2;	//negetive result
	reg		[9:0]	Gy_data;	//Vertical grade data
	
	always@(posedge clk or negedge rst_n)
	begin
		if(!rst_n) begin
			Gy_temp1 <= 0;
			Gy_temp2 <= 0;
			Gy_data <= 0;
		end
		else begin
			Gy_temp1 <= matrix_p11 + (matrix_p12 << 1) + matrix_p13;	//positive result
			Gy_temp2 <= matrix_p31 + (matrix_p32 << 1) + matrix_p33;	//negetive result
			Gy_data <= (Gy_temp1 >= Gy_temp2) ? Gy_temp1 - Gy_temp2 : Gy_temp2 - Gy_temp1;
		end
	end

	//---------------------------------------
	//Caculate the square of distance = (Gx^2 + Gy^2)
	reg		[20:0]	Gxy_square;
	
	always@(posedge clk or negedge rst_n)
	begin
		if(!rst_n)
			Gxy_square <= 0;
		else
			Gxy_square <= Gx_data * Gx_data + Gy_data * Gy_data;
	end

	//---------------------------------------
	//Caculate the distance of P5 = (Gx^2 + Gy^2)^0.5
	wire	[10:0]	Dim;
	
	cordic_sqrt cordic_sqrt_inst
	(
	  	.s_axis_cartesian_tvalid(1'b1),
	  	.s_axis_cartesian_tdata(Gxy_square),
	  	.m_axis_dout_tvalid(),
	  	.m_axis_dout_tdata(Dim)
	);

	//---------------------------------------
	//Compare and get the Sobel_data
	reg				post_img_bit_r;
	
	always@(posedge clk or negedge rst_n)
	begin
		if(!rst_n)
			post_img_bit_r <= 1'b0;	//Default None
		else if(Dim >= sobel_threshold)
			post_img_bit_r <= 1'b1;	//Edge Flag
		else
			post_img_bit_r <= 1'b0;	//Not Edge
	end

	//------------------------------------------
	//lag 5 clocks signal sync  
	reg		[4:0]	per_frame_vsync_r;
	reg		[4:0]	per_frame_href_r;	
	reg		[4:0]	per_frame_clken_r;
	
	always@(posedge clk or negedge rst_n)
	begin
		if(!rst_n) begin
			per_frame_vsync_r <= 0;
			per_frame_href_r <= 0;
			per_frame_clken_r <= 0;
		end
		else begin
			per_frame_vsync_r 	<= 	{per_frame_vsync_r[3:0], 	matrix_frame_vsync};
			per_frame_href_r 	<= 	{per_frame_href_r[3:0], 	matrix_frame_href};
			per_frame_clken_r 	<= 	{per_frame_clken_r[3:0], 	matrix_frame_clken};
		end
	end
	
	assign	post_frame_vsync 	= 	per_frame_vsync_r[4];
	assign	post_frame_href 	= 	per_frame_href_r[4];
	assign	post_frame_clken 	= 	per_frame_clken_r[4];
	
	reg		[17:0]	frame_addr;
	always @(posedge clk or negedge rst_n) 
	begin
		if(!rst_n)
			frame_addr <= 18'd0;
		else if(!post_frame_vsync) begin
			if(post_frame_href)
				frame_addr <= frame_addr + 1'b1;
		end
		else
			frame_addr <= 18'd0;
	end
	
	assign	post_frame_addr 	= 	frame_addr[17:1];
	assign	post_img_bit		=	post_frame_href ? post_img_bit_r : 1'b0;

endmodule
