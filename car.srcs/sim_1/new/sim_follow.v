`timescale 1ns / 1ps

module sim_follow();

reg             clk = 0;
wire  pwm1,pwm2,pwm3,pwm4;
wire             uart_txd;
reg rst_n;
wire [7:0] command ,distance;
reg       echo = 0;
wire      trig;
wire flag;
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
    rst_n <= 1'b0;
    #1000;
    rst_n <= 1'b1;
    
    #1000000;
    echo <= 1;
    #2000000;
    echo <= 0;
    
    #70000000;
    echo <= 1;
    #1000000;
    echo <= 0;
end

follow_car i_follow_car(
    .clk        (clk     ),          // clk input
    .rst_n      (rst_n   ),
    .uart_rxd   (),
    .uart_txd   (uart_txd),
    .echo       (echo    ),
    .trig       (trig    ),
    .command    (command),
    .distance   (distance),
    .flag       (flag),
    .seg        (     ),
    .an         (      ),
    .pwm1       (pwm1    ),
    .pwm2       (pwm2    ),
    .pwm3       (pwm3    ),
    .pwm4       (pwm4    )
    );

endmodule
