module binarization1(
    //module clock
    input               clk             ,   // ʱ���ź�
    input               rst_n           ,   // ��λ�źţ�����Ч��

    //ͼ����ǰ�����ݽӿ�
    input               pre_frame_vsync ,   // vsync�ź�
    input               pre_frame_hsync ,   // hsync�ź�
    input               pre_frame_de    ,   // data enable�ź�
    input   [7:0]       y           ,
    input   [7:0]	    threshold,	//lcd pwn signal, l:valid

    //ͼ���������ݽӿ�
    output              post_frame_vsync,   // vsync�ź�
    output              post_frame_hsync,   // hsync�ź�
    output              post_frame_de   ,   // data enable�ź�
    output   reg        monoc           ,   // monochrome��1=�ף�0=�ڣ�
    output	[16:0]	    post_frame_addr

    //user interface
);

//reg define
reg    pre_frame_vsync_d;
reg    pre_frame_hsync_d;
reg    pre_frame_de_d   ;
reg		[17:0]	frame_addr;

//*****************************************************
//**                    main code
//*****************************************************

assign  post_frame_vsync = pre_frame_vsync_d  ;
assign  post_frame_hsync = pre_frame_hsync_d  ;
assign  post_frame_de    = pre_frame_de_d     ;
assign	post_frame_addr  = frame_addr[17:1];

//��ֵ��
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        monoc <= 1'b0;
        // y > 35 - threshold && y < 35 + threshold && Cb > 212 - threshold && Cb < 212 + threshold && Cr > 114 - threshold && Cr < 114 + threshold  // ��ɫ  y 35 && Cb 212 && Cr 114 
        // y > threshold
        // Cb > 77 && Cb < 127 && Cr >133 && Cr <173 //��ɫ
    else if(y > threshold)  //��ֵ 
        monoc <= 1'b1;
    else
        monoc <= 1'b0;
end

//��ʱ2����ͬ��ʱ���ź�
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        pre_frame_vsync_d <= 1'd0;
        pre_frame_hsync_d <= 1'd0;
        pre_frame_de_d    <= 1'd0;
    end
    else begin
        pre_frame_vsync_d <= pre_frame_vsync;
        pre_frame_hsync_d <= pre_frame_hsync;
        pre_frame_de_d    <= pre_frame_de   ;
    end
end

always @(posedge clk or negedge rst_n) 
begin
	if(!rst_n)
		frame_addr <= 18'd0;
	else if(!post_frame_vsync) begin
		if(post_frame_hsync)
			frame_addr <= frame_addr + 1'b1;
	end
	else
		frame_addr <= 18'd0;
end

endmodule
