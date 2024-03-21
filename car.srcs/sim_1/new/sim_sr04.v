module sim_sr04;

reg             clk = 0;
reg rst_n;
wire [7:0] distance;
reg       echo = 0;
wire      trig;

// Generate the 50.0MHz CPU/AXI clk
initial
begin
   forever
   begin
      clk <= 1'b1;
      #10;
      clk <= 1'b0;
      #10;
   end
end

initial
begin
    rst_n <= 1'b0;
    #1000;
    rst_n <= 1'b1;
    
    #1000000;
    echo <= 1;
    #2000000;
    echo <= 0;
    
    #70000000;
    echo <= 1;
    #1000000;
    echo <= 0;
end

parameter     INTERVAL = 5_000_000; //100ms
 
reg   [22:0]        cnt    ;
reg   [24:0]        echo_cnt_reg[3:0], echo_cnt;
wire   [21:0]       echo_mean;
reg   [1:0]         addr;
reg                 echo_1,echo_2;
wire                echo_h,echo_d;

assign echo_h = (~echo_2) & echo_1;            
assign echo_d = (~echo_1) & echo_2;    
assign trig = (cnt < 500) ? 1 : 0;
assign distance = echo_mean * 78 / 1_000_000;
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
        if(addr == 3)
            addr <= 0;
        else 
            addr <= addr + 1;
        echo_cnt_reg[addr] <= echo_cnt;
    end
    else
        addr <= addr;
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