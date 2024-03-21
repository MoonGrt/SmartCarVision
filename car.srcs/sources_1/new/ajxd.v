`timescale 1ns / 1ps
module ajxd(
    input clk,
    input [3:0] col,
    output reg [3:0] row=4'b0001,
    output reg flag = 0,
    output reg [3:0]  data,
    output reg [7:0]  trans_data = 0
    );

reg[15:0] btn=0;    
reg[15:0] btn0=0;
reg[15:0] btn1=0;
reg[15:0] btn2=0;
wire [15:0] btn_out;
reg[31:0] cnt = 0;             
reg[31:0] btnclk_cnt = 0;
reg clk_ms = 0;
reg clk_20ms = 0;
      
 always@(posedge clk) //把系统时钟分频 50M/1000=50000 1000HZ
 begin
     if(cnt==15'd25000)
     begin
         clk_ms =~ clk_ms;
         cnt = 0;
     end
     else
     begin
          cnt = cnt + 1'b1;
     end
 end
 always@(posedge clk) //20MS 50M/50=1000000 50HZ
 begin
     if(btnclk_cnt==19'd500000)
     begin
         clk_20ms =~ clk_20ms;
         btnclk_cnt = 0;
     end
     else
          btnclk_cnt = btnclk_cnt+1'b1;
 end

always @ (posedge clk_ms)
begin
	if (row[3:0]==4'b1000)
	    row[3:0]=4'b0001;
	else
		row[3:0]=row[3:0]<<1; 
	     
end    

always @ (posedge clk_20ms)
begin
    if(btn_out!=0)
        flag <= 1;
    else 
        flag <= 0;
end    

reg[4:0] i=0;
always @ (posedge clk_ms)
begin
    for(i = 0; i <= 15; i = i + 1)
         if (btn_out[i] == 1) 
            data <= i;   
end

always @ (data)
begin
    case (data)
        4'd 0: trans_data = 47; // '/'   
        4'd 1: trans_data = 41; // ')'   
        4'd 2: trans_data = 48; // '0'   
        4'd 3: trans_data = 40; // '('   
        4'd 4: trans_data = 42; // '*'   
        4'd 5: trans_data = 51; // '3'   
        4'd 6: trans_data = 50; // '2'   
        4'd 7: trans_data = 49; // '1'   
        4'd 8: trans_data = 45; // '-'   
        4'd 9: trans_data = 54; // '6'   
        4'd10: trans_data = 53; // '5'   
        4'd11: trans_data = 52; // '4'   
        4'd12: trans_data = 43; // '+'   
        4'd13: trans_data = 57; // '9'   
        4'd14: trans_data = 56; // '8'   
        4'd15: trans_data = 55; // '7'   
        default: trans_data=0;   		    
    endcase
end

always @ (negedge clk_ms)
begin
    case (row[3:0])
	4'b0001:
	   begin
	   		btn[3:0]<=col;
	   end
	4'b0010:
	   begin
	      	btn[7:4]<=col;
	   end
	4'b0100:
	   begin
	        btn[11:8]<=col;
	   end
	4'b1000:
	   begin
	        btn[15:12]<=col;
	   end 
	default:btn=0;   		   
    endcase
end  

assign btn_out=(btn2&btn1&btn0)|(~btn2&btn1&btn0);
   
always@ (posedge clk_20ms)
begin
    btn0<=btn;
    btn1<=btn0;
    btn2<=btn1;
end

endmodule
