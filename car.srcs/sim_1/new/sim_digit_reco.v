`timescale 1ns / 1ps

module sim_digit_reco();
    
reg             clk = 0;
reg rst_n;

wire [8:0]	    h_min;    
wire [8:0]	    h_max;    
wire [8:0]	    v_min;    
wire [8:0]	    v_max;    

wire  [8:0]          v25                             ;  // 行边界的2/5
wire  [8:0]          v23                           ;  // 行边界的2/3
wire  [8:0]          cent_h                        ;  //被测数字的中间横坐标
//wire  [15:0]         v25_t                        ;
//wire  [15:0]         v23_t                         ;
//wire  [9:0]          cent_h_t                        ;
wire        down;

wire flag_en,flag_en1;
//wire flag_en_reco,flag_en_reco1,flag_en_reco2,flag_en_reco3,flag_en_reco4;
wire	[16:0]	vga_binary_addr;    
wire	[16:0]	vga_sobel1_addr;    
wire	[16:0]	vga_sobel2_addr;
wire	[16:0]	vga_img_addr;
reg	[7:0]	vga_img_data= 0;
wire			vga_binary_bit_filter;
reg			vga_sobel1_bit= 0;	
reg			vga_sobel2_bit= 0;

wire	[3:0]	vga_r;
wire	[3:0]	vga_g;
wire	[3:0]	vga_b;
wire			vga_hs;
wire			vga_vs;

// Generate the 50.0MHz CPU/AXI clk
initial
begin
   forever
   begin
      clk <= 1'b1;
      #20;
      clk <= 1'b0;
      #20;
   end
end

initial
begin
    rst_n <= 1'b0;
    #1000;
    rst_n <= 1'b1;
end
        
digital_reco i_digital_reco(
    .clk               (clk  ),  //时钟信号
    .rst_n             (rst_n),  //复位信号（低有效）
    .monoc             (vga_binary_bit_filter),  //单色图像像素数据
	.addr              (vga_binary_addr ),
//	.flag_en       (flag_en_reco),
//	.flag_en1       (flag_en_reco1),
//	.flag_en2       (flag_en_reco2),
//	.flag_en3       (flag_en_reco3),
//	.flag_en4       (flag_en_reco4),
	.h_min             (h_min),
	.h_max             (h_max),
	.v_min             (v_min),
	.v_max             (v_max),
//	.h_min_r             (h_min_r),
//	.h_max_r             (h_max_r),
//	.v_min_r             (v_min_r),
//	.v_max_r             (v_max_r),	
	.v25               (v25    ),
	.v23               (v23    ),
	.cent_h            (cent_h ),
//	.v25_t               (v25_t    ),
//	.v23_t               (v23_t    ),
//	.cent_h_t            (cent_h_t ),
	.down                (down)
);
    
    square_frame i_square_frame(
	.clk           (clk   ),  				//cmos video pixel clock
	.rst_n         (rst_n ),				//global reset
	.bin           (vga_binary_bit_filter   ),
	.addr          (vga_binary_addr  ),
	
	.flag_en       (flag_en),
	.flag_en1     (flag_en1),
	
	.h_min         (h_min ),
	.h_max         (h_max ),
	.v_min         (v_min ),
	.v_max         (v_max )
    );
    
img_bit your_instance_name (
  .clka(clk),    // input wire clka
  .addra(vga_binary_addr),  // input wire [16 : 0] addra
  .douta(vga_binary_bit_filter)  // output wire [0 : 0] douta
);

    //-----VGA display-----//
    VGA	VGA_inst
	(
		.clk_vid    (clk),
		.rst_n		(rst_n),
		.img		(vga_img_data),
		.binary		(vga_binary_bit_filter),
		.sobel1		(vga_sobel1_bit),
		.sobel2		(vga_sobel2_bit),
		
		.addr_img	(vga_img_addr),
		.addr_binary	(vga_binary_addr),
		.addr_sobel1 (vga_sobel1_addr),
		.addr_sobel2 (vga_sobel2_addr),
		.h_sync		(vga_hs),
		.v_sync		(vga_vs),
		.d_out      ({vga_r,vga_g,vga_b}),
	   .h_min         (h_min ),
	   .h_max         (h_max ),
	   .v_min         (v_min ),
	   .v_max         (v_max )
	);
	
endmodule
