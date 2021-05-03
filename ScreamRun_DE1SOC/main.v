module main(CLOCK_50, KEY, SW,
 VGA_R, VGA_G, VGA_B, VGA_HS, VGA_VS, LEDR,
 VGA_CLK, VGA_SYNC_N, VGA_BLANK_N );
 
 input wire CLOCK_50;
 input [3:0] KEY;
 input [9:0] SW;
 output [9:0] LEDR;
 output  [7:0] VGA_B, VGA_G, VGA_R;
 output  VGA_HS, VGA_VS, VGA_CLK, VGA_SYNC_N, VGA_BLANK_N ;
 
 
 reg [7:0] red, green, blue;
 wire visible, hsync, vsync, reset, clock, char_visible;
 wire [11:0] display_col;
 wire [10:0] display_row;
 
 wire [3:0] char_red, char_green, char_blue;
 
 
 assign reset = !KEY[0];
 assign jump_key = !KEY[1];
 assign LEDR[0] = jump_key;
 
PLL108MHz u1 (.refclk(CLOCK_50), .rst(reset), .outclk_0(clock));
vga_controller # ( 	.HOR_FIELD (1919),
							.HOR_STR_SYNC(2007),
							.HOR_STP_SYNC(2051),
							.HOR_TOTAL (2199),
							.VER_FIELD (1079),
							.VER_STR_SYNC(1083),
							.VER_STP_SYNC(1088),
							.VER_TOTAL (1124))
					vga (	.clock(clock),
							 .reset(reset),
							 .display_col(display_col),
							 .display_row(display_row),
							 .visible(visible), 
							 .hsync(hsync),
							 .vsync(vsync));
							 


character char (.display_col(display_col), .display_row(display_row), .jump_key(jump_key), .reset(reset), .visible(visible), .clock(clock),
					 .char_red(char_red), .char_green(char_green), .char_blue(char_blue), .char_visible(char_visible));


		
always @(posedge clock or posedge reset) begin
	if (reset) begin
		red = 0; green = 0; blue = 0;
	end else begin
		if (visible) begin
			if (char_visible) begin
				red = {char_red, 4'b0000};
				green = {char_green, 4'b0000};
				blue = {char_blue, 4'b0000};
			end else begin red = 8'b11111111; green = 8'b11111111; blue = 8'b11111111; end
		end else begin
			red = 0;
			green = 0;
			blue = 0;
		end
	end
end
	
 assign VGA_B = blue;
 assign VGA_R = red;
 assign VGA_G = green;
 assign VGA_HS = hsync;
 assign VGA_VS = vsync;
 
 assign VGA_CLK = CLOCK_50;
 assign VGA_SYNC_N = 1'b0;
 assign VGA_BLANK_N = hsync & vsync;
	
	
endmodule
