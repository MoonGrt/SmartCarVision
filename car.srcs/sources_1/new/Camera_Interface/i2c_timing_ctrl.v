`timescale 1ns/1ns
module	i2c_timing_ctrl
#(
	parameter CLK_FREQ = 50_000_000,
	parameter I2C_FREQ = 100_000	
)
(
	input	wire			clk,
	input	wire			rst_n,
	
	output	wire			i2c_scl,
	inout	wire			i2c_sda,
	
	output	wire			i2c_config_done
);

	reg		[16:0]	delay_cnt;
	wire			init_en;
	localparam DELAY_TOP = CLK_FREQ/1000;
	
	
	always @(posedge clk or negedge rst_n) 
	begin
		if(!rst_n) 
			delay_cnt <= 17'd0;
		else if(delay_cnt < DELAY_TOP)
			delay_cnt <= delay_cnt + 1'b1;
		else
			delay_cnt <= delay_cnt;
	end
	
	assign init_en = (delay_cnt >= DELAY_TOP-1)? 1'b1:1'b0;
	
	//assign init_en = 1'b1;
	
	reg		[15:0]	clk_cnt;
	reg				i2c_ctrl_clk;
	reg				i2c_transfer_en;
	reg				i2c_capture_en;
	
	always @(posedge clk or negedge rst_n)
	begin
		if(!rst_n) begin
			clk_cnt <= 16'd0;
			i2c_ctrl_clk <= 1'b0;
			i2c_transfer_en <= 1'b0;
			i2c_capture_en <= 1'b0;
		end
		else if(init_en) begin
			if(clk_cnt == (CLK_FREQ/I2C_FREQ)-1'b1)
				clk_cnt <= 16'd0;
			else
				clk_cnt <= clk_cnt + 1'b1;
			i2c_ctrl_clk <= ((clk_cnt >= (CLK_FREQ/I2C_FREQ)/4+1'b1)&&
							 (clk_cnt < (3*CLK_FREQ/I2C_FREQ)/4+1'b1))?1'b1:1'b0;
			i2c_transfer_en <= (clk_cnt == 16'd0)?1'b1:1'b0;
			i2c_capture_en <= (clk_cnt == (2*CLK_FREQ/I2C_FREQ)/4-1'b1)?1'b1:1'b0;
		end
		else begin
			clk_cnt <= 16'd0;
			i2c_ctrl_clk <= 1'b0;
			i2c_transfer_en <= 1'b0;
			i2c_capture_en <= 1'b0;
		end
	end
	
	localparam I2C_IDLE			= 5'd0;
	
	localparam I2C_WR_START		= 5'd1;
	localparam I2C_WR_IDADDR	= 5'd2;
	localparam I2C_WR_ACK1		= 5'd3;
	localparam I2C_WR_REGADDR	= 5'd4;
	localparam I2C_WR_ACK2		= 5'd5;
	localparam I2C_WR_REGDATA	= 5'd6;
	localparam I2C_WR_ACK3		= 5'd7;
	localparam I2C_WR_STOP		= 5'd8;
	
	localparam I2C_RD_START1	= 5'd9;
	localparam I2C_RD_IDADDR1	= 5'd10;
	localparam I2C_RD_ACK1		= 5'd11;
	localparam I2C_RD_REGADDR	= 5'd12;
	localparam I2C_RD_ACK2		= 5'd13;
	localparam I2C_RD_STOP1		= 5'd14;
	localparam I2C_RD_IDLE		= 5'd15;
	localparam I2C_RD_START2	= 5'd16;
	localparam I2C_RD_IDADDR2	= 5'd17;
	localparam I2C_RD_ACK3		= 5'd18;
	localparam I2C_RD_REGDATA	= 5'd19;
	localparam I2C_RD_NACK		= 5'd20;
	localparam I2C_RD_STOP2		= 5'd21;
	
	reg		[4:0]	c_state;
	reg		[4:0]	n_state;
	
	always @(posedge clk or negedge rst_n)
	begin
		if(!rst_n)
			c_state <= I2C_IDLE;
		else if(i2c_transfer_en)
			c_state <= n_state;
	end
	
	wire			i2c_transfer_end = (c_state == I2C_WR_STOP || c_state == I2C_RD_STOP2)?1'b1:1'b0;
	reg				i2c_ack;
	reg				i2c_ack1;
	reg				i2c_ack2;
	reg				i2c_ack3;
	reg		[7:0]	i2c_rdata;
	
	always @(posedge clk or negedge rst_n)
	begin
		if(!rst_n) begin
			{i2c_ack1,i2c_ack2,i2c_ack3} <= 3'b111;
			i2c_ack <= 1'b1;
			i2c_rdata <= 8'd0;
		end
		else if(i2c_capture_en) begin
			case(n_state)
				I2C_IDLE : begin
					{i2c_ack1,i2c_ack2,i2c_ack3} <= 3'b111;
					i2c_ack <= 1'b1;
				end
				
				I2C_WR_ACK1 : i2c_ack1 <= i2c_sda;
				I2C_WR_ACK2 : i2c_ack2 <= i2c_sda;
				I2C_WR_ACK3 : i2c_ack3 <= i2c_sda;
				I2C_WR_STOP : i2c_ack <= {i2c_ack1 | i2c_ack2 | i2c_ack3};
				
				I2C_RD_ACK1 : i2c_ack1 <= i2c_sda;
				I2C_RD_ACK2 : i2c_ack2 <= i2c_sda;
				I2C_RD_ACK3 : i2c_ack3 <= i2c_sda;
				I2C_RD_STOP2 : i2c_ack <= {i2c_ack1 | i2c_ack2 | i2c_ack3};
				I2C_RD_REGDATA : i2c_rdata <= {i2c_rdata[6:0],i2c_sda};
			endcase
		end
		else begin
			{i2c_ack1,i2c_ack2,i2c_ack3} <= {i2c_ack1,i2c_ack2,i2c_ack3};
			i2c_ack <= i2c_ack;
		end
	end
	
	wire	[7:0]	i2c_config_size;
	wire	[23:0]	i2c_config_data;
	wire	[15:0]	i2c_lut_data;
	reg		[7:0]	i2c_config_index;
	
	assign i2c_config_data = {8'h42,i2c_lut_data};
	
	always @(posedge clk or negedge rst_n) 
	begin
		if(!rst_n)
			i2c_config_index <= 8'd0;
		else if(i2c_transfer_en) begin
			if(i2c_transfer_end & ~i2c_ack) begin
				if(i2c_config_index < i2c_config_size)
					i2c_config_index <= i2c_config_index + 1'b1;
				else
					i2c_config_index <= i2c_config_size;
			end
			else
				i2c_config_index <= i2c_config_index;
		end
		else
			i2c_config_index <= i2c_config_index;
	end

	assign i2c_config_done = (i2c_config_index == i2c_config_size)?1'b1:1'b0;
	
	i2c_OV7670_RGB565_config i2c_OV7670_RGB565_config_inst
	(
		.LUT_INDEX	(i2c_config_index),
		.LUT_DATA	(i2c_lut_data),
		.LUT_SIZE	(i2c_config_size)
	);
	
	reg		[3:0]	i2c_stream_cnt;
	reg		[7:0]	i2c_wdata;
	reg				i2c_sda_out;
	
	always @(posedge clk or negedge rst_n) 
	begin
		if(!rst_n) begin
			i2c_sda_out <= 1'b1;
			i2c_stream_cnt <= 4'd0;
			i2c_wdata <= 8'd0;
		end
		else if(i2c_transfer_en) begin
			case(n_state)
				//5'd0
				I2C_IDLE : begin
					i2c_sda_out <= 1'b1;
					i2c_stream_cnt <= 4'd0;
					i2c_wdata <= 8'd0;
				end

				//5'd1
				I2C_WR_START : begin
					i2c_sda_out <= 1'b0;
					i2c_stream_cnt <= 4'd0;
					i2c_wdata <= i2c_config_data[23:16];
				end

				//5'd2
				I2C_WR_IDADDR : begin
					i2c_stream_cnt <= i2c_stream_cnt + 1'b1;
					i2c_sda_out <= i2c_wdata[3'd7-i2c_stream_cnt];
				end

				//5'd3
				I2C_WR_ACK1 : begin
					i2c_stream_cnt <= 4'd0;
					i2c_wdata <= i2c_config_data[15:8];
				end

				//5'd4
				I2C_WR_REGADDR : begin
					i2c_stream_cnt <= i2c_stream_cnt + 1'b1;
					i2c_sda_out <= i2c_wdata[3'd7-i2c_stream_cnt];
				end

				//5'd5
				I2C_WR_ACK2 : begin
					i2c_stream_cnt <= 4'd0;
					i2c_wdata <= i2c_config_data[7:0];
				end

				//5'd6
				I2C_WR_REGDATA : begin
					i2c_stream_cnt <= i2c_stream_cnt + 1'b1;
					i2c_sda_out <= i2c_wdata[3'd7-i2c_stream_cnt];
				end

				//5'd7
				I2C_WR_ACK3 : i2c_stream_cnt <= 4'd0;

				//5'd8
				I2C_WR_STOP : i2c_sda_out <= 1'b0;

				//5'd9
				I2C_RD_START1 : begin
					i2c_sda_out <= 1'b0;
					i2c_stream_cnt <= 4'd0;
					i2c_wdata <= i2c_config_data[23:16];
				end

				//5'd10
				I2C_RD_IDADDR1 : begin
					i2c_stream_cnt <= i2c_stream_cnt + 1'b1;
					i2c_sda_out <= i2c_wdata[3'd7-i2c_stream_cnt];
				end

				//5'd11
				I2C_RD_ACK1 : begin
					i2c_stream_cnt <= 4'd0;
					i2c_wdata <= i2c_config_data[15:8];
				end

				//5'd12
				I2C_RD_REGADDR : begin
					i2c_stream_cnt <= i2c_stream_cnt + 1'b1;
					i2c_sda_out <= i2c_wdata[3'd7-i2c_stream_cnt];
				end

				//5'd13
				I2C_RD_ACK2 : i2c_stream_cnt <= 4'd0;

				//5'd14
				I2C_RD_STOP1 : i2c_sda_out <= 1'b0;

				//5'd15
				I2C_RD_IDLE : i2c_sda_out <= 1'b1;
				
				//5'd16
				I2C_RD_START2 : begin
					i2c_sda_out <= 1'b0;
					i2c_stream_cnt <= 4'd0;
					i2c_wdata <= i2c_config_data[23:16];
				end

				//5'd17
				I2C_RD_IDADDR2 : begin
					i2c_stream_cnt <= i2c_stream_cnt + 1'b1;
					if(i2c_stream_cnt == 4'd8)
						i2c_sda_out <= 1'b1;
					else
						i2c_sda_out <= i2c_wdata[3'd7-i2c_stream_cnt];
				end

				//5'd18
				I2C_RD_ACK3 : i2c_stream_cnt <= 4'd0;

				//5'd19
				I2C_RD_REGDATA : i2c_stream_cnt <= i2c_stream_cnt + 1'b1;

				//5'd20
				I2C_RD_NACK : i2c_sda_out <= 1'b1;

				//5'd21
				I2C_RD_STOP2 : i2c_sda_out <= 1'b0;

				default : ;

			endcase
		end
	end
	
	// FSM
	always @( * )
	begin
		n_state = I2C_IDLE;
		case(c_state)
			// 5'd0
			I2C_IDLE : begin
				if(init_en) begin
					if(i2c_transfer_en) begin
						if(i2c_config_index < 8'd2)
							n_state = I2C_RD_START1;
						else if(i2c_config_index < i2c_config_size)
							n_state = I2C_WR_START;
						else
							n_state = I2C_IDLE;
					end
					else
						n_state = n_state;
				end
				else
					n_state = I2C_IDLE;
			end
			
			// I2C Write
			// 5'd1
			I2C_WR_START : begin
				if(i2c_transfer_en)
					n_state = I2C_WR_IDADDR;
				else
					n_state = I2C_WR_START;
			end
			
			// 5'd2
			I2C_WR_IDADDR : begin
				if(i2c_transfer_en && i2c_stream_cnt == 4'd8)
					n_state = I2C_WR_ACK1;
				else
					n_state = I2C_WR_IDADDR;
			end
			
			// 5'd3
			I2C_WR_ACK1 : begin
				if(i2c_transfer_en)
					n_state = I2C_WR_REGADDR;
				else
					n_state = I2C_WR_ACK1;
			end
			
			// 5'd4
			I2C_WR_REGADDR : begin
				if(i2c_transfer_en && i2c_stream_cnt == 4'd8)
					n_state = I2C_WR_ACK2;
				else
					n_state = I2C_WR_REGADDR;
			end
			
			// 5'd5
			I2C_WR_ACK2 : begin
				if(i2c_transfer_en)
					n_state = I2C_WR_REGDATA;
				else
					n_state = I2C_WR_ACK2;
			end

			// 5'd6
			I2C_WR_REGDATA : begin
				if(i2c_transfer_en && i2c_stream_cnt == 4'd8)
					n_state = I2C_WR_ACK3;
				else
					n_state = I2C_WR_REGDATA;
			end
			
			// 5'd7
			I2C_WR_ACK3 : begin
				if(i2c_transfer_en)
					n_state = I2C_WR_STOP;
				else
					n_state = I2C_WR_ACK3;
			end

			// 5'd8
			I2C_WR_STOP :  begin
				if(i2c_transfer_en)
					n_state = I2C_IDLE;
				else
					n_state = I2C_WR_STOP;
			end

			// I2C Read
			// 5'd9
			I2C_RD_START1 : begin
				if(i2c_transfer_en)
					n_state = I2C_RD_IDADDR1;
				else
					n_state = I2C_RD_START1;
			end

			// 5'd10
			I2C_RD_IDADDR1 : begin
				if(i2c_transfer_en && i2c_stream_cnt == 4'd8)
					n_state = I2C_RD_ACK1;
				else
					n_state = I2C_RD_IDADDR1;
			end

			// 5'd11
			I2C_RD_ACK1 : begin
				if(i2c_transfer_en)
					n_state = I2C_RD_REGADDR;
				else
					n_state = I2C_RD_ACK1;
			end

			// 5'd12
			I2C_RD_REGADDR : begin
				if(i2c_transfer_en && i2c_stream_cnt == 4'd8)
					n_state = I2C_RD_ACK2;
				else
					n_state = I2C_RD_REGADDR;
			end
			
			// 5'd13
			I2C_RD_ACK2 : begin
				if(i2c_transfer_en)
					n_state = I2C_RD_STOP1;
				else
					n_state = I2C_RD_ACK2;
			end

			// 5'd14
			I2C_RD_STOP1 : begin
				if(i2c_transfer_en)
					n_state = I2C_RD_IDLE;
				else
					n_state = I2C_RD_STOP1;
			end

			// 5'd15
			I2C_RD_IDLE : begin
				if(i2c_transfer_en)
					n_state = I2C_RD_START2;
				else
					n_state = I2C_RD_IDLE;
			end
			
			// 5'd16
			I2C_RD_START2 : begin
				if(i2c_transfer_en)
					n_state = I2C_RD_IDADDR2;
				else
					n_state = I2C_RD_START2;
			end

			// 5'd17
			I2C_RD_IDADDR2 : begin
				if(i2c_transfer_en && i2c_stream_cnt == 4'd8)
					n_state = I2C_RD_ACK3;
				else
					n_state = I2C_RD_IDADDR2;
			end

			// 5'd18
			I2C_RD_ACK3 : begin
				if(i2c_transfer_en)
					n_state = I2C_RD_REGDATA;
				else
					n_state = I2C_RD_ACK3;
			end

			// 5'd19
			I2C_RD_REGDATA : begin
				if(i2c_transfer_en && i2c_stream_cnt == 4'd8)
					n_state = I2C_RD_NACK;
				else
					n_state = I2C_RD_REGDATA;
			end

			// 5'd20
			I2C_RD_NACK : begin
				if(i2c_transfer_en)
					n_state = I2C_RD_STOP2;
				else
					n_state = I2C_RD_NACK;
			end

			// 5'd21
			I2C_RD_STOP2 : begin
				if(i2c_transfer_en)
					n_state = I2C_IDLE;
				else
					n_state = I2C_RD_STOP2;
			end

			default : ;		
		endcase
	end
	
	wire			bir_en;

	assign bir_en = (c_state == I2C_WR_ACK1 || c_state == I2C_WR_ACK2 ||
					 c_state == I2C_WR_ACK3 || c_state == I2C_RD_ACK1 ||
					 c_state == I2C_RD_ACK2 || c_state == I2C_RD_ACK3 ||
					 c_state == I2C_RD_REGDATA)? 
					 1'b1:1'b0;
	
	assign i2c_scl = (c_state >= I2C_WR_IDADDR  && c_state <= I2C_WR_ACK3 ||
					  c_state >= I2C_RD_IDADDR1 && c_state <= I2C_RD_ACK2 ||
					  c_state >= I2C_RD_IDADDR2 && c_state <= I2C_RD_NACK)?
					  i2c_ctrl_clk : 1'b1;

	assign i2c_sda = (~bir_en)?i2c_sda_out:1'bz;

	/*ila_0 ila0_inst
	(
		.clk	(clk),
		.probe0	({i2c_ack1,i2c_ack2,i2c_ack3,c_state}),
		.probe1 (i2c_config_done)
	);*/

endmodule