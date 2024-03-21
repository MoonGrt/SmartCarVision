`timescale 1ns / 1ps
module square_frame(
	//global clock
	input	wire			clk,  				//cmos video pixel clock
	input	wire			rst_n,				//global reset
	
	input                   bin,
	input   wire   [16:0]  addr,
	output                  flag_en,flag_en1,
	output	reg [8:0]	    h_min,
	output	reg [8:0]	    h_max,
	output	reg [8:0]	    v_min,
	output	reg [8:0]	    v_max
    );
    
reg  [8:0] h_min_r,h_max_r,v_min_r,v_max_r;
wire [8:0] h,v;
wire    down;
reg flag_reg1,flag_reg2;
wire flag_en,flag_en1;

//reg data;

assign h = (addr + 1) % 320; //
assign v = (addr + 1) / 320; // 
assign down = (addr == 17'd76799) ? 1'b1:1'b0;

//捕获flag上升沿，得到一个时钟周期的脉冲信号
assign flag_en = (~flag_reg1) & down;
assign flag_en1 = (~flag_reg2) & flag_reg1;

//对发送使能信号uart_en延迟两个时钟周期
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        flag_reg1 <= 0;
        flag_reg2 <= 0;
    end
    else begin
        flag_reg1 <= down;                               
        flag_reg2 <= flag_reg1;    
    end
end

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)begin
		h_min_r <= 9'd319; 
		h_max_r <= 9'd0; 
		v_min_r <= 9'd239; 
		v_max_r <= 9'd0; 
//		data <= 0;
	end
	else if(!addr)begin
//	   if(data)begin
		  h_min_r <= 9'd319; 
		  h_max_r <= 9'd0; 
		  v_min_r <= 9'd239; 
		  v_max_r <= 9'd0; 
//		  data <= 0;
//		end
//		else begin
//		  h_min_r <= 9'd40; 
//		  h_max_r <= 9'd280; 
//		  v_min_r <= 9'd20; 
//		  v_max_r <= 9'd220; 
//		  data <= 1;
//		end
    end 
    else if(~bin && h >= 15)begin
        if(h_min_r >= h)
            h_min_r <= h;
		else
		    h_min_r <= h_min_r;
		if(h_max_r <= h)
            h_max_r <= h;
		else
		    h_max_r <= h_max_r; 	
		if(v_min_r >= v)
            v_min_r <= v;
		else
		    v_min_r <= v_min_r; 	
		if(v_max_r <= v)
            v_max_r <= v;
		else
		    v_max_r <= v_max_r;
	end
	else begin
		h_min_r <= h_min_r;
		h_max_r <= h_max_r;
		v_min_r <= v_min_r;
		v_max_r <= v_max_r;
	end
end    

//输出框值
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)begin
        h_min <= 10'b0;
        h_max <= 10'b0;
        v_min <= 10'b0;
        v_max <= 10'b0;
	end
	else if(flag_en)begin
        h_min <= h_min_r;
        h_max <= h_max_r;
        v_min <= v_min_r;
        v_max <= v_max_r;
    end        
    else begin
        h_min <= h_min;
        h_max <= h_max;
        v_min <= v_min;
        v_max <= v_max;
    end        
end

endmodule
