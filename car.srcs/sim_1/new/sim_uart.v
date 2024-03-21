`timescale 1ns / 1ps

module sim_uart;

reg clk;
reg         recv_done_d0;
reg         recv_done_d1;
reg rst_n;
reg         uart_rxd;
//parameter define
parameter  CLK_FREQ = 50_000_000;         //����ϵͳʱ��Ƶ��
parameter  UART_BPS = 115200;           //���崮�ڲ�����

//wire define
wire        flag;
reg        recv_done;
reg [7:0]  recv_data = 8'd0;
wire pwm1,pwm2,pwm3,pwm4;

//����recv_done�����أ��õ�һ��ʱ�����ڵ������ź�
assign flag = (~recv_done_d1) & recv_done_d0;
                                                 
//�Է���ʹ���ź�recv_done�ӳ�����ʱ������
always @(posedge clk) begin         
                                  
        recv_done_d0 <= recv_done;                               
        recv_done_d1 <= recv_done_d0;          
end

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
    rst_n <= 1'b0;
    #1000;
    rst_n <= 1'b1;
    

end

//���ڽ���ģ��     
uart_recv #(                          
    .CLK_FREQ       (CLK_FREQ),         //����ϵͳʱ��Ƶ��
    .UART_BPS       (UART_BPS))         //���ô��ڽ��ղ�����
u_uart_recv(                 
    .sys_clk        (clk), 
    .sys_rst_n      (rst_n),
    .uart_rxd       (uart_rxd),
    .uart_done      (recv_done),
    .uart_data      (recv_data)
);

endmodule
