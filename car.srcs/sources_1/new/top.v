`timescale 1ns / 1ps

module top(
    // System Interface
	input	wire			clk_sys,        //50MHz
	input	wire			rst_n,          //Global Reset
	
	// Key
	input           [3:0]   col,
    output          [3:0]   row,
	
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
	
	//数码管
	output [7:0]    seg,
    output [5:0]    an,
    
    //uart
    input           uart_rxd,
    input           uart1_rxd,
    output          uart_txd,
    output          uart1_txd,
    
    //sr04
    input           echo   ,
    output wire     trig   ,
    
    //motor
    output          pwm1,
    output          pwm2,
    output          pwm3,
    output          pwm4
    );
    
wire        button_flag;
wire [3:0]  button_data;
wire [3:0] digit,digit_set;
wire  [7:0]  threshold;
wire [7:0] distance; //cm

ajxd i_ajxd(        //调用按键消抖动IP
    .clk        (clk_sys),
    .col        (col),
    .row        (row),
    .flag       (button_flag),
    .data       (button_data)
    );

digital_tube i_digital_tube(
    .clk            (clk_sys),
    .digit          (digit),
    .digit_set      (digit_set),
    .distance       (distance),
    .threshold_data (threshold),
    .seg            (seg),
    .an             (an)
);
    
CAM_RECO i_CAM_RECO
(
	.clk_sys           (clk_sys    ),        //50MHz
	.reset_n           (rst_n    ),        //Global Reset
	.vga_r             (vga_r      ),
	.vga_g             (vga_g      ),
	.vga_b             (vga_b      ),
	.vga_hs            (vga_hs     ),
	.vga_vs            (vga_vs     ),	
	.cmos_sclk         (cmos_sclk  ),
	.cmos_rst_n        (cmos_rst_n ),
	.cmos_sdat         (cmos_sdat  ),
	.cmos_vsync        (cmos_vsync ),
	.cmos_href         (cmos_href  ),
	.cmos_pclk         (cmos_pclk  ),	
	.cmos_xclk         (cmos_xclk  ),
	.cmos_data         (cmos_data  ),
	.threshold         (threshold  ),
	.button_flag       (button_flag),
    .button_data       (button_data),
    .digit             (digit      )
);
    
car i_car(
    .clk            (clk_sys      ),          // clk input
    .rst_n          (rst_n    ),
    .uart_rxd       (uart_rxd ),
    .uart1_rxd      (uart1_rxd),
    .uart_txd       (uart_txd ),
    .uart1_txd      (uart1_txd),
    .echo           (echo     ),
    .trig           (trig     ),
    .distance       (distance),
    .pwm1           (pwm1     ),
    .pwm2           (pwm2     ),
    .pwm3           (pwm3     ),
    .pwm4           (pwm4     ),
    .digit          (digit    ),
    .digit_set      (digit_set),
	.button_flag       (button_flag),
    .button_data       (button_data)
    );
    
    
endmodule
