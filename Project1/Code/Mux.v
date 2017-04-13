module Mux #(parameter WIDTH = 1)(a, b, c, d, s, f);
	input [WIDTH-1:0] a,b,c,d;
	input [1:0] s;
	output reg [WIDTH-1:0] f;
	
	always@(*)
		begin
			case(s)
			2'b00: f = a;
			2'b01: f = b;
			2'b10: f = c;
			2'b11: f = d;
			endcase
		end
endmodule
