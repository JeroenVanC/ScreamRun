module lfsr (input [15:0] beginvalue, input clock, input reset, output [1:0] out);

	reg [63:0]q;

	assign out = q[1:0];

	wire w1,w2,w3;

   assign w1= ~(q[63]^q[62]),
	w2= ~(w1^q[60]),
	w3= ~(w2^q[59]);

	always@(posedge clock or posedge reset) begin
		if(reset) q <= beginvalue;
		else q<={w3,q[63:1]};
	end

endmodule