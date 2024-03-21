`timescale 1ns / 1ps
module sim_motor1(
    input           clk,
    input           rst_n,
    input           motor_en,
    input           mode,
    input  [7:0]    data,
    input   [7:0]   uart_data,
    
    output reg     pwm1,
    output reg     pwm2,
    output reg     pwm3,
    output reg     pwm4
);
















parameter SP = 2000;
localparam[7:0]   UP    = 8'h47,
			      DOWN  = 8'h4b,
			      LEFT  = 8'h48,
			      RIGHT = 8'h4a,
			      STOP  = 8'h49;

reg  [12:0]   pulse1 = 0, pulse2 = 0, pulse3 = 0, pulse4 = 0;
reg  [12:0]   cnt = 0;

always @ (posedge clk or negedge rst_n)begin
    if(!rst_n)
        cnt <= 0;
    else if (cnt==13'd5000)//
        cnt <= 0;
    else
        cnt <= cnt + 1;
end

always @ (posedge clk or negedge rst_n)begin
    if(!rst_n)
        pwm1 <= 1'b0;
    else if (cnt < pulse1)
        pwm1 <= 1'b1;
    else
        pwm1 <= 1'b0;
end

always @ (posedge clk or negedge rst_n)begin
    if(!rst_n)
        pwm2 <= 1'b0;
    else if (cnt < pulse2)
        pwm2 <= 1'b1;
    else
        pwm2 <= 1'b0;
end

always @ (posedge clk or negedge rst_n)begin
    if(!rst_n)
        pwm3 <= 1'b0;
    else if (cnt < pulse3)
        pwm3 <= 1'b1;
    else
        pwm3 <= 1'b0;
end

always @ (posedge clk or negedge rst_n)begin
    if(!rst_n)
        pwm4 <= 1'b0;
    else if (cnt < pulse4)
        pwm4 <= 1'b1;
    else
        pwm4 <= 1'b0;
end

always @(posedge clk or negedge rst_n) begin        
    if(!rst_n)begin
        pulse1 <= 0;
        pulse2 <= 0;
        pulse3 <= 0;
        pulse4 <= 0;
    end
    else if(mode)
        if(motor_en)
            case ( data )
                UP    : begin pulse1 <=  0; pulse2 <= SP; pulse3 <=  0; pulse4 <= SP; end
                DOWN  : begin pulse1 <= SP; pulse2 <=  0; pulse3 <= SP; pulse4 <=  0; end
                LEFT  : begin pulse1 <=  0; pulse2 <= SP; pulse3 <= SP; pulse4 <=  0; end
                RIGHT : begin pulse1 <= SP; pulse2 <=  0; pulse3 <=  0; pulse4 <= SP; end
                STOP  : begin pulse1 <=  0; pulse2 <=  0; pulse3 <=  0; pulse4 <=  0; end
            default:    begin pulse1 <=  0; pulse2 <=  0; pulse3 <=  0; pulse4 <=  0; end
            endcase                             
        else begin
            pulse1 <=  0; pulse2 <=  0; pulse3 <=  0; pulse4 <=  0;
        end
    else
        case ( uart_data )
            UP    : begin pulse1 <=  0; pulse2 <= SP; pulse3 <=  0; pulse4 <= SP; end
            DOWN  : begin pulse1 <= SP; pulse2 <=  0; pulse3 <= SP; pulse4 <=  0; end
            LEFT  : begin pulse1 <=  0; pulse2 <= SP; pulse3 <= SP; pulse4 <=  0; end
            RIGHT : begin pulse1 <= SP; pulse2 <=  0; pulse3 <=  0; pulse4 <= SP; end
            STOP  : begin pulse1 <=  0; pulse2 <=  0; pulse3 <=  0; pulse4 <=  0; end
        default:    begin pulse1 <=  0; pulse2 <=  0; pulse3 <=  0; pulse4 <=  0; end
        endcase               
end

endmodule
