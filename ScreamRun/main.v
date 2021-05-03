module main(CLOCK_50, KEY, SW,
 VGA_R, VGA_G, VGA_B, VGA_HS, VGA_VS, LEDR);
 
 input wire CLOCK_50;
 input [1:0] KEY;
 input [9:0] SW;
 output [9:0] LEDR;
 output  [3:0] VGA_B, VGA_G, VGA_R;
 output  VGA_HS, VGA_VS;
 
 
 reg [3:0] red, green, blue;
 wire visible, hsync, vsync, reset, clock, char_visible;
 wire [11:0] display_col;
 wire [10:0] display_row;
 
 wire [3:0] char_red, char_green, char_blue;
 
 
 assign reset = !KEY[0];
 assign jump_key = !KEY[1];
 assign LEDR[0] = jump_key;
 
PLL108MHz u1 (.inclk0(CLOCK_50), .areset(reset), .c0(clock));
vga_controller # ( 	.HOR_FIELD (1279),
							.HOR_STR_SYNC(1327),
							.HOR_STP_SYNC(1439),
							.HOR_TOTAL (1687),
							.VER_FIELD (1023),
							.VER_STR_SYNC(1024),
							.VER_STP_SYNC(1027),
							.VER_TOTAL (1065))
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
				red = char_red;
				green = char_green;
				blue = char_blue;
			end else begin red = 4'b1111; green = 4'b1111; blue = 4'b1111; end
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
	
	
endmodule
