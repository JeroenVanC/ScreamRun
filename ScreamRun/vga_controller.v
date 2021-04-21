
module vga_controller(clock, reset,
 display_col, display_row, visible,
 hsync, vsync);
 
 // 72 Hz 800 x 600 VGA - 50MHz clock
 parameter HOR_FIELD = 799;
 parameter HOR_STR_SYNC = 855;
 parameter HOR_STP_SYNC = 978;
 parameter HOR_TOTAL = 1042;
 parameter VER_FIELD = 599;
 parameter VER_STR_SYNC = 636;
 parameter VER_STP_SYNC = 642;
 parameter VER_TOTAL = 665;
 
 input clock;
 input reset; // reset signal
 output reg [11:0] display_col; // horizontal counter x 
 output reg [10:0] display_row; // vertical counter y 
 output reg visible; // signal visible on display
 output hsync, vsync;
 
 
 reg vga_HS, vga_VS;
 wire col_max = (display_col == HOR_TOTAL);
 wire row_max = (display_row == VER_TOTAL);
 
 always @(posedge clock or posedge reset) begin
	if (reset) begin 
		display_col <= 0;
	end else begin
		if (col_max) display_col <= 0;
		else display_col <= display_col + 1;
	end
 end
		
 always @(posedge clock or posedge reset) begin
	if (reset) begin 
		display_row <= 0;
	end else begin
		if (col_max) begin
			if(row_max) display_row <= 0;
			else display_row <= display_row + 1;
		end
	end
 end

 always @(posedge clock or posedge reset) begin
	if (reset) begin 
		vga_HS <= 1;
		vga_VS <= 1;
	end else begin
		vga_HS <= (display_col > HOR_STR_SYNC && (display_col < HOR_STP_SYNC));
		vga_VS <= (display_row > VER_STR_SYNC && (display_row < VER_STP_SYNC));
	end
 end

 always @(posedge clock or posedge reset) begin
	if (reset) begin 
		visible <= 0;
	end else begin
        visible <= (display_col < HOR_FIELD) && (display_row < VER_FIELD);
	end
 end

 assign hsync = ~vga_HS;
 assign vsync = ~vga_VS;
 
 
 
endmodule