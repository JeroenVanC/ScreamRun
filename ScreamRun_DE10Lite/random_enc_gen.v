module random_enc_gen (clock, reset, random_enc1_gen_out, random_enc2_gen_out, random_enc3_gen_out);

input clock, reset;
output random_enc1_gen_out, random_enc2_gen_out, random_enc3_gen_out;

reg random_enc1_gen, random_enc2_gen, random_enc3_gen, counter;

wire [1:0] lfsr_out1;
reg [30:0] counter_time, enc_counter;

lfsr lfsr1(.beginvalue(64'b0001000101001010101010100000001111100110011100100100100101101010), .clock(clock), .reset(reset), .out(lfsr_out1));


always @(posedge clock or posedge reset) begin
	if (reset) begin
		random_enc1_gen = 0; random_enc2_gen = 0; random_enc3_gen = 0; enc_counter = 0; counter = 0;counter_time = 0;
	end else begin
		if (counter == 0) begin
			if (enc_counter == 0) begin
				random_enc1_gen = 1;
				random_enc2_gen = 0;
				random_enc3_gen = 0;
				enc_counter = 1;
			end else if (enc_counter == 1) begin
				random_enc1_gen = 0;
				random_enc2_gen = 1;
				random_enc3_gen = 0;
				enc_counter = 2;
			end else if (enc_counter == 2) begin
				random_enc1_gen = 0;
				random_enc2_gen = 0;
				random_enc3_gen = 1;
				enc_counter = 0;
			end 
			counter_time = (100000000 + 60000000*(lfsr_out1[1:0]));
			counter = 1;
		end else begin
			if (counter_time == 0) begin
				counter = 0;
				counter_time = 0;
			end else begin
				counter_time = counter_time - 1;
			end
		end
	end
end

assign random_enc1_gen_out = random_enc1_gen;
assign random_enc2_gen_out = random_enc2_gen;
assign random_enc3_gen_out = random_enc3_gen;

endmodule
