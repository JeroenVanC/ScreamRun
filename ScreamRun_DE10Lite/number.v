
module number (display_col, display_row, reset, visible, clock, num_red, num_green, num_blue, num_visible, x_coor, y_coor, number);

 input visible, clock, reset;
 input [11:0] display_col, x_coor;
 input [10:0] display_row, y_coor;
 input [3:0] number;
 
 output [3:0] num_red, num_green, num_blue;
 output num_visible;
 
 reg visible_num;
 reg [3:0] red, green, blue;
 reg [13:0]  number_address;
 reg [11:0]  imagex;
 reg [10:0]  imagey;
 
 wire [11:0] mem_out_Number;


scoreCounter_Ram scoreCounter_Ram (number_address,clock,12'b0,1'b0,mem_out_Number);

		
always @(posedge clock or posedge reset) begin
	if (reset) begin
		red = 0; green = 0; blue = 0; imagex = 0; imagey=0;
	end else begin
		number_address = {imagex[5:1],imagey[5:1]} + number*1024;
		
		if (visible) begin
			imagex = display_col - x_coor;
			imagey = display_row - y_coor;
			if ((x_coor+6) < display_col[11:0] && display_col[11:0] < (x_coor+68) && (y_coor+2) < display_row[10:0] && display_row[10:0] < (y_coor+66)) begin
				if (mem_out_Number != 12'b110000001111) begin
					red = mem_out_Number[3:0];
					green = mem_out_Number[7:4];
					blue = mem_out_Number[11:8];
					visible_num = 1;
				end else begin red = 4'b1111; green = 4'b1111; blue = 4'b1111; visible_num = 0;end
			end else begin red = 4'b1111; green = 4'b1111; blue = 4'b1111; visible_num = 0;end
		end
	end
end
	
 assign num_blue = blue;
 assign num_red = red;
 assign num_green = green;
 assign num_visible = visible_num;
 

endmodule