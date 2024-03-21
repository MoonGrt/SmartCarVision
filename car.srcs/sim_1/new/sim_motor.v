`timescale 1ns / 1ps

module sim_motor;

reg             clk = 0;
reg             mode = 0;
wire pwm1,pwm2,pwm3,pwm4;
reg             uart_txd = 1;
reg [7:0] tx_data = 8'h47;
reg rst_n;
reg flag = 0;
reg [7:0] command = 8'h47;
//wire [9:0] cnt ;

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
    rst_n <= 0;
    #10000;
    rst_n <= 1;
    
    #10000;
    flag <= 1;
    command = 8'h47;
    #20;
    flag <= 0;
    
//    #100000;
//    flag <= 1;
//    command = 8'h4b;
//    #20;
//    flag <= 0;
end

motor i_motor(
    .clk        (clk   ),
    .rst_n      (rst_n),
    .motor_en   (rst_n),
    .mode       (mode  ),
    .data       (command),
    .uart_data  (tx_data),
    .pwm1       (pwm1  ),
    .pwm2       (pwm2  ),
    .pwm3       (pwm3  ),
    .pwm4       (pwm4  )
);

endmodule
