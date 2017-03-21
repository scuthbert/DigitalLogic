module sevenSegment(digit, segment);
	input [3:0] digit;
	output reg [7:0] segment;
	
	always@(digit)
	begin
		case(digit)
		4'h0: segment = 8'b11000000;
		4'h1: segment = 8'b11111001;
		4'h2: segment = 8'b10100100;
		4'h3: segment = 8'b10110000;
		4'h4: segment = 8'b10011001;
		4'h5: segment = 8'b10010010;
		4'h6: segment = 8'b10000010;
		4'h7: segment = 8'b11111000;
		4'h8: segment = 8'b10000000;
		4'h9: segment = 8'b10011000;
		4'ha: segment = 8'b10001000;
		4'hb: segment = 8'b10000011;
		4'hc: segment = 8'b11000110;
		4'hd: segment = 8'b10100001;
		4'he: segment = 8'b10000110;
		4'hf: segment = 8'b10001110;
		endcase
	end	
endmodule