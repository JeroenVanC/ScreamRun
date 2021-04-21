module main(CLOCK_50, KEY, SW,
 VGA_R, VGA_G, VGA_B, VGA_HS, VGA_VS);
 
 input wire CLOCK_50;
 input [1:0] KEY;
 input [9:0] SW;
 output  [3:0] VGA_B, VGA_G, VGA_R;
 output  VGA_HS, VGA_VS;
 
 
 reg [3:0] red, green, blue;
 wire visible, hsync, vsync, reset, clock;
 wire [11:0] display_col;
 wire [10:0] display_row;
 reg [11:0] square_x_begin, square_x_end, imagex;
 reg [10:0] square_y_begin, square_y_end, imagey;
  integer square_width = 32;
 
 wire [11:0] mem_out;
 
 assign reset = !KEY[0];
 
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
							 

//image_memory image_memory({display_col[6:0],display_row[7:0]},clock,15'b0,1'b0,mem_out);
characterRam characterRam ({imagex[4:0],imagey[4:0]},clock,12'b0,1'b0,mem_out);

 reg [19:0] count;
 reg x_richting, y_richting;
 
 always @(posedge clock or posedge reset)
	if (reset) begin
		square_x_begin = 0 ; square_y_begin = 0; square_x_end = square_x_begin + square_width; square_y_end = square_y_begin + square_width;
		count = 0; x_richting = 0; y_richting = 0;
	end else begin
		if (square_x_end == 1279) x_richting = 1;
		if (square_x_begin == 0) x_richting = 0;
		if (square_y_end == 1023) y_richting = 1;
		if (square_y_begin == 0) y_richting = 0;
		if (display_col == 0 && display_row == 0) begin
			count = 0;
			if (x_richting == 0) square_x_begin = square_x_begin + 1;
			else square_x_begin = square_x_begin - 1;
			if (y_richting == 0) square_y_begin = square_y_begin + 1;
			else square_y_begin = square_y_begin - 1;
		end else begin
			count = count + 1;
		end
		square_x_end = square_x_begin + square_width; 
		square_y_end = square_y_begin + square_width;
		imagex = display_col - square_x_begin;
		imagey = display_row - square_y_begin;
	end


		
always @(posedge clock or posedge reset) begin
	if (reset) begin
		red = 0; green = 0; blue = 0;
	end else begin
		if (visible) begin
			if (square_x_begin < display_col[11:0] && display_col[11:0] < square_x_end && square_y_begin < display_row[10:0] && display_row[10:0] < square_y_end) begin
				if (mem_out != 0) begin
					red = mem_out[3:0];
					green = mem_out[7:4];
					blue = mem_out[11:8];
				end
				else begin red = 4'b1111; green = 4'b1111; blue = 4'b1111; end
			end
			else begin red = 4'b1111; green = 4'b1111; blue = 4'b1111; end
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