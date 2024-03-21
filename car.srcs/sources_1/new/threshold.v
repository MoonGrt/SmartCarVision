`timescale 1ns/1ns
module threshold(
	//global clock
	input	wire			clk_sys,  				//cmos video pixel clock
	input	wire			rst_n,				//global reset
	
    input                   button_flag,
    input            [3:0]  button_data,
    output  reg 	[7:0]	threshold
);

reg flag_reg1,flag_reg2;
wire flag_en;

//����flag�����أ��õ�һ��ʱ�����ڵ������ź�
assign flag_en = (~flag_reg2) & flag_reg1;

//�Է���ʹ���ź�uart_en�ӳ�����ʱ������
always @(posedge clk_sys or negedge rst_n)begin
    if(!rst_n)begin
        flag_reg1 <= 0;
        flag_reg2 <= 0;
    end
    else begin
        flag_reg1 <= button_flag;                               
        flag_reg2 <= flag_reg1;    
    end
end

always @(posedge clk_sys or negedge rst_n)begin
    if(!rst_n)begin
        threshold <= 8'd40;
    end
    else begin
        if(flag_en)begin
            case (button_data)
                4'd 1: threshold <= threshold + 8'd2; // '+'   
                4'd 3: threshold <= threshold - 8'd2; // '-'   
                default: begin
                    threshold <= threshold;   	
                end	    
            endcase
        end
        else begin
            threshold <= threshold;
        end
    end
end

endmodule
