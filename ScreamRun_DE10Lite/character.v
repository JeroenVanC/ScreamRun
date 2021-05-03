
module character (display_col, display_row, jump_key, reset, visible, clock, char_red, char_green, char_blue, char_visible);

 input jump_key, visible, clock, reset;
 input [11:0] display_col;
 input [10:0] display_row;
 
 output [3:0] char_red, char_green, char_blue;
 output char_visible;
 
 reg [11:0]  imagex;
 reg [10:0]  imagey, char_base_y;
 reg jump, visible_char;
 reg [30:0] count;
 reg [3:0] red, green, blue;
 reg [8:0] speedoffset;
 reg [12:0]  char_address_Run, char_address_Jump;
 reg [30:0] counter;
 reg [3:0] animatie_Run, animatie_Jump;
 
 wire [11:0] mem_out_Run, mem_out_Jump;


//characterRam characterRam ({imagex[6:2],imagey[6:2]},clock,12'b0,1'b0,mem_out);
ScreamRun_Run ScreamRun_Run (char_address_Run,clock,12'b0,1'b0,mem_out_Run);
ScreamRun_Jump ScreamRun_Jump (char_address_Jump,clock,12'b0,1'b0,mem_out_Jump);

always @(posedge clock or posedge reset) begin
  if (reset) begin
        counter <= 0; animatie_Run <= 0;
  end else begin
        if (counter == 10000000) begin
            counter <= 0;
				animatie_Run <= animatie_Run + 1;
            if (animatie_Run == 5) begin
                animatie_Run <= 0;
            end 
        end else begin
            counter <= counter + 1;
        end
    end
end
		
always @(posedge clock or posedge reset) begin
	if (reset) begin
		red = 0; green = 0; blue = 0; char_base_y = 0; count = 0; imagex = 0; imagey=0;
	end else begin
		char_address_Run = {imagex[6:2],imagey[6:2]} + animatie_Run*1024;
		char_address_Jump = {imagex[6:2],imagey[6:2]} + animatie_Jump*1024;
		if (display_col == 0 && display_row == 0 && jump == 1) begin 
				count = count + 1;
				if (count == 69) begin jump = 0; count = 0; end	
		end
		
		if (visible) begin
			if (jump_key == 1 && jump == 0) begin jump = 1; end
			char_base_y = 690 - speedoffset;
			imagex = display_col - 220;
			imagey = display_row - char_base_y;
			if (230 < display_col[11:0] && display_col[11:0] < 349 && (char_base_y+4) < display_row[10:0] && display_row[10:0] < (char_base_y+132)) begin
				if (jump) begin
					if (mem_out_Jump != 12'b110000001111) begin
						red = mem_out_Jump[3:0];
						green = mem_out_Jump[7:4];
						blue = mem_out_Jump[11:8];
						visible_char = 1;
					end else begin red = 4'b1111; green = 4'b1111; blue = 4'b1111; visible_char = 0;end
				end else begin
					if (mem_out_Run != 12'b110000001111) begin
						red = mem_out_Run[3:0];
						green = mem_out_Run[7:4];
						blue = mem_out_Run[11:8];
						visible_char = 1;
					end else begin red = 4'b1111; green = 4'b1111; blue = 4'b1111; visible_char = 0;end
				end
			end else begin red = 4'b1111; green = 4'b1111; blue = 4'b1111; end
		end
	end
end
	
 assign char_blue = blue;
 assign char_red = red;
 assign char_green = green;
 assign char_visible = visible_char;
 
 
 always @(*) begin
		case(count)
			0: begin speedoffset = 0; animatie_Jump = 1; end
			1: begin speedoffset = 0; animatie_Jump = 1; end
			2: begin speedoffset = 0; animatie_Jump = 1; end
			3: begin speedoffset = 0; animatie_Jump = 1; end
			4: begin speedoffset = 0; animatie_Jump = 2; end
			5: begin speedoffset = 22; animatie_Jump = 2; end
			6: begin speedoffset = 44; animatie_Jump = 2; end
			7: begin speedoffset = 64; animatie_Jump = 2; end
			8: begin speedoffset = 84; animatie_Jump = 3; end
			9: begin speedoffset = 103; animatie_Jump = 3; end 
			10: begin speedoffset = 122; animatie_Jump = 3; end
			11: begin speedoffset = 139; animatie_Jump = 3; end
			12: begin speedoffset = 156; animatie_Jump = 3; end
			13: begin speedoffset = 172; animatie_Jump = 3; end
			14: begin speedoffset = 188; animatie_Jump = 3; end
			15: begin speedoffset = 202; animatie_Jump = 3; end
			16: begin speedoffset = 216; animatie_Jump = 3; end
			17: begin speedoffset = 229; animatie_Jump = 3; end
			18: begin speedoffset = 242; animatie_Jump = 3; end
			19: begin speedoffset = 253; animatie_Jump = 3; end
			20: begin speedoffset = 264; animatie_Jump = 3; end
			21: begin speedoffset = 274; animatie_Jump = 3; end
			22: begin speedoffset = 284; animatie_Jump = 3; end
			23: begin speedoffset = 292; animatie_Jump = 3; end
			24: begin speedoffset = 300; animatie_Jump = 3; end
			25: begin speedoffset = 307; animatie_Jump = 3; end
			26: begin speedoffset = 314; animatie_Jump = 3; end
			27: begin speedoffset = 319; animatie_Jump = 3; end
			28: begin speedoffset = 324; animatie_Jump = 3; end
			29: begin speedoffset = 328; animatie_Jump = 3; end
			30: begin speedoffset = 332; animatie_Jump = 3; end
			31: begin speedoffset = 334; animatie_Jump = 3; end
			32: begin speedoffset = 336; animatie_Jump = 3; end
			33: begin speedoffset = 337; animatie_Jump = 3; end
			34: begin speedoffset = 338; animatie_Jump = 3; end
			35: begin speedoffset = 338; animatie_Jump = 4; end
			36: begin speedoffset = 337; animatie_Jump = 4; end
			37: begin speedoffset = 336; animatie_Jump = 4; end
			38: begin speedoffset = 334; animatie_Jump = 4; end
			39: begin speedoffset = 332; animatie_Jump = 4; end
			40: begin speedoffset = 328; animatie_Jump = 4; end
			41: begin speedoffset = 324; animatie_Jump = 4; end
			42: begin speedoffset = 319; animatie_Jump = 4; end
			43: begin speedoffset = 314; animatie_Jump = 4; end
			44: begin speedoffset = 307; animatie_Jump = 4; end
			45: begin speedoffset = 300; animatie_Jump = 4; end
			46: begin speedoffset = 292; animatie_Jump = 4; end
			47: begin speedoffset = 284; animatie_Jump = 4; end
			48: begin speedoffset = 274; animatie_Jump = 4; end
			49: begin speedoffset = 264; animatie_Jump = 4; end
			50: begin speedoffset = 253; animatie_Jump = 4; end
			51: begin speedoffset = 242; animatie_Jump = 4; end
			52: begin speedoffset = 229; animatie_Jump = 4; end
			53: begin speedoffset = 216; animatie_Jump = 5; end
			54: begin speedoffset = 202; animatie_Jump = 5; end
			55: begin speedoffset = 188; animatie_Jump = 5; end
			56: begin speedoffset = 172; animatie_Jump = 5; end
			57: begin speedoffset = 156; animatie_Jump = 5; end
			58: begin speedoffset = 139; animatie_Jump = 5; end
			59: begin speedoffset = 122; animatie_Jump = 5; end
			60: begin speedoffset = 103; animatie_Jump = 5; end
			61: begin speedoffset = 84; animatie_Jump = 5; end
			62: begin speedoffset = 64; animatie_Jump = 5; end
			63: begin speedoffset = 44; animatie_Jump = 5; end
			64: begin speedoffset = 22; animatie_Jump = 5; end
			65: begin speedoffset = 0; animatie_Jump = 6; end
			66: begin speedoffset = 0; animatie_Jump = 6; end
			67: begin speedoffset = 0; animatie_Jump = 6; end
			68: begin speedoffset = 0; animatie_Jump = 7; end
			69: begin speedoffset = 0; animatie_Jump = 7; end
			
			default: speedoffset = 0;
		endcase
	end

endmodule