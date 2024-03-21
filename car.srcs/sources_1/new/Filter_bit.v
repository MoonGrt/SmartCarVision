module Filter_bit (
  input wire clk,              // 时钟信号
  input wire rst_n,              // 复位信号
  input wire data_in,          // 输入数据
  output reg data_out         // 输出数据
);

  reg buffer [0:2];            // 数据缓存数组

  always @(posedge clk or posedge rst_n) begin
    if (!rst_n) begin
      // 复位时将缓存数组清零
      buffer[0] <= 1'b0;
      buffer[1] <= 1'b0;
      buffer[2] <= 1'b0;
    end
    else begin
      buffer[0] <= buffer[1];// 将输入数据写入缓存数组
      buffer[1] <= buffer[2];
      buffer[2] <= data_in;
      if ((buffer[0] == buffer[2]) && (buffer[0] != buffer[1]))     // 判断当前数据是否为噪点    
        data_out <= buffer[1];// 将当前数据替换为前一个数据
      else
        data_out <= data_in;// 不是噪点，保持原始数据
    end
  end

endmodule


//module Filter_bit (
//  input wire clk,              // 时钟信号
//  input wire rst_n,              // 复位信号
//  input wire data_in,          // 输入数据
//  output reg data_out         // 输出数据
//);

//  reg buffer [0:4];            // 数据缓存数组

//  always @(posedge clk or posedge rst_n) begin
//    if (!rst_n) begin
//      // 复位时将缓存数组清零
//      buffer[0] <= 1'b0;
//      buffer[1] <= 1'b0;
//      buffer[2] <= 1'b0;
//      buffer[3] <= 1'b0;
//      buffer[4] <= 1'b0;
//    end
//    else begin
//      // 将输入数据写入缓存数组
//      buffer[0] <= buffer[1];
//      buffer[1] <= buffer[2];
//      buffer[2] <= buffer[3];
//      buffer[3] <= buffer[4];
//      buffer[4] <= data_in;

//      // 判断当前数据是否为噪点
//      if ((buffer[0] == buffer[2]) && (buffer[0] == buffer[4])) begin
//        // 将当前数据替换为缓存数组中的中间值
//        data_out <= buffer[2];
//      end
//      else begin
//        // 不是噪点，保持原始数据
//        data_out <= data_in;
//      end
//    end
//  end

//endmodule
