module pingpang(
    input                   cmos_pclk,
    input                   cmos_frame_clken,
    input    [16:0]         cmos_frame_addr,
    input    [15:0]         cmos_frame_data,
    input                   clk_vid,
    input    [16:0]         vga_img_addr,
    output   [15:0]         vga_img_data
    );
    
reg img_reg = 1'b0;
wire     cmos_frame_clken0,cmos_frame_clken1;
wire	[15:0]	vga_img_data0,vga_img_data1;

assign vga_img_data = img_reg ? vga_img_data0:vga_img_data1;
assign cmos_frame_clken0 = img_reg ? 1'b0 : 1'b1;
assign cmos_frame_clken1 = img_reg ? 1'b1 : 1'b0;

always @(*)
begin
	if(cmos_frame_clken)
		img_reg <= img_reg + 1'b1;
	else
		img_reg <= img_reg;
end

frame i_frame0 (
  .clka(cmos_pclk),         // input wire clka
  .ena(cmos_frame_clken0),   // input wire ena
  .wea(1'b1),               // input wire [0 : 0] wea
  .addra(cmos_frame_addr),  // input wire [16 : 0] addra
  .dina(cmos_frame_data),   // input wire [15 : 0] dina
  .clkb(clk_vid),           // input wire clkb
  .addrb(vga_img_addr),     // input wire [16 : 0] addrb
  .doutb(vga_img_data0)     // output wire [15 : 0] doutb
);

frame i_frame1 (
  .clka(cmos_pclk),     // input wire clka
  .ena(cmos_frame_clken1),      // input wire ena
  .wea(1'b1),      // input wire [0 : 0] wea
  .addra(cmos_frame_addr),  // input wire [16 : 0] addra
  .dina(cmos_frame_data),    // input wire [15 : 0] dina
  .clkb(clk_vid),    // input wire clkb
  .addrb(vga_img_addr),  // input wire [16 : 0] addrb
  .doutb(vga_img_data1)  // output wire [15 : 0] doutb
);

endmodule
