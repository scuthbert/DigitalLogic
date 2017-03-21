module sevenSegmentMode(digit, segment);
	input [1:0] digit;
	output reg [7:0] segment;
	
	always@(digit)
	begin
		case(digit)
		2'h0: segment = 8'b10001000; // A for Arithmetic
		2'h1: segment = 8'b11000111; // L for Logical
		2'h2: segment = 8'b11000110; // C for Comparison
		2'h3: segment = 8'b10110110; // || for Magic
		endcase
	end	
endmodule