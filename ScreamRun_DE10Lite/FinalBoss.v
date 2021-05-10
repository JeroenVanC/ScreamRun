module finalBoss (display_col, display_row, reset, visible, clock, boss_red, boss_green, boss_blue, boss_visible);

 input visible, clock, reset;
 input [11:0] display_col;
 input [10:0] display_row;
 
 output [3:0] boss_red, boss_green, boss_blue;
 output boss_visible;
 
 reg [11:0]  imagex;
 reg [10:0]  imagey, char_base_y;
 reg visible_char;
 reg [3:0] red, green, blue;
 reg [11:0]  char_address_Boss;
 reg [30:0] counter, char_base_x;
 wire [11:0] mem_out_Boss;


FinalBoss_Ram FinalBoss_Ram(char_address_Boss,clock,12'b0,1'b0,mem_out_Boss);

		
always @(posedge clock or posedge reset) begin
	if (reset) begin
		red = 0; green = 0; blue = 0; char_base_y = 0; imagex = 0; imagey=0; char_base_x = 0;
	end else begin
		char_address_Boss = {imagex[7:2],imagey[7:2]};
			
			
		if (visible) begin
			char_base_y = 560;
			char_base_x = 0;
			imagex = display_col - char_base_x;
			imagey = display_row - char_base_y;
			if ((char_base_x) < display_col[11:0] && display_col[11:0] < (char_base_x+260) && (char_base_y+4) < display_row[10:0] && display_row[10:0] < (char_base_y+260)) begin
					if (mem_out_Boss != 12'b110000001111) begin
						red = mem_out_Boss[3:0];
						green = mem_out_Boss[7:4];
						blue = mem_out_Boss[11:8];
						visible_char = 1;
					end else begin red = 4'b1111; green = 4'b1111; blue = 4'b1111; visible_char = 0;end
				end
			end else begin red = 4'b1111; green = 4'b1111; blue = 4'b1111; visible_char = 0; end
		end
	end
	
 assign boss_blue = blue;
 assign boss_red = red;
 assign boss_green = green;
 assign boss_visible = visible_char;
 
 endmodule
 