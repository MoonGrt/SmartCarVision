/*===========================================================================
15/02/1
--------------------------------------------------------------------------*/

`timescale 1ns/1ns
module	i2c_OV7670_RGB565_config
(
	input	wire	[7:0]	LUT_INDEX,
	output	reg		[15:0]	LUT_DATA,
	output	wire	[7:0]	LUT_SIZE	
);

assign LUT_SIZE = 8'd82;

/////////////////////	Config Data LUT	  //////////////////////////	
always @(*)
begin
	case(LUT_INDEX)
	0 	: 	LUT_DATA	= 	16'h0A76;
	1 	: 	LUT_DATA	= 	16'h0B73;
	2 	: 	LUT_DATA	= 	16'h1280;
	3 	: 	LUT_DATA	=	16'h1180;
	4 	: 	LUT_DATA	= 	16'h3a04;
	5 	: 	LUT_DATA	= 	16'h1214;
	6 	: 	LUT_DATA	= 	16'h1713;
	7 	: 	LUT_DATA	= 	16'h1801;
	8 	: 	LUT_DATA	= 	16'h32b6;
	9 	: 	LUT_DATA	= 	16'h1902;
	10	: 	LUT_DATA	= 	16'h1a7a;
	11	: 	LUT_DATA	= 	16'h030a;
	12 	: 	LUT_DATA	= 	16'h0c00;
	13	: 	LUT_DATA	= 	16'h3e00;
	14	: 	LUT_DATA	= 	16'h7000;
	15	: 	LUT_DATA	= 	16'h7100;
	16	: 	LUT_DATA	= 	16'h7211;
	17	: 	LUT_DATA	= 	16'h7300;
	18	: 	LUT_DATA	= 	16'ha202;
   	
    19	: 	LUT_DATA	= 	16'h7a20;
	20	: 	LUT_DATA	= 	16'h7b10;
	21	: 	LUT_DATA	= 	16'h7c1e;
	22	: 	LUT_DATA	= 	16'h7d35;
	23	: 	LUT_DATA	= 	16'h7e5a;
	24	: 	LUT_DATA	= 	16'h7f69;
	25	: 	LUT_DATA	= 	16'h8076;
	26	: 	LUT_DATA	= 	16'h8180;
	27	: 	LUT_DATA	= 	16'h8288;
	28	: 	LUT_DATA	= 	16'h838f;
	29	: 	LUT_DATA	= 	16'h8496;
	30	: 	LUT_DATA	= 	16'h85a3;
	31	: 	LUT_DATA	= 	16'h86af;
	32	: 	LUT_DATA	= 	16'h87c4;
	33	: 	LUT_DATA	= 	16'h88d7;
	34	: 	LUT_DATA	= 	16'h89e8;
	35	: 	LUT_DATA	= 	16'h13e0;
	36	: 	LUT_DATA	= 	16'h0150;
	37	: 	LUT_DATA	= 	16'h0268;
	38	: 	LUT_DATA	= 	16'h1e01; 
	
	39	: 	LUT_DATA	= 	16'h1000;
	40	: 	LUT_DATA	= 	16'h0d40;
	41	: 	LUT_DATA	= 	16'h1418;
	42	: 	LUT_DATA	= 	16'ha507;
	43	: 	LUT_DATA	= 	16'hab08;
	44	: 	LUT_DATA	= 	16'h2495;
	45	: 	LUT_DATA	= 	16'h2533;
	46	: 	LUT_DATA	= 	16'h26e3;
	47	: 	LUT_DATA	= 	16'h9f78;
	48	: 	LUT_DATA	= 	16'ha068;
	49	: 	LUT_DATA	= 	16'ha103;
	50	: 	LUT_DATA	= 	16'ha6d8;
	51	: 	LUT_DATA	= 	16'ha7d8;
	52	: 	LUT_DATA	= 	16'ha8f0;
	53	: 	LUT_DATA	= 	16'ha990;
	54	: 	LUT_DATA	= 	16'haa94;
	55	: 	LUT_DATA	= 	16'h13e5;
	56	: 	LUT_DATA	= 	16'h0e61;
	57	: 	LUT_DATA	= 	16'h0f4b;
	58	: 	LUT_DATA	= 	16'h1602;

	60	: 	LUT_DATA	= 	16'h2102;
	61	: 	LUT_DATA	= 	16'h2291;
	62	: 	LUT_DATA	= 	16'h2907;
	63	: 	LUT_DATA	= 	16'h330b;
	64	: 	LUT_DATA	= 	16'h350b;
	65	: 	LUT_DATA	= 	16'h371d;
	66	: 	LUT_DATA	= 	16'h3871;
	67	: 	LUT_DATA	= 	16'h392a;
	68	: 	LUT_DATA	= 	16'h3c78;
	69	: 	LUT_DATA	= 	16'h4d40;
	70	: 	LUT_DATA	= 	16'h4e20;
	71	: 	LUT_DATA	= 	16'h6900;
	72	: 	LUT_DATA	= 	16'h6b0a;
	73	: 	LUT_DATA	= 	16'h7410;
	74	: 	LUT_DATA	= 	16'h8d4f;
	75	: 	LUT_DATA	= 	16'h8e00;
	76	: 	LUT_DATA	= 	16'h8f00;
	77	: 	LUT_DATA	= 	16'h9000;
	78	: 	LUT_DATA	= 	16'h9100;
	79	: 	LUT_DATA	= 	16'h9266;
	80	: 	LUT_DATA	= 	16'h9600;
	81	: 	LUT_DATA	= 	16'h9a80;
    82	: 	LUT_DATA	= 	16'h1502;  //配置PCLK、HREF、VSYNC相关  //注释这个配置的话，就显示花屏了


//    0   : LUT_DATA = 16'h3a00;
//    1   : LUT_DATA = 16'h1214;
//    2   : LUT_DATA = 16'h3280;
//    3   : LUT_DATA = 16'h1716;
//    4   : LUT_DATA = 16'h1804;
//    5   : LUT_DATA = 16'h1902;
//    6   : LUT_DATA = 16'h1a7a;
//    7   : LUT_DATA = 16'h030a;
//    8   : LUT_DATA = 16'h0c0c;
//    9   : LUT_DATA = 16'h1500;
//    10  : LUT_DATA = 16'h3e00;
//    11  : LUT_DATA = 16'h7000;
//    12  : LUT_DATA = 16'h7101;
//    13  : LUT_DATA = 16'h7211;
//    15  : LUT_DATA = 16'h7309;        
//    17  : LUT_DATA = 16'ha202;
//    18  : LUT_DATA = 16'h1100;
//    19  : LUT_DATA = 16'h7a20;
//    20  : LUT_DATA = 16'h7b1c;
//    21  : LUT_DATA = 16'h7c28;
//    22  : LUT_DATA = 16'h7d3c;
//    23  : LUT_DATA = 16'h7e55;
//    24  : LUT_DATA = 16'h7f68;
//    25  : LUT_DATA = 16'h8076;
//    26  : LUT_DATA = 16'h8180;
//    27  : LUT_DATA = 16'h8288;
//    28  : LUT_DATA = 16'h838f;
//    29  : LUT_DATA = 16'h8496;
//    30  : LUT_DATA = 16'h85a3;
//    31  : LUT_DATA = 16'h86af;
//    32  : LUT_DATA = 16'h87c4;
//    33  : LUT_DATA = 16'h88d7;
//    34  : LUT_DATA = 16'h89e8;
//    35  : LUT_DATA = 16'h13e0;
//    36  : LUT_DATA = 16'h0000;
//    37  : LUT_DATA = 16'h1000;//
//    38  : LUT_DATA = 16'h0d00;
//    39  : LUT_DATA = 16'h1420;
//    40  : LUT_DATA = 16'ha505; 
//    41  : LUT_DATA = 16'hab07;
//    42  : LUT_DATA = 16'h2475;
//    43  : LUT_DATA = 16'h2563;
//    44  : LUT_DATA = 16'h26A5;
//    45  : LUT_DATA = 16'h9f78;
//    46  : LUT_DATA = 16'ha068;
//    47  : LUT_DATA = 16'ha103;
//    48  : LUT_DATA = 16'ha6df;
//    49  : LUT_DATA = 16'ha7df;
//    50  : LUT_DATA = 16'ha8f0;
//    51  : LUT_DATA = 16'ha990;
//    52  : LUT_DATA = 16'haa94;
//    53  : LUT_DATA = 16'h13e5;
//    54  : LUT_DATA = 16'h0e61;  
//    55  : LUT_DATA = 16'h0f4b;
//    56  : LUT_DATA = 16'h1602;
//    57  : LUT_DATA = 16'h1e27;
//    58  : LUT_DATA = 16'h2102;
//    59  : LUT_DATA = 16'h2291;
//    60  : LUT_DATA = 16'h2907;
//    61  : LUT_DATA = 16'h330b;
//    62  : LUT_DATA = 16'h350b;
//    63  : LUT_DATA = 16'h371d;
//    64  : LUT_DATA = 16'h3871;
//    65  : LUT_DATA = 16'h392a;
//    66  : LUT_DATA = 16'h3c78;
//    67  : LUT_DATA = 16'h4d40;
//    68  : LUT_DATA = 16'h4e20;
//    69  : LUT_DATA = 16'h695d;
//    70  : LUT_DATA = 16'h6b40;
//    71  : LUT_DATA = 16'h7419;
//    72  : LUT_DATA = 16'h8d4f;
//    73  : LUT_DATA = 16'h8e00;
//    74  : LUT_DATA = 16'h8f00;
//    75  : LUT_DATA = 16'h9000;
//    76  : LUT_DATA = 16'h9100;
//    77  : LUT_DATA = 16'h9200;
//    78  : LUT_DATA = 16'h9600;
//    79  : LUT_DATA = 16'h9a80;
//    80  : LUT_DATA = 16'hb084;
//    81  : LUT_DATA = 16'hb10c;
//    82  : LUT_DATA = 16'hb20e;
//    83  : LUT_DATA = 16'hb382;
//    84  : LUT_DATA = 16'hb80a;
//    85  : LUT_DATA = 16'h4314;
//    86  : LUT_DATA = 16'h44f0;
//    87  : LUT_DATA = 16'h4534;
//    88  : LUT_DATA = 16'h4658;
//    89  : LUT_DATA = 16'h4728;
//    90  : LUT_DATA = 16'h483a;
//    91  : LUT_DATA = 16'h5988;
//    92  : LUT_DATA = 16'h5a88;
//    93  : LUT_DATA = 16'h5b44;
//    94  : LUT_DATA = 16'h5c67;
//    95  : LUT_DATA = 16'h5d49;
//    96  : LUT_DATA = 16'h5e0e;
//    97  : LUT_DATA = 16'h6404;
//    98  : LUT_DATA = 16'h6520;
//    99  : LUT_DATA = 16'h6605;
//    100 : LUT_DATA = 16'h9404;
//    101 : LUT_DATA = 16'h9508;
//    102 : LUT_DATA = 16'h6c0a;
//    103 : LUT_DATA = 16'h6d55;
//    104 : LUT_DATA = 16'h4f80;
//    105 : LUT_DATA = 16'h5080;
//    106 : LUT_DATA = 16'h5100;
//    107 : LUT_DATA = 16'h5222;
//    108 : LUT_DATA = 16'h535e;
//    109 : LUT_DATA = 16'h5480;
//    110 : LUT_DATA = 16'h0903;
//    111 : LUT_DATA = 16'h6e11;
//    112 : LUT_DATA = 16'h6f9f;
//    113 : LUT_DATA = 16'h5500;
//    114 : LUT_DATA = 16'h5640;
//    115 : LUT_DATA = 16'h5780;
        
//	0 	: 	LUT_DATA	= 	16'h12_80; //reset all register to default values           
//	1 	: 	LUT_DATA	= 	16'h12_04; //set output format to RGB                       
//	2 	: 	LUT_DATA	= 	16'h15_20; //pclk will not toggle during horizontal blank   
//	3 	: 	LUT_DATA	=	16'h40_d0; //RGB565                                
	          
//	// These are values scalped from https://github.com/jonlwowski012/OV7670_NEXYS4_Verilog/blob/master/ov7670_registers_verilog.v
//	4 	: 	LUT_DATA	= 	16'h12_14; // COM7,     set RGB color output                    //QVGA(320*240)、RGB                                              
//	5 	: 	LUT_DATA	= 	16'h11_80; // CLKRC     internal PLL matches input clock                                                      
//	6 	: 	LUT_DATA	= 	16'h0C_00; // COM3,     default settings                                                                      
//	7 	: 	LUT_DATA	= 	16'h3E_00; // COM14,    no scaling, normal pclock                                                             
//	8 	: 	LUT_DATA	= 	16'h04_00; // COM1,     disable CCIR656                                                                       
//	9 	: 	LUT_DATA	= 	16'h40_d0; //COM15,     RGB565, full output range                                                             
//	10	: 	LUT_DATA	= 	16'h3a_04; //TSLB       set correct output data sequence (magic)                                              
//	11	: 	LUT_DATA	= 	16'h14_18; //COM9       MAX AGC value x4 0001_1000                                                            
//	12 	: 	LUT_DATA	= 	16'h4F_B3; //MTX1       all of these are magical matrix coefficients                                          
//	13	: 	LUT_DATA	= 	16'h50_B3; //MTX2                                                                                             
//	14	: 	LUT_DATA	= 	16'h51_00; //MTX3                                                                                             
//	15	: 	LUT_DATA	= 	16'h52_3d; //MTX4                                                                                             
//	16	: 	LUT_DATA	= 	16'h53_A7; //MTX5                                                                                             
//	17	: 	LUT_DATA	= 	16'h54_E4; //MTX6                                                                                             
//	18	: 	LUT_DATA	= 	16'h58_9E; //MTXS                                                                                             
//  19  : 	LUT_DATA	= 	16'h3D_C0; //COM13      sets gamma enable, does not preserve reserved bits, may be wrong?                     
//	20	: 	LUT_DATA	= 	16'h17_14; //HSTART     start high 8 bits                                                                     
//	21	: 	LUT_DATA	= 	16'h18_02; //HSTOP      stop high 8 bits //these kill the odd colored line                                    
//	22	: 	LUT_DATA	= 	16'h32_80; //HREF       edge offset                                                                           
//	23	: 	LUT_DATA	= 	16'h19_03; //VSTART     start high 8 bits                                                                     
//	24	: 	LUT_DATA	= 	16'h1A_7B; //VSTOP      stop high 8 bits                                                                      
//	25	: 	LUT_DATA	= 	16'h03_0A; //VREF       vsync edge offset                                                                     
//	26	: 	LUT_DATA	= 	16'h0F_41; //COM6       reset timings                                                                         
//	27	: 	LUT_DATA	= 	16'h1E_00; //MVFP       disable mirror / flip //might have magic value of 03                                  
//	28	: 	LUT_DATA	= 	16'h33_0B; //CHLF       //magic value from the internet                                                       
//	29	: 	LUT_DATA	= 	16'h3C_78; //COM12      no HREF when VSYNC low                                                                
//	30	: 	LUT_DATA	= 	16'h69_00; //GFIX       fix gain control                                                                      
//	31	: 	LUT_DATA	= 	16'h74_00; //REG74      Digital gain control                                                                  
//	32	: 	LUT_DATA	= 	16'hB0_84; //RSVD       magic value from the internet *required* for good color                               
//	33	: 	LUT_DATA	= 	16'hB1_0c; //ABLC1                                                                                            
//	34	: 	LUT_DATA	= 	16'hB2_0e; //RSVD       more magic internet values                                                            
//	35	: 	LUT_DATA	= 	16'hB3_80; //THL_ST                                                                                           
	
//    //begin mystery scaling numbers
//	36	: 	LUT_DATA	= 	16'h70_3a;
//	37	: 	LUT_DATA	= 	16'h71_35;
//	38	: 	LUT_DATA	= 	16'h72_11; 
//	39	: 	LUT_DATA	= 	16'h73_f0;
//	40	: 	LUT_DATA	= 	16'ha2_02;
	
//    //gamma curve values
//	41	: 	LUT_DATA	= 	16'h7a_20;
//	42	: 	LUT_DATA	= 	16'h7b_10;
//	43	: 	LUT_DATA	= 	16'h7c_1e;
//	44	: 	LUT_DATA	= 	16'h7d_35;
//	45	: 	LUT_DATA	= 	16'h7e_5a;
//	46	: 	LUT_DATA	= 	16'h7f_69;
//	47	: 	LUT_DATA	= 	16'h80_76;
//	48	: 	LUT_DATA	= 	16'h81_80;
//	49	: 	LUT_DATA	= 	16'h82_88;
//	50	: 	LUT_DATA	= 	16'h83_8f;
//	51	: 	LUT_DATA	= 	16'h84_96;
//	52	: 	LUT_DATA	= 	16'h85_a3;
//	53	: 	LUT_DATA	= 	16'h86_af;
//	54	: 	LUT_DATA	= 	16'h87_c4;
//	55	: 	LUT_DATA	= 	16'h88_d7;
//	56	: 	LUT_DATA	= 	16'h89_e8;
	
//    //AGC and AEC
//	57	: 	LUT_DATA	= 	16'h13_e0;
//	58	: 	LUT_DATA	= 	16'h00_00;
//	59  :   LUT_DATA	= 	16'h10_00;
//	60	: 	LUT_DATA	= 	16'h0d_40;
//	61	: 	LUT_DATA	= 	16'h14_18;
//	62	: 	LUT_DATA	= 	16'ha5_05;
//	63	: 	LUT_DATA	= 	16'hab_07;
//	64	: 	LUT_DATA	= 	16'h24_95;
//	65	: 	LUT_DATA	= 	16'h25_33;
//	66	: 	LUT_DATA	= 	16'h26_e3;
//	67	: 	LUT_DATA	= 	16'h9f_78;
//	68	: 	LUT_DATA	= 	16'ha0_68;
//	69	: 	LUT_DATA	= 	16'ha1_03;
//	70	: 	LUT_DATA	= 	16'ha6_d8;
//	71	: 	LUT_DATA	= 	16'ha7_d8;
//	72	: 	LUT_DATA	= 	16'ha8_f0;
//	73	: 	LUT_DATA	= 	16'ha9_90;
//	74	: 	LUT_DATA	= 	16'haa_94;
//	75	: 	LUT_DATA	= 	16'h13_e5;
//	76	: 	LUT_DATA	= 	16'h1E_23;
//	77	: 	LUT_DATA	= 	16'h69_06;
	
//	// others
//	78	: 	LUT_DATA	= 	16'h6a_0a;
	 
	 
//    0   : LUT_DATA = 16'h1204;    //复位，VGA，RGB565 (00:YUV,04:RGB)(8x全局复位)
//    1   : LUT_DATA = 16'h40d0;	//RGB565, 00-FF(d0)（YUV下要攱-FE(80))
//    2   : LUT_DATA = 16'h3a04;    //TSLB(TSLB[3], COM13[0])00:YUYV, 01:YVYU, 10:UYVY(CbYCrY), 11:VYUY
//    3   : LUT_DATA = 16'h3dc8;	//COM13(TSLB[3], COM13[0])00:YUYV, 01:YVYU, 10:UYVY(CbYCrY), 11:VYUY
//    4   : LUT_DATA = 16'h1e31;	//默认01，Bit[5]水平镜像，Bit[4]竖直镜像
//    5   : LUT_DATA = 16'h6b00;	//旁路PLL倍频?0A：关闭内部LDO?00：打开LDO
//    6   : LUT_DATA = 16'h32b6;	//HREF 控制(80)
//    7   : LUT_DATA = 16'h1713;	//HSTART 输出格式-行频开始高8位
//    8   : LUT_DATA = 16'h1801;	//HSTOP  输出格式-行频结束
//    9   : LUT_DATA = 16'h1902;	//VSTART 输出格式-场频开始高8位
//    10  : LUT_DATA = 16'h1a7a;	//VSTOP  输出格式-场频结束
//    11  : LUT_DATA = 16'h030a;	//VREF	 帧竖直方向控到0)
//    12  : LUT_DATA = 16'h0c00;	//DCW使能 禁止(00)
//    13  : LUT_DATA = 16'h3e10;	//PCLK分频00 Normal  14  : add_wdata = {2'b11,16'h7000};	//00:Normal, 80:移位1, 00:彩条, 80:渐变彩条
//    15  : LUT_DATA = 16'h7100;	//00:Normal, 00:移位1, 80:彩条, 80：渐变彩杊	        16  : add_wdata = {2'b11,16'h7211};	//默认 水平，垂直采样(11)	        
//    17  : LUT_DATA = 16'h7300;	//DSP缩放时钟分频00 
//    18  : LUT_DATA = 16'ha202;	//默认 像素始终延迟	(02)
//    19  : LUT_DATA = 16'h1180;	//内部工作时钟设置，直接使用外部时钟源(80)
//    20  : LUT_DATA = 16'h7a20;
//    21  : LUT_DATA = 16'h7b1c;
//    22  : LUT_DATA = 16'h7c28;
//    23  : LUT_DATA = 16'h7d3c;
//    24  : LUT_DATA = 16'h7e55;
//    25  : LUT_DATA = 16'h7f68;
//    26  : LUT_DATA = 16'h8076;
//    27  : LUT_DATA = 16'h8180;
//    28  : LUT_DATA = 16'h8288;
//    29  : LUT_DATA = 16'h838f;
//    30  : LUT_DATA = 16'h8496;
//    31  : LUT_DATA = 16'h85a3;
//    32  : LUT_DATA = 16'h86af;
//    33  : LUT_DATA = 16'h87c4;
//    34  : LUT_DATA = 16'h88d7;
//    35  : LUT_DATA = 16'h89e8;
//    36  : LUT_DATA = 16'h13e0;
//    37  : LUT_DATA = 16'h0010;//
//    38  : LUT_DATA = 16'h1000;
//    39  : LUT_DATA = 16'h0d00;
//    40  : LUT_DATA = 16'h1428; 
//    41  : LUT_DATA = 16'ha505;
//    42  : LUT_DATA = 16'hab07;
//    43  : LUT_DATA = 16'h2475;
//    44  : LUT_DATA = 16'h2563;
//    45  : LUT_DATA = 16'h26a5;
//    46  : LUT_DATA = 16'h9f78;
//    47  : LUT_DATA = 16'ha068;
//    48  : LUT_DATA = 16'ha103;
//    49  : LUT_DATA = 16'ha6df;
//    50  : LUT_DATA = 16'ha7df;
//    51  : LUT_DATA = 16'ha8f0;
//    52  : LUT_DATA = 16'ha990;
//    53  : LUT_DATA = 16'haa94;
//    54  : LUT_DATA = 16'h13ef;  
//    55  : LUT_DATA = 16'h0e61;
//    56  : LUT_DATA = 16'h0f4b;
//    57  : LUT_DATA = 16'h1602;
//    58  : LUT_DATA = 16'h2102;
//    59  : LUT_DATA = 16'h2291;
//    60  : LUT_DATA = 16'h2907;
//    61  : LUT_DATA = 16'h330b;
//    62  : LUT_DATA = 16'h350b;
//    63  : LUT_DATA = 16'h371d;
//    64  : LUT_DATA = 16'h3871;
//    65  : LUT_DATA = 16'h392a;
//    66  : LUT_DATA = 16'h3c78;
//    67  : LUT_DATA = 16'h4d40;
//    68  : LUT_DATA = 16'h4e20;
//    69  : LUT_DATA = 16'h6900;
//    70  : LUT_DATA = 16'h7419;
//    71  : LUT_DATA = 16'h8d4f;
//    72  : LUT_DATA = 16'h8e00;
//    73  : LUT_DATA = 16'h8f00;
//    74  : LUT_DATA = 16'h9000;
//    75  : LUT_DATA = 16'h9100;
//    76  : LUT_DATA = 16'h9200;
//    77  : LUT_DATA = 16'h9600;
//    78  : LUT_DATA = 16'h9a80;
//    79  : LUT_DATA = 16'hb084;
//    80  : LUT_DATA = 16'hb10c;
//    81  : LUT_DATA = 16'hb20e;
//    82  : LUT_DATA = 16'hb382;
//    83  : LUT_DATA = 16'hb80a;
  
//    84  : LUT_DATA = 16'h4314;
//    85  : LUT_DATA = 16'h44f0;
//    86  : LUT_DATA = 16'h4534;
//    87  : LUT_DATA = 16'h4658;
//    88  : LUT_DATA = 16'h4728;
//    89  : LUT_DATA = 16'h483a;
//    90  : LUT_DATA = 16'h5988;
//    91  : LUT_DATA = 16'h5a88;
//    92  : LUT_DATA = 16'h5b44;
//    93  : LUT_DATA = 16'h5c67;
//    94  : LUT_DATA = 16'h5d49;
//    95  : LUT_DATA = 16'h5e0e;
//    96  : LUT_DATA = 16'h6404;
//    97  : LUT_DATA = 16'h6520;
//    98  : LUT_DATA = 16'h6605;
//    99  : LUT_DATA = 16'h9404;
//    100 : LUT_DATA = 16'h9508;
//    101 : LUT_DATA = 16'h6c0a;
//    102 : LUT_DATA = 16'h6d55;
//    103 : LUT_DATA = 16'h6e11;
//    104 : LUT_DATA = 16'h6f9f;
//    105 : LUT_DATA = 16'h6a40;
//    106 : LUT_DATA = 16'h0140;
//    107 : LUT_DATA = 16'h0240;
//    108 : LUT_DATA = 16'h13e7;
//    109 : LUT_DATA = 16'h1500;
  
//    110 : LUT_DATA = 16'h4f80;
//    111 : LUT_DATA = 16'h5080;
//    112 : LUT_DATA = 16'h5100;
//    113 : LUT_DATA = 16'h5222;
//    114 : LUT_DATA = 16'h535e;
//    115 : LUT_DATA = 16'h5480;
//    116 : LUT_DATA = 16'h589e;
  
//    117 : LUT_DATA = 16'h4108;
//    118 : LUT_DATA = 16'h3f00;
//    119 : LUT_DATA = 16'h7505;
//    120 : LUT_DATA = 16'h76e1;
//    121 : LUT_DATA = 16'h4c00;
//    122 : LUT_DATA = 16'h7701;
  
//    123 : LUT_DATA = 16'h4b09;
//    124 : LUT_DATA = 16'hc9F0;//16'hc960;
//    125 : LUT_DATA = 16'h4138;
//    126 : LUT_DATA = 16'h5640;
  
  
//    127 : LUT_DATA = 16'h3411;
//    128 : LUT_DATA = 16'h3b02;
//    129 : LUT_DATA = 16'ha489;
//    130 : LUT_DATA = 16'h9600;
//    131 : LUT_DATA = 16'h9730;
//    132 : LUT_DATA = 16'h9820;
//    133 : LUT_DATA = 16'h9930;
//    134 : LUT_DATA = 16'h9a84;
//    135 : LUT_DATA = 16'h9b29;
//    136 : LUT_DATA = 16'h9c03;
//    137 : LUT_DATA = 16'h9d4c;
//    138 : LUT_DATA = 16'h9e3f;
//    139 : LUT_DATA = 16'h7804;
   
   
//    140 : LUT_DATA = 16'h7901;
//    141 : LUT_DATA = 16'hc8f0;
//    142 : LUT_DATA = 16'h790f;
//    143 : LUT_DATA = 16'hc800;
//    144 : LUT_DATA = 16'h7910;
//    145 : LUT_DATA = 16'hc87e;
//    146 : LUT_DATA = 16'h790a;
//    147 : LUT_DATA = 16'hc880;
//    148 : LUT_DATA = 16'h790b;
//    149 : LUT_DATA = 16'hc801;
//    150 : LUT_DATA = 16'h790c;
//    151 : LUT_DATA = 16'hc80f;
//    152 : LUT_DATA = 16'h790d;
//    153 : LUT_DATA = 16'hc820;
//    154 : LUT_DATA = 16'h7909;
//    155 : LUT_DATA = 16'hc880;
//    156 : LUT_DATA = 16'h7902;
//    157 : LUT_DATA = 16'hc8c0;
//    158 : LUT_DATA = 16'h7903;
//    159 : LUT_DATA = 16'hc840;
//    160 : LUT_DATA = 16'h7905;
//    161 : LUT_DATA = 16'hc830; 
//    162 : LUT_DATA = 16'h7926;
  
//    163 : LUT_DATA = 16'h0903;
//    164 : LUT_DATA = 16'h3b42;
//    165 : LUT_DATA = 16'h1214;

    default : LUT_DATA 	=  	16'h0000;
endcase
end 
endmodule
