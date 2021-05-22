module main(CLOCK_50, KEY, SW,
 VGA_R, VGA_G, VGA_B, VGA_HS, VGA_VS, LEDR);
 
 input wire CLOCK_50;
 input [1:0] KEY;
 input [9:0] SW;
 output [9:0] LEDR;
 output  [3:0] VGA_B, VGA_G, VGA_R;
 output  VGA_HS, VGA_VS;
 
 
 reg [3:0] red, green, blue;
 wire visible, hsync, vsync, reset, clock, char_visible, enc1_visible, enc2_visible, enc3_visible, boss_visible, num_visible;
 wire random_enc1_gen_out, random_enc2_gen_out, random_enc3_gen_out;
 wire [11:0] display_col, symbol_col;
 wire [10:0] display_row;
 
 wire [3:0] char_red, char_green, char_blue;
 wire [3:0] enc1_red, enc1_green, enc1_blue, enc2_red, enc2_green, enc2_blue, enc3_red, enc3_green, enc3_blue,
				num_red, num_green, num_blue;
 wire [3:0] boss_red, boss_green, boss_blue;
 
 wire [11:0] mem_out_back, mem_out_back2;
 
 assign reset = !KEY[0];
 assign jump_key = !KEY[1];
 assign LEDR[0] = jump_key;
 assign spawn_key = SW[0];
 
 reg hit;
 
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
							 

random_enc_gen random_enc_gen (.clock(clock), .reset(reset), .random_enc1_gen_out(random_enc1_gen_out), .random_enc2_gen_out(random_enc2_gen_out), .random_enc3_gen_out(random_enc3_gen_out));
							 

character char (.display_col(display_col), .display_row(display_row), .jump_key(jump_key), .reset(reset), .visible(visible), .clock(clock), .hit(hit),
					 .char_red(char_red), .char_green(char_green), .char_blue(char_blue), .char_visible(char_visible));
					 
encounter1 enc1 (.display_col(display_col), .display_row(display_row), .reset(reset), .visible(visible), .clock(clock), .spawn_key(random_enc1_gen_out), .hit(hit),
					 .enc1_red(enc1_red), .enc1_green(enc1_green), .enc1_blue(enc1_blue), .enc1_visible(enc1_visible));

encounter1 enc2 (.display_col(display_col), .display_row(display_row), .reset(reset), .visible(visible), .clock(clock), .spawn_key(random_enc2_gen_out), .hit(hit),
					 .enc1_red(enc2_red), .enc1_green(enc2_green), .enc1_blue(enc2_blue), .enc1_visible(enc2_visible));	
					 
encounter1 enc3 (.display_col(display_col), .display_row(display_row), .reset(reset), .visible(visible), .clock(clock), .spawn_key(random_enc3_gen_out), .hit(hit),
					 .enc1_red(enc3_red), .enc1_green(enc3_green), .enc1_blue(enc3_blue), .enc1_visible(enc3_visible));					 
					 
finalBoss boss (.display_col(display_col), .display_row(display_row), .reset(reset), .visible(visible), .clock(clock), .hit(hit),
					 .boss_red(boss_red), .boss_green(boss_green), .boss_blue(boss_blue), .boss_visible(boss_visible));
					 
scoreDisplay scoreDisplay (.display_col(display_col), .display_row(display_row), .reset(reset), .visible(visible), .clock(clock), .hit(hit),
                           .num_red(num_red), .num_green(num_green), .num_blue(num_blue), .num_visible(num_visible));				 
					 
					 
reg [31:0] count;
assign symbol_col = display_col + count;
					 
//Background Background (
//	.address({symbol_col[9:2],display_row[9:2]}),
//	.clock(clock),
//	.data(12'b0),
//	.wren(1'b0),
//	.q(mem_out_back));
	
		
always @(posedge clock or posedge reset) begin
	if (reset) begin
		red = 0; green = 0; blue = 0; hit = 0;
	end else begin
		if (display_col == 0 && display_row == 0) count = count + 3;
		if (visible) begin
			if (char_visible && enc1_visible || char_visible && enc2_visible || char_visible && enc3_visible) begin hit = 1; end
			if (char_visible == 1) begin
			    red = char_red;
				green = char_green;
				blue = char_blue;
			end else if (boss_visible == 1) begin
				red = boss_red;
				green = boss_green;
				blue = boss_blue;
			end else if (enc1_visible == 1) begin
				red = enc1_red;
				green = enc1_green;
				blue = enc1_blue;
			end else if (enc2_visible == 1) begin
				red = enc2_red;
				green = enc2_blue;
				blue = enc2_green;
			end else if (enc3_visible == 1) begin
				red = enc3_blue;
				green = enc3_green;
				blue = enc3_red;
			end else if (num_visible == 1) begin
				red = num_red;
				green = num_green;
				blue = num_blue;
			//end else begin 
			//	red = mem_out_back[3:0];
			//	green = mem_out_back[7:4];
			//	blue = mem_out_back[11:8];
			end else begin
				red = 0;
				green = 0;
				blue = 0;
			end
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
