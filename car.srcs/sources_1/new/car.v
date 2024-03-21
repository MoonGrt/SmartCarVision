`timescale 1ns / 1ps
module car(
    input           clk,          // clk input
    input           rst_n,
    input           uart_rxd,
    input           uart1_rxd,
    output          uart_txd,
    output          uart1_txd,
    input           echo   ,
    output wire     trig   ,
    output   [7:0]  distance,
//    output   [7:0]  uart_data_reg,
    output          pwm1,
    output          pwm2,
    output          pwm3,
    output          pwm4,
    input    [3:0]  digit,
    output   reg    [3:0] digit_set,
	input   wire        button_flag,
    input   wire [3:0]  button_data
    );
    
//parameter define
parameter  CLK_FREQ = 50_000_000;         //定义系统时钟频率
parameter  UART_BPS = 115200;             //定义串口波特率

localparam[7:0]   UP    = 8'h47,
			      DOWN  = 8'h4b,
			      LEFT  = 8'h48,
			      RIGHT = 8'h4a,
			      STOP  = 8'h49;

//wire define
wire flag,uart_flag;
wire [7:0] distance; //cm
wire        recv_done;
wire [7:0]  recv_data;
wire button_flag_en;
wire motor_en;

//reg define
reg         recv_done_d0;
reg         recv_done_d1;
reg [7:0] command = STOP;
reg [7:0] uart_data_reg;
reg flag_reg1,flag_reg2;
reg           mode;

//*****************************************************
//**                    main code
//*****************************************************

//捕获上升沿，得到一个时钟周期的脉冲信号
assign button_flag_en = (~flag_reg2) & flag_reg1;
assign uart_flag = (~recv_done_d1) & recv_done_d0;
assign motor_en = (digit == digit_set);

//对发送使能信号recv_done延迟两个时钟周期
always @(posedge clk or negedge rst_n) begin         
    if (!rst_n) begin
        recv_done_d0 <= 1'b0;                                  
        recv_done_d1 <= 1'b0;
        flag_reg1 <= 0;
        flag_reg2 <= 0;
    end                                                      
    else begin                                               
        recv_done_d0 <= recv_done;                               
        recv_done_d1 <= recv_done_d0;        
        flag_reg1 <= button_flag;                               
        flag_reg2 <= flag_reg1;   
    end
end

always @(posedge clk or negedge rst_n) begin                                               
    if (!rst_n) 
        uart_data_reg <= 1'b0;
    else if(uart_flag)
        uart_data_reg <= recv_data;
    else 
        uart_data_reg <= uart_data_reg;
end

always @ (posedge clk or negedge rst_n)begin
    if(!rst_n)
        mode <= 0;
    else if (uart_data_reg == 8'd65)
        mode <= 0;
    else if (uart_data_reg == 8'd66)
        mode <= 1;
    else
        mode <= mode;
end

always @(distance) begin                                               
    if(distance < 1)
        command = DOWN;
    else if(distance > 1)
        command = UP;
    else 
        command = STOP;
end

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        digit_set <= 4'd9;
    end
    else begin
        if(button_flag_en)begin
            case (button_data)
	               4'h2 : digit_set = 4'h0;  // '0'  
	               4'h5 : digit_set = 4'h3;  // '3'  
	               4'h6 : digit_set = 4'h2;  // '2'  
	               4'h7 : digit_set = 4'h1;  // '1'  
	               4'h9 : digit_set = 4'h6;  // '6'  
	               4'ha : digit_set = 4'h5;  // '5'  
	               4'hb : digit_set = 4'h4;  // '4'  
	               4'hd : digit_set = 4'h9;  // '9'  
	               4'he : digit_set = 4'h8;  // '8'  
	               4'hf : digit_set = 4'h7;  // '7'  
                default: begin
                    digit_set <= digit_set;   	
                end	    
            endcase
        end
        else begin
            digit_set <= digit_set;
        end
    end
end

motor i_motor(
    .clk        (clk   ),
    .rst_n      (rst_n),
    .motor_en   (motor_en),
    .mode       (mode  ),
    .data       (command),
    .uart_data  (uart_data_reg),
    .pwm1       (pwm1  ),
    .pwm2       (pwm2  ),
    .pwm3       (pwm3  ),
    .pwm4       (pwm4  )
);

//串口发送模块    
uart_send #(                          
    .CLK_FREQ       (CLK_FREQ),         //设置系统时钟频率
    .UART_BPS       (UART_BPS))         //设置串口发送波特率
i_uart_send(                 
    .sys_clk        (clk),
    .sys_rst_n      (rst_n),
    .uart_en        (flag),
    .uart_din       (distance),
    .uart_tx_busy   (),
    .uart_txd       (uart_txd)
    );

//串口接收模块     
uart_recv #(                          
    .CLK_FREQ       (CLK_FREQ),         //设置系统时钟频率
    .UART_BPS       (UART_BPS))         //设置串口接收波特率
u_uart_recv(                 
    .sys_clk        (clk), 
    .sys_rst_n      (rst_n),
    .uart_rxd       (uart1_rxd),
    .uart_done      (recv_done),
    .uart_data      (recv_data)
);

sr04 i_sr04(
    .clk        (clk     ),
    .rst_n      (rst_n   ),
    .echo       (echo    ),
    .trig       (trig    ),
    .echo_d     (flag    ),
    .distance   (distance)
    );

endmodule
