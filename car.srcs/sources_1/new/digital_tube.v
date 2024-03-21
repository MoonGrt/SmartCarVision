module digital_tube(
    input clk,
    input   [7:0]     distance,
	input     [3:0]     digit,
	input     [3:0]     digit_set,
    input [7:0] threshold_data,
    output [7:0] seg,
    output [5:0] an
);

reg[14:0] divclk_cnt = 0;      //分频计数值
reg divclk = 0;                //分频后的时钟
reg [7:0] seg=0;               //段码
reg [5:0] an=6'b111110;        //位码
reg [3:0] disp_dat=0;          //要显示的数据    
reg [2:0] disp_bit=1;          //要显示的位       
parameter maxcnt=25000;

wire   [3:0]              data1    ;        //个位
wire   [3:0]              data2    ;        //十位
wire   [3:0]              data3    ;        //百位
wire   [3:0]              data4    ;        //千位
wire   [3:0]              data5    ;        //万位
wire   [3:0]              data6    ;        //十万位

assign  data1 = digit;               
assign  data2 = digit_set   ;    
assign  data3 = distance % 4'd10;                  
assign  data4 = (distance / 4'd10) % 4'd10   ;     
assign  data5 = threshold_data % 4'd10;
assign  data6 = (threshold_data / 4'd10) % 4'd10   ;

always@(posedge clk) 
begin
    if(divclk_cnt==maxcnt)
    begin
        divclk =~ divclk;
        divclk_cnt = 0;
    end
    else
         divclk_cnt = divclk_cnt + 1'b1;
end

always@(posedge divclk)
begin
    if (disp_bit>=5)
        disp_bit=0;
    else
        disp_bit=disp_bit+1;
    case (disp_bit)
		3'h0 :
		begin
		 disp_dat=data1;
		 an = 6'b111110; //显示第一个数码管,低电平有效
		end  
		3'h1 :
		begin
		 disp_dat=data2;
		 an = 6'b111101; //显示第二个数码管，低电平有效
		end
		3'h2 :
	   begin
		 disp_dat=data3;           
		 an = 6'b111011; //显示第三个数码管，低电平有效
	   end
		3'h3 :
		begin
		  disp_dat=data4; 
		  an = 6'b110111; //显示第四个数码管，低电平有效
		end
		3'h4 :
		begin
		  disp_dat=data5; 
		  an = 6'b101111; //显示第五个数码管，低电平有效
		end
		3'h5 :
		begin
		  disp_dat=data6;
		  an = 6'b011111; //显示第六个数码管，低电平有效
		end
		default:
		begin
			disp_dat=0;
			an = 6'b111111;
		end
	endcase 
end

always @ (disp_dat)
begin
	case (disp_dat)
	4'h0 : seg = 8'h3f; //显示"0"
	4'h1 : seg = 8'h06; //显示"1"
	4'h2 : seg = 8'h5b; //显示"2"
	4'h3 : seg = 8'h4f; //显示"3"
	4'h4 : seg = 8'h66; //显示"4"
	4'h5 : seg = 8'h6d; //显示"5"
	4'h6 : seg = 8'h7d; //显示"6"
	4'h7 : seg = 8'h07; //显示"7"
	4'h8 : seg = 8'h7f; //显示"8"
	4'h9 : seg = 8'h6f; //显示"9"
//	4'ha : seg = 8'h77; //显示"a"
//	4'hb : seg = 8'h7c; //显示"b"
//	4'hc : seg = 8'h39; //显示"c"
//	4'hd : seg = 8'h5e; //显示"d"
//	4'he : seg = 8'h79; //显示"e"
//	4'hf : seg = 8'h71; //显示"f"
	default: seg = 8'h3f; 
	endcase
end   

endmodule
