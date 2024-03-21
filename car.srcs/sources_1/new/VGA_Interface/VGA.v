module VGA
(
	input	wire			clk_vid,
	input	wire			rst_n,
	input	wire	[7:0]	img,
	input	wire			binary,	
	input	wire			sobel1,
	input	wire			sobel2,
	
	output	reg		[16:0]	addr_img,
	output	reg		[16:0]	addr_binary,	
	output	reg		[16:0]	addr_sobel1,
	output	reg		[16:0]	addr_sobel2,
	output	reg				h_sync,
	output	reg				v_sync,
	output	reg		[11:0]	d_out,
	
	input	[8:0]	    h_min,
	input	[8:0]	    h_max,
	input	[8:0]	    v_min,
	input	[8:0]	    v_max
);
	
	parameter RED   = 12'b1111_0000_0000,
			   GREEN = 12'b0000_1111_0000,
			   BLUE  = 12'b0000_0000_1111,
               BLACK = 12'b0000_0000_0000,
               WIGHT = 12'b1111_1111_1111;
               
	reg		[9:0]	h_cnt;
	reg		[9:0]	v_cnt;

	// h_cnt	
	always @(posedge clk_vid or negedge rst_n)
	begin
		if(!rst_n)
			h_cnt <= 10'd0;
		else if(h_cnt == 10'd799)
			h_cnt <= 10'd0;
		else
			h_cnt <= h_cnt + 1'b1;
	end

	// v_cnt		
	always @(posedge clk_vid or negedge rst_n) begin
		if(!rst_n)
			v_cnt <= 10'd0;
		else if(v_cnt == 10'd524 && h_cnt == 10'd799)
			v_cnt <= 10'd0;
		else if(h_cnt == 10'd799)
			v_cnt <= v_cnt + 1'b1;
	end

	// h_sync
	always @(posedge clk_vid or negedge rst_n)
	begin
		if(!rst_n)
			h_sync <= 1'b1;
		else if(h_cnt == 10'd95)
			h_sync <= 1'b0;
		else if(h_cnt == 10'd799)
			h_sync <= 1'b1;	
	end	

	// v_sync
	always @(posedge clk_vid or negedge rst_n)
	begin
		if(!rst_n)
			v_sync <= 1'b1;
		else if(v_cnt == 10'd1 && h_cnt == 10'd799)
			v_sync <= 1'b0;
		else if(v_cnt == 10'd524)
			v_sync <= 1'b1;
	end
	
	// addr_img
	always @(posedge clk_vid or negedge rst_n) 
	begin
		if(!rst_n)
			addr_img <= 17'd0;
		else if(v_cnt >= 10'd35 && v_cnt < 10'd275 && h_cnt >= 10'd144 && h_cnt < 10'd464) begin
			if(v_cnt == 10'd35 && h_cnt == 10'd144)
				addr_img <= 17'd0;
			else
				addr_img <= addr_img + 1'b1;
		end
	end
	
	// addr_binary
	always @(posedge clk_vid or negedge rst_n)
	begin
		if(!rst_n)
			addr_binary <= 17'd0;
		else if(v_cnt >= 10'd35 && v_cnt < 10'd275 && h_cnt >= 10'd464 && h_cnt < 10'd784) begin
			if(v_cnt == 10'd35 && h_cnt == 10'd464)
				addr_binary <= 17'd0;
			else
				addr_binary <= addr_binary + 1'b1;
		end
	end
	
	// addr_sobel1
	always @(posedge clk_vid or negedge rst_n)
	begin
		if(!rst_n)
			addr_sobel1 <= 17'd0;
		else if(v_cnt >= 10'd275 && v_cnt < 10'd515 && h_cnt >= 10'd144 && h_cnt < 10'd464) begin
			if(v_cnt == 10'd275 && h_cnt == 10'd144)
				addr_sobel1 <= 17'd0;
			else
				addr_sobel1 <= addr_sobel1 + 1'b1;
		end
	end

	// addr_sobel2
	always @(posedge clk_vid or negedge rst_n)
	begin
		if(!rst_n)
			addr_sobel2 <= 17'd0;
		else if(v_cnt >= 10'd275 && v_cnt < 10'd515 && h_cnt >= 10'd464 && h_cnt < 10'd784) begin
			if(v_cnt == 10'd275 && h_cnt == 10'd464)
				addr_sobel2 <= 17'd0;
			else
				addr_sobel2 <= addr_sobel2 + 1'b1;
		end
	end
		
	// d_out
	// h_cnt (144,783) v_cnt(35,514)
	always @(posedge clk_vid or negedge rst_n)
	begin
		if(!rst_n)
			d_out <= 12'd0;
		else if(v_cnt >= 10'd35 && v_cnt < 10'd275 && h_cnt >= 10'd144 && h_cnt < 10'd464)
			d_out <= {img[7:4],img[7:4],img[7:4]};
		else if(v_cnt >= 10'd35 && v_cnt < 10'd275 && h_cnt >= 10'd464 && h_cnt < 10'd784)
            if (((h_cnt >= h_min + 464 && h_cnt <= h_max + 464) && (v_cnt == v_min + 35  || v_cnt == v_min - 1 + 35  || v_cnt == v_max + 35  || v_cnt == v_max + 1 + 35 )) ||
                ((v_cnt >= v_min + 35  && v_cnt <= v_max + 35 ) && (h_cnt == h_min + 464 || h_cnt == h_min - 1 + 464 || h_cnt == h_max + 464 || h_cnt == h_max + 1 + 464)))
			     d_out <= RED;
			else if(binary)
			     d_out <= WIGHT; //{bit,3'd0,bit,3'd0,bit,3'd0};
			else
			     d_out <= BLACK;
		else if(v_cnt >= 10'd275 && v_cnt < 10'd515 && h_cnt >= 10'd144 && h_cnt < 10'd464)
//			if(sobel1)
			     d_out <= BLACK; 
//			else
//			     d_out <= WIGHT;
		else if(v_cnt >= 10'd275 && v_cnt < 10'd515 && h_cnt >= 10'd464 && h_cnt < 10'd784)begin
//			if(sobel2)
			     d_out <= BLACK;
//			else
//			     d_out <= WIGHT;
		end
		else
			d_out <= 12'd0;
	end

endmodule