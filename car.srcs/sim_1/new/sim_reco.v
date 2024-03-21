module sim_reco ;

//reg [8:0]	    h_min=9'd319;
//reg [8:0]	    h_max=9'd0;
//reg [8:0]	    v_min=9'd239;
//reg [8:0]	    v_max=9'd0;
wire [8:0]	    h_min;
wire [8:0]	    h_max;
wire [8:0]	    v_min;
wire [8:0]	    v_max;
reg rst_n = 0,clk = 0;
reg [16:0] addr = 0;
wire        monoc;
reg		[9:0]	h_cnt;
reg		[9:0]	v_cnt;
reg    [3:0]    digit = 0;

//localparam define
localparam FP_1_3 = 6'b010101;                   // 1/3 小数的定点化  21
localparam FP_2_3 = 6'b101011;                   // 2/3              43
localparam FP_2_5 = 6'b011010;                   // 2/5              26
localparam FP_3_5 = 6'b100110;                   // 3/5              38

//wire define
wire [8:0]  h,v;
wire        down;
wire        flag_en;
wire        monoc_fall;
wire        h_flag_fall ;

//reg define
reg                 flag_reg1=0;
reg                 flag_en1 = 0,flag_en2 = 0,flag_en3 = 0,flag_en4 = 0;
reg                 monoc_d0 = 0;

wire  [8:0]          v25                           ;  // 行边界的2/5
wire  [8:0]          v23                           ;  // 行边界的2/3
wire  [8:0]          cent_h                           ;  //被测数字的中间横坐标
wire  [15:0]         v25_t                          ;
wire  [15:0]         v23_t                           ;
wire  [10:0]          cent_h_t                         ;

reg                 row_area=0 , col_area=0    ;  // 行区域  列区域
reg  [8:0]	         h_min_r=0,h_max_r=0,v_min_r=0,v_max_r=0;
reg  [ 1:0]         h_flag=2'b11             ;  //y坐标上的数据 
reg  [ 1:0]         y=0                  ;  //y的特征数
reg                 x1_l=0               ;  //x1的左边特征数
reg                 x1_r=0               ;  //x1的右边特征数 
reg                 x2_l=0               ;  //x2的左边特征数
reg                 x2_r=0               ;  //x2的右边特征数
reg  [ 3:0]         digit_id = 0                        ;

//*****************************************************
//**                  simulation  
//*****************************************************

// Generate the 25.0MHz CPU/AXI clk
initial
begin
   forever
   begin
      clk <= 1'b1;
      #20;
      clk <= 1'b0;
      #20;
   end
end

initial
begin
    rst_n <= 1'b0;
    #5000;
    rst_n <= 1'b1;
end

	// h_cnt	
	always @(posedge clk or negedge rst_n)
	begin
		if(!rst_n)
			h_cnt <= 10'd0;
		else if(h_cnt == 10'd799)
			h_cnt <= 10'd0;
		else
			h_cnt <= h_cnt + 1'b1;
	end

	// v_cnt		
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n)
			v_cnt <= 10'd0;
		else if(v_cnt == 10'd524 && h_cnt == 10'd799)
			v_cnt <= 10'd0;
		else if(h_cnt == 10'd799)
			v_cnt <= v_cnt + 1'b1;
	end

	// addr_binary
	always @(posedge clk or negedge rst_n)
	begin
		if(!rst_n)
			addr <= 17'd0;
		else if(v_cnt >= 10'd35 && v_cnt < 10'd275 && h_cnt >= 10'd464 && h_cnt < 10'd784) begin
			if(v_cnt == 10'd35 && h_cnt == 10'd464)
				addr <= 17'd0;
			else
				addr <= addr + 1'b1;
		end
	end
	
img_bit i_img_bit (
  .clka(clk),    // input wire clka
  .addra(addr),  // input wire [16 : 0] addra
  .douta(monoc)  // output wire [0 : 0] douta
);

//*****************************************************
//**                    main code
//*****************************************************

assign  monoc_fall       = (!monoc) & monoc_d0;
assign h = (addr + 1) % 320; //
assign v = (addr + 1) / 320; // 
assign h_flag_fall  = ~h_flag[0] & h_flag[1];
assign down = (addr == 17'd76799) ? 1'b1:1'b0;

assign v25_t = v_min_r * FP_3_5 + v_max_r * FP_2_5;
assign v23_t = v_min_r * FP_1_3 + v_max_r * FP_2_3;
assign cent_h = cent_h_t[10:1];
assign v25 =  v25_t >> 6;
assign v23 =  v23_t >> 6;
assign cent_h_t = h_min_r + h_max_r;

//捕获flag上升沿，得到一个时钟周期的脉冲信号
assign flag_en = (~flag_reg1) & down;

//寄存以找上升沿 下降沿
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        flag_reg1 <= 0;
        monoc_d0 <= 0;
    end
    else begin 
        flag_reg1 <= down; 
        monoc_d0 <= monoc;
    end
end

//延迟flag
always @(posedge clk) begin
    flag_en1 <= flag_en;
    flag_en2 <= flag_en1;
    flag_en3 <= flag_en2;
    flag_en4 <= flag_en3;
end

// 寄存框数值
always @(posedge clk or negedge rst_n) 
begin
	if(!rst_n)begin
        h_min_r <= 10'b0;
        h_max_r <= 10'b0;
        v_min_r <= 10'b0;
        v_max_r <= 10'b0;
	end
	else if(flag_en1)begin // 落后一拍，寄存框值
        h_min_r <= h_min;
        h_max_r <= h_max;
        v_min_r <= v_min;
        v_max_r <= v_max;
    end        
    else begin
        h_min_r <= h_min_r;
        h_max_r <= h_max_r;
        v_min_r <= v_min_r;
        v_max_r <= v_max_r;
    end        
end

always @(*) begin
    row_area = (h >= h_min_r && h <= h_max_r); //行区域
    col_area = (v >= v_min_r && v <= v_max_r); //列区域
end

//x1与x2的特征数
always @(posedge clk) begin
    if(addr) begin
        if(v == v25) begin
            if(h >= h_min && h <= cent_h && monoc_fall) // col_border_l 左边界
                x1_l <= 1'b1;
            else if(h > cent_h && h < h_max && monoc_fall) // col_border_r 右边界
                x1_r <= 1'b1;
            else
                x1_r <= x1_r;
        end
        else if(v == v23) begin
            if(h >= h_min && h <= cent_h && monoc_fall)
                x2_l <= 1'b1;
            else if(h > cent_h && h < h_max && monoc_fall)
                x2_r <= 1'b1;
            else
                x2_r <= x2_r;
        end
    end
    else begin // gai
        x1_l <= 1'b0;
        x1_r <= 1'b0;
        x2_l <= 1'b0;
        x2_r <= 1'b0;
    end
end

//寄存y_flag，找下降沿
always @(posedge clk) begin
    if(addr)
        if(row_area && h == cent_h)
            h_flag <= {h_flag[0],monoc};
        else
            h_flag <= h_flag;
    else
        h_flag <= 2'b11;
end

//Y方向的特征数
always @(posedge clk) begin
    if(addr)
        if(h == cent_h + 1'b1 && h_flag_fall)
            y <= y + 1'd1;
        else
            y <= y;
    else
        y <= 2'd0;
end

//特征匹配
always @(*) begin
    case({y,x1_l,x1_r,x2_l,x2_r})
        6'b10_1_1_1_1: digit_id = 4'h0; //0
        6'b01_1_0_1_0: digit_id = 4'h1; //1
        6'b11_0_1_1_0: digit_id = 4'h2; //2
        6'b11_0_1_0_1: digit_id = 4'h3; //3
        6'b10_1_1_1_0: digit_id = 4'h4; //4
        6'b11_1_0_0_1: digit_id = 4'h5; //5
        6'b11_1_0_1_1: digit_id = 4'h6; //6
        6'b10_0_1_1_0: digit_id = 4'h7; //7
        6'b11_1_1_1_1: digit_id = 4'h8; //8
        6'b11_1_1_0_1: digit_id = 4'h9; //9
        default: digit_id <= 4'h0;
    endcase
end

//输出识别到的数字
always @(posedge clk) begin
    if(flag_en)
        digit <= digit_id;
end

    square_frame i_square_frame(
	.clk           (clk   ),  				//cmos video pixel clock
	.rst_n         (rst_n ),				//global reset
	.bin           (monoc   ),
	.addr          (addr  ),	
	.h_min         (h_min ),
	.h_max         (h_max ),
	.v_min         (v_min ),
	.v_max         (v_max )
    );
    
endmodule