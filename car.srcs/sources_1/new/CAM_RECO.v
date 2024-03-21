`timescale 1ns / 1ps

module CAM_RECO
(
    // System Interface
	input	wire			clk_sys,        //50MHz
	input	wire			reset_n,        //Global Reset
		
	// VGA Interface
	output	wire	[3:0]	vga_r,
	output	wire	[3:0]	vga_g,
	output	wire	[3:0]	vga_b,
	output	wire			vga_hs,
	output	wire			vga_vs,	
	
	// CMOS Camera(OV7670) Interface
	output	wire			cmos_sclk,
	output	wire			cmos_rst_n,
	inout	wire			cmos_sdat,
	input	wire			cmos_vsync,
	input	wire			cmos_href,
	input	wire			cmos_pclk,	
	output	wire			cmos_xclk,
	input	wire	[7:0]	cmos_data,
	
	//
	output wire  [7:0]  threshold,
	input   wire        button_flag,
    input   wire [3:0]  button_data,
    output   wire [3:0]  digit
);

    assign cmos_rst_n = 1'b1;

    localparam	CLOCK_MAIN	=	50_000_000;

    //------Mixed-Mode Clock Management-----//
	wire			clk_vid;// VGA Clock
	wire			clk_cam;// Camera Clock
	wire			clk_cfg;// Config Clock
	wire			locked;
	wire			rst_n;
	
    assign rst_n = reset_n & locked;

    sys_mmcm sys_mmcm_inst(
   		// Clock in ports
		.clk_in1(clk_sys),
		// Clock out ports
	    .clk_out1(clk_vid),
	    .clk_out2(clk_cam),
		.clk_out3(clk_cfg),
		// Status and control signals
	    .locked(locked)
	 );

     //-----Camera Initialization Module-----//
     wire			i2c_config_done;

	i2c_timing_ctrl
	#(
		.CLK_FREQ (50_000_000),// 50 MHz
		.I2C_FREQ (100_000)// 10 KHz(<= 400KHz)
	)
	i2c_timing_ctrl_inst
	(
		.clk				(clk_cfg),
		.rst_n				(rst_n),
		.i2c_scl			(cmos_sclk),//i2c clock
		.i2c_sda			(cmos_sdat),//i2c data for bidirection
		.i2c_config_done	(i2c_config_done)//i2c config timing complete
	);

    //-----CMOS video image capture------//
	wire			cmos_init_done;      // cmos camera init done
    assign cmos_init_done = i2c_config_done;
	wire			cmos_frame_vsync;	// cmos frame data vsync valid signal
	wire			cmos_frame_href;	// cmos frame data href vaild  signal
	wire	[15:0]	cmos_frame_data;	// cmos frame data output: {cmos_data[7:0]<<8, cmos_data[7:0]}	
	wire	[16:0]	cmos_frame_addr;    // cmos frame data output/capture address
	wire			cmos_frame_clken;	// cmos frame data output/capture enable clock
	wire	[7:0]	cmos_fps_rate;		// cmos image output rate

    cmos_capture_RGB565	
	#(
		.CMOS_FRAME_WAITCNT	(4'd10)					//Wait n fps for steady(OmniVision need 10 Frame)
	)
	cmos_capture_RGB565_inst
	(
		//global clock
		.clk_cmos				(clk_cam),			        //24MHz CMOS Driver clock input
		.rst_n					(rst_n & cmos_init_done),	//reset

		//CMOS Sensor Interface
		.cmos_pclk				(cmos_pclk),  		//24MHz CMOS Pixel clock input
		.cmos_xclk				(cmos_xclk),		//24MHz drive clock
		.cmos_data				(cmos_data),		//8 bits cmos data input
		.cmos_vsync				(cmos_vsync),		//L: vaild, H: invalid
		.cmos_href				(cmos_href),		//H: vaild, L: invalid
		
		//CMOS SYNC Data output
		.cmos_frame_vsync		(cmos_frame_vsync),	//cmos frame data vsync valid signal
		.cmos_frame_href		(cmos_frame_href),	//cmos frame data href vaild  signal
		.cmos_frame_data		(cmos_frame_data),	//cmos frame RGB output: {{R[4:0],G[5:3]}, {G2:0}, B[4:0]}	
		.cmos_frame_addr		(cmos_frame_addr),
		.cmos_frame_clken		(cmos_frame_clken),	//cmos frame data output/capture enable clock
		
		//user interface
		.cmos_fps_rate			(cmos_fps_rate)		//cmos image output rate
	);
	
	wire	[7:0]	img_y,img_Cr,img_Cb;
	wire			post_frame_vsync_ycbcr;	  //Processed Image data vsync valid signal
	wire			post_frame_href_ycbcr;	  //Processed Image data href vaild  signal
    wire			post_frame_clken_ycbcr;	  //Processed Image data output/capture enable clock	
    
    //RGB转YCbCr模块
    rgb2ycbcr u_rgb2ycbcr(
        //module clock
        .clk             (cmos_pclk    ),            // 时钟信号
        .rst_n           (rst_n  ),            // 复位信号（低有效）
        //图像处理前的数据接口
        .pre_frame_vsync (cmos_frame_vsync),    // vsync信号
        .pre_frame_hsync (cmos_frame_href ),    // href信号
        .pre_frame_de    (cmos_frame_clken),    // data enable信号
        .img_red         (cmos_frame_data[15:11] ),
        .img_green       (cmos_frame_data[10:5 ] ),
        .img_blue        (cmos_frame_data[ 4:0 ] ),
        //图像处理后的数据接口
        .post_frame_vsync(post_frame_vsync_ycbcr),              // vsync信号
        .post_frame_hsync(post_frame_href_ycbcr),              // href信号
        .post_frame_de   (post_frame_clken_ycbcr),              // data enable信号
        .img_y           (img_y),
        .img_cb          (img_Cr),
        .img_cr          (img_Cb)
    );

    wire	[16:0]	vga_img_addr;
	wire	[7:0]	vga_img_data;

    frame_buffer frame_buffer_inst//Storage  of the image to display
	(
	  	.clka	(cmos_pclk),// input wire clka
	  	.wea	(1'b1),// input wire [0 : 0] wea
	  	.ena    (cmos_frame_clken),
	  	.addra	(cmos_frame_addr),// input wire [16 : 0] addra
	  	.dina	({cmos_frame_data[15:11],3'd0}),// input wire [7 : 0] dina
	  	.clkb	(clk_vid),// input wire clkb
	  	.addrb	(vga_img_addr),// input wire [16 : 0] addrb
	  	.doutb	(vga_img_data)// output wire [8 : 0] doutb
	);
	
	wire	[7:0]   post_y,post_Cr,post_Cb;		      //Processed Image brightness output
	wire			post_frame_vsync_mid_value;	//Processed Image data vsync valid signal
	wire			post_frame_href_mid_value;	//Processed Image data href vaild  signal
    wire			post_frame_clken_mid_value;	  //Processed Image data output/capture enable clock	
    
    mid_value
	#(
		.IMG_HDISP(9'd320),	//640*480
		.IMG_VDISP(8'd240)
	)
	mid_value_inst
	(
		//global clock
		.clk					(cmos_pclk),  //cmos video pixel clock
		.rst_n					(rst_n),	//global reset
		
		//Image data prepred to be processd
		.per_frame_vsync		(post_frame_vsync_ycbcr),	//Prepared Image data vsync valid signal
		.per_frame_href			(post_frame_href_ycbcr),	//Prepared Image data href vaild  signal
		.per_frame_clken		(post_frame_clken_ycbcr),	//Prepared Image data output/capture enable clock
		.per_y				    (img_y), //Prepared Image brightness input
		.per_Cr                 (img_Cr),
		.per_Cb                 (img_Cb),
		
		//Image data has been processd
		.post_frame_vsync		(post_frame_vsync_mid_value),	//Processed Image data vsync valid signal
		.post_frame_href		(post_frame_href_mid_value),	//Processed Image data href vaild  signal
		.post_frame_clken		(post_frame_clken_mid_value),	//Processed Image data output/capture enable clock
		.post_y	     	        (post_y)
	);

	wire	[7:0]   post_y2;		      //Processed Image brightness output
	wire			post_frame_vsync_gauss;	//Processed Image data vsync valid signal
	wire			post_frame_href_gauss;	//Processed Image data href vaild  signal
    wire			post_frame_clken_gauss;	  //Processed Image data output/capture enable clock	
    
    gauss1
	#(
		.IMG_HDISP(9'd320),	//640*480
		.IMG_VDISP(8'd240)
	)
	gauss1_inst
	(
		//global clock
		.clk					(cmos_pclk),  //cmos video pixel clock
		.rst_n					(rst_n),	//global reset
		
		//Image data prepred to be processd
		.per_frame_vsync		(post_frame_vsync_mid_value),	//Prepared Image data vsync valid signal
		.per_frame_href			(post_frame_href_mid_value),	//Prepared Image data href vaild  signal
		.per_frame_clken		(post_frame_clken_mid_value),	//Prepared Image data output/capture enable clock
		.per_y				    (post_y),
		
		//Image data has been processd
		.post_frame_vsync		(post_frame_vsync_gauss),	//Processed Image data vsync valid signal
		.post_frame_href		(post_frame_href_gauss),	//Processed Image data href vaild  signal
		.post_frame_clken		(post_frame_clken_gauss),	//Processed Image data output/capture enable clock
		.post_y	     	        (post_y2)
	);
	
    wire			post_frame_clken_binary;	//Processed Image data output/capture enable clock
	wire	[16:0]	post_frame_addr_binary;    //Processed Image Address output
	wire			post_img_bit_binary;		//Processed Image brightness output
    
    //二值化模块
    binarization1 u_binarization(
        //module clock
        .clk                (cmos_pclk    ),          // 时钟信号
        .rst_n              (rst_n  ),          // 复位信号（低有效）
        //图像处理前的数据接口
        .pre_frame_vsync    (post_frame_vsync_gauss),            // vsync信号
        .pre_frame_hsync    (post_frame_href_gauss),            // href信号
        .pre_frame_de       (post_frame_clken_gauss),            // data enable信号
        .y	     	        (post_y2),        
        .threshold          (threshold),
        //图像处理后的数据接口
        .post_frame_vsync   (), // vsync信号
        .post_frame_hsync   (), // href信号
        .post_frame_de      (post_frame_clken_binary   ), // data enable信号
        .post_frame_addr	(post_frame_addr_binary), //Processed Image Address output
        .monoc              (post_img_bit_binary  ) // 单色图像像素数据
    );

	wire	[16:0]	vga_binary_addr;
	wire			vga_binary_bit;
	
	binary_buffer binary_buffer_inst
	(
	  	.clka	(cmos_pclk), // input wire clka
	  	.wea	(1'b1), // input wire [0 : 0] wea
	  	.ena    (post_frame_clken_binary),
	  	.addra	(post_frame_addr_binary),  // input wire [16 : 0] addra
	  	.dina	(post_img_bit_binary), // input wire [0 : 0] dina
	  	.clkb	(clk_vid), // input wire clkb
	  	.addrb	(vga_binary_addr), // input wire [16 : 0] addrb
	  	.doutb  (vga_binary_bit) // output wire [0 : 0] doutb
	);

    wire			post_frame_clken_sobel1;	//Processed Image data output/capture enable clock
	wire	[16:0]	post_frame_addr_sobel1;    //Processed Image Address output
	wire			post_img_bit_sobel1;		//Processed Image brightness output

    sobel_edge_detector
	#(
		.IMG_HDISP(9'd320),	//320*240
		.IMG_VDISP(8'd240)
	)
	sobel1_edge_detector_inst
	(
		//global clock
		.clk					(cmos_pclk),  //cmos video pixel clock
		.rst_n					(rst_n),	//global reset
		
		//user interface
		.sobel_threshold		(threshold),	//Sobel Threshold for image edge detect

		//Image data prepred to be processd
		.per_frame_vsync		(post_frame_vsync_ycbcr),	//Prepared Image data vsync valid signal
		.per_frame_href			(post_frame_href_ycbcr),	//Prepared Image data href vaild  signal
		.per_frame_clken		(post_frame_clken_ycbcr),	//Prepared Image data output/capture enable clock
		.per_img				(img_y), //Prepared Image brightness input
		
		//Image data has been processd
		.post_frame_vsync		(),	//Processed Image data vsync valid signal
		.post_frame_href		(),	//Processed Image data href vaild  signal
		.post_frame_addr		(post_frame_addr_sobel1), //Processed Image Address output
		.post_frame_clken		(post_frame_clken_sobel1),	//Processed Image data output/capture enable clock
		.post_img_bit			(post_img_bit_sobel1)//Processed Image Bit flag outout(1: Value, 0:inValid)
	);
	
	wire	[16:0]	vga_edge1_addr;
	wire			vga_edge1_bit;
	
	edge_buffer edge1_buffer_inst
	(
	  	.clka	(cmos_pclk), // input wire clka
	  	.wea	(1'b1), // input wire [0 : 0] wea
	  	.ena    (post_frame_clken_sobel1),
	  	.addra	(post_frame_addr_sobel1),  // input wire [16 : 0] addra
	  	.dina	(post_img_bit_sobel1), // input wire [0 : 0] dina
	  	.clkb	(clk_vid), // input wire clkb
	  	.addrb	(vga_edge1_addr), // input wire [16 : 0] addrb
	  	.doutb  (vga_edge1_bit) // output wire [0 : 0] doutb
	);

    wire			post_frame_clken_sobel2;	//Processed Image data output/capture enable clock
	wire	[16:0]	post_frame_addr_sobel2;    //Processed Image Address output
	wire			post_img_bit_sobel2;		//Processed Image brightness output

    sobel_edge_detector
	#(
		.IMG_HDISP(9'd320),	//320*240
		.IMG_VDISP(8'd240)
	)
	sobel2_edge_detector_inst
	(
		//global clock
		.clk					(cmos_pclk),  //cmos video pixel clock
		.rst_n					(rst_n),	//global reset
		
		//user interface
		.sobel_threshold		(threshold),	//Sobel Threshold for image edge detect

		//Image data prepred to be processd
		.per_frame_vsync		(post_frame_vsync_gauss),	//Prepared Image data vsync valid signal
		.per_frame_href			(post_frame_href_gauss),	//Prepared Image data href vaild  signal
		.per_frame_clken		(post_frame_clken_gauss),	//Prepared Image data output/capture enable clock
		.per_img				(post_y2), //Prepared Image brightness input
		
		//Image data has been processd
		.post_frame_vsync		(),	//Processed Image data vsync valid signal
		.post_frame_href		(),	//Processed Image data href vaild  signal
		.post_frame_addr		(post_frame_addr_sobel2), //Processed Image Address output
		.post_frame_clken		(post_frame_clken_sobel2),	//Processed Image data output/capture enable clock
		.post_img_bit			(post_img_bit_sobel2)//Processed Image Bit flag outout(1: Value, 0:inValid)
	);
	
	wire	[16:0]	vga_edge2_addr;
	wire			vga_edge2_bit;
	
	edge_buffer edge2_buffer_inst
	(
	  	.clka	(cmos_pclk), // input wire clka
	  	.wea	(1'b1), // input wire [0 : 0] wea
	  	.ena    (post_frame_clken_sobel2),
	  	.addra	(post_frame_addr_sobel2),  // input wire [16 : 0] addra
	  	.dina	(post_img_bit_sobel2), // input wire [0 : 0] dina
	  	.clkb	(clk_vid), // input wire clkb
	  	.addrb	(vga_edge2_addr), // input wire [16 : 0] addrb
	  	.doutb  (vga_edge2_bit) // output wire [0 : 0] doutb
	);

	wire			vga_binary_bit_filter;
	
    Filter_bit i_Filter_bit1(
        .clk        (clk_vid     ),              // 时钟信号
        .rst_n        (rst_n     ),              // 复位信号
        .data_in    (vga_binary_bit ),          // 输入数据
        .data_out   (vga_binary_bit_filter)         // 输出数据
    );

	wire [8:0]	    h_min ;    
    wire [8:0]	    h_max ;    
    wire [8:0]	    v_min ;    
    wire [8:0]	    v_max ;    
    
    square_frame i_square_frame(
	.clk           (clk_vid   ),  				//cmos video pixel clock
	.rst_n         (rst_n ),				//global reset
	.bin           (vga_binary_bit_filter   ),
	.addr          (vga_binary_addr  ),
	.h_min         (h_min ),
	.h_max         (h_max ),
	.v_min         (v_min ),
	.v_max         (v_max )
    );

//wire  [1:0]          x1;  
//wire  [1:0]          x2;  
//wire  [1:0]          y ;

digital_reco i_digital_reco(
    .clk               (clk_vid  ),  //时钟信号
    .rst_n             (rst_n),  //复位信号（低有效）
    .monoc             (vga_binary_bit_filter),  //单色图像像素数据
	.addr              (vga_binary_addr ),
	.h_min             (h_min),
	.h_max             (h_max),
	.v_min             (v_min),
	.v_max             (v_max),
//    .x1             (x1),
//    .x2             (x2),
//    .y              (y),
	.digit             (digit)
);

    //-----VGA display-----//
    VGA	VGA_inst
	(
		.clk_vid    (clk_vid),
		.rst_n		(rst_n),
		.img		(vga_img_data),
		.binary		(vga_binary_bit_filter),
		.sobel1		(vga_edge1_bit),
		.sobel2		(vga_edge2_bit),
		
		.addr_img	(vga_img_addr),
		.addr_binary	(vga_binary_addr),
		.addr_sobel1 (vga_edge1_addr),
		.addr_sobel2 (vga_edge2_addr),
		.h_sync		(vga_hs),
		.v_sync		(vga_vs),
		.d_out      ({vga_r,vga_g,vga_b}),
	   .h_min         (h_min ),
	   .h_max         (h_max ),
	   .v_min         (v_min ),
	   .v_max         (v_max )
	);
	
threshold i_threshold(
	.clk_sys            (clk_sys       ),  				//cmos video pixel clock
	.rst_n              (rst_n         ),				//global reset
    .button_flag        (button_flag),
    .button_data        (button_data),
    .threshold          (threshold  )
);

endmodule
