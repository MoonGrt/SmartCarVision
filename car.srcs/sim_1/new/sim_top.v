`timescale 1ns / 1ps

module sim_top;

reg             clk = 0;
wire pwm1,pwm2,pwm3,pwm4;
reg             uart_txd = 1;
reg [3:0] i;
reg [7:0] tx_data = 8'h47;
reg rst_n;

// Generate the 50.0MHz CPU/AXI clk
initial
begin
   forever
   begin
      clk <= 1'b1;
      #10;
      clk <= 1'b0;
      #10;
   end
end

initial
begin
    i <= 0;
    rst_n <= 0;
    #1000;
    rst_n <= 1;
    for(i=0;i<10;i=i+1)
        #8680;
end

//根据发送数据计数器来给uart发送端口赋值
always @(*) begin        
    if(!rst_n)
        uart_txd <= 1'b1;
    else
        case(i)
            4'd0: uart_txd <= 1'b0;         //起始位 
            4'd1: uart_txd <= tx_data[0];   //数据位最低位
            4'd2: uart_txd <= tx_data[1];
            4'd3: uart_txd <= tx_data[2];
            4'd4: uart_txd <= tx_data[3];
            4'd5: uart_txd <= tx_data[4];
            4'd6: uart_txd <= tx_data[5];
            4'd7: uart_txd <= tx_data[6];
            4'd8: uart_txd <= tx_data[7];   //数据位最高位
            4'd9: uart_txd <= 1'b1;         //停止位
            default: ;
        endcase
end

top i_top(
    .clk         (clk     ),          // clk input
    .rst_n       (rst_n   ),
    .uart_rxd    (uart_txd),
    .pwm1        (pwm1    ),
    .pwm2        (pwm2    ),
    .pwm3        (pwm3    ),
    .pwm4        (pwm4    )
);

endmodule
