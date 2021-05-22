module encounter1 (display_col, display_row, reset, visible, clock, spawn_key, hit, enc1_red, enc1_green, enc1_blue, enc1_visible);

 input visible, clock, reset, spawn_key, hit;
 input [11:0] display_col;
 input [10:0] display_row;
 
 output [3:0] enc1_red, enc1_green, enc1_blue;
 output enc1_visible;
 
 reg [11:0]  imagex;
 reg [10:0]  imagey, char_base_y;
 reg visible_char;
 reg [3:0] red, green, blue;
 reg [12:0]  char_address_Run;
 reg [30:0] counter, char_base_x;
 reg [3:0] animatie_Run;
 wire [11:0] mem_out_Run;


Encounter1_Run Encounter1_Run (char_address_Run,clock,12'b0,1'b0,mem_out_Run);

always @(posedge clock or posedge reset) begin
  if (reset) begin
        counter = 0; animatie_Run = 0;
  end else begin
		  if (hit == 1) begin 
				counter = counter;
				animatie_Run = animatie_Run;
		  end else if(counter == 20000000) begin
					counter = 0;
					animatie_Run = animatie_Run + 1;
					if (animatie_Run == 5) begin
						animatie_Run = 0;
					end 
				end else begin
					counter = counter + 1;
				end
		  end
end
		
always @(posedge clock or posedge reset) begin
	if (reset) begin
		red = 0; green = 0; blue = 0; char_base_y = 0; imagex = 0; imagey=0; char_base_x = 0; visible_char = 0;
	end else begin
		char_address_Run = {imagex[6:2],imagey[6:2]} + animatie_Run*1024;
		if (hit == 1) begin
			char_base_x = char_base_x;
		end else if(display_col == 0 && display_row == 0) begin
				if (char_base_x == 0) begin
					if (spawn_key == 1) begin 
						char_base_x = 1500;
					end else begin 
						char_base_x = 0;
					end
				end else begin
					char_base_x = char_base_x - 6; //speed
				end
		end
			
			
		if (visible) begin
			char_base_y = 690;
			imagex = display_col - char_base_x;
			imagey = display_row - char_base_y;
			if ((char_base_x+4) < display_col[11:0] && display_col[11:0] < (char_base_x+136) && (char_base_y+4) < display_row[10:0] && display_row[10:0] < (char_base_y+128)) begin
					if (mem_out_Run != 12'b110000001111) begin
						red = mem_out_Run[3:0];
						green = mem_out_Run[7:4];
						blue = mem_out_Run[11:8];
						if (char_base_x == 0) begin
							visible_char = 0;
						end else begin
							visible_char = 1;
						end
					end else begin red = 4'b1111; green = 4'b1111; blue = 4'b1111; visible_char = 0;end
				end
			end else begin red = 4'b1111; green = 4'b1111; blue = 4'b1111; visible_char = 0; end
		end
	end
	
 assign enc1_blue = blue;
 assign enc1_red = red;
 assign enc1_green = green;
 assign enc1_visible = visible_char;
 
 endmodule
 