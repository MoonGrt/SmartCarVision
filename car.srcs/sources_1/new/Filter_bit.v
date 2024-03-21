module Filter_bit (
  input wire clk,              // ʱ���ź�
  input wire rst_n,              // ��λ�ź�
  input wire data_in,          // ��������
  output reg data_out         // �������
);

  reg buffer [0:2];            // ���ݻ�������

  always @(posedge clk or posedge rst_n) begin
    if (!rst_n) begin
      // ��λʱ��������������
      buffer[0] <= 1'b0;
      buffer[1] <= 1'b0;
      buffer[2] <= 1'b0;
    end
    else begin
      buffer[0] <= buffer[1];// ����������д�뻺������
      buffer[1] <= buffer[2];
      buffer[2] <= data_in;
      if ((buffer[0] == buffer[2]) && (buffer[0] != buffer[1]))     // �жϵ�ǰ�����Ƿ�Ϊ���    
        data_out <= buffer[1];// ����ǰ�����滻Ϊǰһ������
      else
        data_out <= data_in;// ������㣬����ԭʼ����
    end
  end

endmodule


//module Filter_bit (
//  input wire clk,              // ʱ���ź�
//  input wire rst_n,              // ��λ�ź�
//  input wire data_in,          // ��������
//  output reg data_out         // �������
//);

//  reg buffer [0:4];            // ���ݻ�������

//  always @(posedge clk or posedge rst_n) begin
//    if (!rst_n) begin
//      // ��λʱ��������������
//      buffer[0] <= 1'b0;
//      buffer[1] <= 1'b0;
//      buffer[2] <= 1'b0;
//      buffer[3] <= 1'b0;
//      buffer[4] <= 1'b0;
//    end
//    else begin
//      // ����������д�뻺������
//      buffer[0] <= buffer[1];
//      buffer[1] <= buffer[2];
//      buffer[2] <= buffer[3];
//      buffer[3] <= buffer[4];
//      buffer[4] <= data_in;

//      // �жϵ�ǰ�����Ƿ�Ϊ���
//      if ((buffer[0] == buffer[2]) && (buffer[0] == buffer[4])) begin
//        // ����ǰ�����滻Ϊ���������е��м�ֵ
//        data_out <= buffer[2];
//      end
//      else begin
//        // ������㣬����ԭʼ����
//        data_out <= data_in;
//      end
//    end
//  end

//endmodule
