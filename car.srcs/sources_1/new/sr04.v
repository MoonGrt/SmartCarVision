module sr04(
    input               clk    ,
    input               rst_n  ,
    input               echo   ,
    output wire         trig   ,
    output              echo_d,
    output    [7:0]     distance
    );

parameter     INTERVAL = 5_000_000; //100ms
 
reg   [22:0]        cnt    ;
reg   [24:0]        echo_cnt_reg[3:0], echo_cnt;
wire   [21:0]       echo_mean;
reg   [1:0]         addr;
reg                 echo_1,echo_2;
wire                echo_flag;
wire                echo_h;

assign echo_h = (~echo_2) & echo_1;            
assign echo_d = (~echo_1) & echo_2;    
assign trig = (cnt < 500) ? 1 : 0;
assign distance = echo_mean * 39 / 1_000_000; //×¢Òâ³ý2
assign echo_mean = (echo_cnt_reg[0]+echo_cnt_reg[1]+echo_cnt_reg[2]+echo_cnt_reg[3]) >> 2;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        addr <= 0;
        echo_cnt_reg[0] <= 0;
        echo_cnt_reg[1] <= 0;
        echo_cnt_reg[2] <= 0;
        echo_cnt_reg[3] <= 0;
    end
    else if(echo_d)begin
        echo_cnt_reg[addr] <= echo_cnt;
        if(addr == 3)
            addr <= 0;
        else 
            addr <= addr + 1;
    end
    else begin
        addr <= addr;
        echo_cnt_reg[addr] <= echo_cnt_reg[addr];
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        cnt <= 0;
    end
    else if(cnt == INTERVAL)
        cnt <= 0;
    else
        cnt <= cnt + 1'b1;
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        echo_1 <= 0;
        echo_2 <= 0;
    end
    else begin
        echo_1 <= echo  ;
        echo_2 <= echo_1;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        echo_cnt <= 0;
    else if(!cnt)
        echo_cnt <= 0;
    else if(echo)
        echo_cnt <= echo_cnt + 1;
    else
        echo_cnt <= echo_cnt;    
end

endmodule