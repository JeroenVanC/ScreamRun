module scoreDisplay (display_col, display_row, reset, visible, clock, hit, num_red, num_green, num_blue, num_visible);

 input visible, clock, reset, hit;
 input [11:0] display_col;
 input [10:0] display_row;
 
 output [3:0] num_red, num_green, num_blue;
 output num_visible;
 
 reg [3:0] red, green, blue;
 reg [3:0] een, tien, hon, duiz;
 reg [30:0] counter;
 
 wire een_visible, tien_visible, hon_visible, duiz_visible;
 wire [3:0] een_red, een_green, een_blue, tien_red, tien_green, tien_blue, hon_red, hon_green, hon_blue, duiz_red, duiz_green, duiz_blue;
 
number eenheden (.display_col(display_col), .display_row(display_row), .reset(reset), .visible(visible), .clock(clock),
                 .num_red(een_red), .num_green(een_green), .num_blue(een_blue), .num_visible(een_visible), .x_coor(1150), .y_coor(50), .number(een));
number tientallen (.display_col(display_col), .display_row(display_row), .reset(reset), .visible(visible), .clock(clock),
                   .num_red(tien_red), .num_green(tien_green), .num_blue(tien_blue), .num_visible(tien_visible), .x_coor(1086), .y_coor(50), .number(tien));
number honderdtallen (.display_col(display_col), .display_row(display_row), .reset(reset), .visible(visible), .clock(clock),
                      .num_red(hon_red), .num_green(hon_green), .num_blue(hon_blue), .num_visible(hon_visible), .x_coor(1022), .y_coor(50), .number(hon));
number duizendtallen (.display_col(display_col), .display_row(display_row), .reset(reset), .visible(visible), .clock(clock),
                      .num_red(duiz_red), .num_green(duiz_green), .num_blue(duiz_blue), .num_visible(duiz_visible), .x_coor(958), .y_coor(50), .number(duiz)); 
 
 always @(posedge clock or posedge reset) begin
	if (reset) begin
		een = 0; tien = 0; hon = 0; duiz = 0;
	end else begin
		if (hit == 0) begin
			if (counter == 20000000) begin
				counter = 0;
				if (een == 9) begin
					een = 0;
					if (tien == 9) begin
						tien = 0;
						if (hon == 9) begin
							hon = 0;
							if (duiz == 9) begin
								duiz = 0;
							end else begin
								duiz = duiz + 1;
							end
						end else begin
							hon = hon + 1;
						end
					end else begin
						tien = tien + 1;
					end
				end else begin
					een = een + 1;
				end 
			end else begin
				counter = counter + 1;
			end	
		end else begin
			counter = counter;
		end 
	end
 end
 
always @(posedge clock or posedge reset) begin
	if (reset) begin
		red = 0; green = 0; blue = 0;
	end else begin
		if (een_visible == 1) begin
			red = een_red;
			green = een_green;
			blue = een_blue;
		end else if (tien_visible == 1) begin
			red = tien_red;
			green = tien_green;
			blue = tien_blue;
		end else if (hon_visible == 1) begin
			red = hon_red;
			green = hon_green;
			blue = hon_blue;
		end else if (duiz_visible == 1) begin
			red = duiz_red;
			green = duiz_blue;
			blue = duiz_green;
		end else begin 
			red = 0;
			green = 0;
			blue = 0;
		end
	end
end


 assign num_blue = blue;
 assign num_red = red;
 assign num_green = green;
 assign num_visible = een_visible || tien_visible || hon_visible || duiz_visible;

endmodule
