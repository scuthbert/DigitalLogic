module Comparison(x, y, s, out);
	input [3:0] x;
	input [3:0] y;
	input [1:0] s;
	output [7:0] out;
	
	wire aout;
	bEqual a1(x, y, aout);
	
	wire bout;
	bGreater o1(x, y, bout);
	
	wire cout;
	bLess x1(x, y, cout);
	
	wire [3:0] dout;
	bMax n1(x, y, dout);
	
	Mux #(8) m0(aout, bout, cout, dout, s, out);
endmodule

module bEqual(ax, ay, xey);
	input [3:0] ax, ay;
	output xey;
	
	assign xey = (ax===ay);
endmodule

module bGreater(ax, ay, xgy);
	input [3:0] ax, ay;
	output xgy;
	
	assign xgy = ax > ay;
endmodule

module bLess(ax, ay, xly);
	input [3:0] ax,ay;
	output xly;
	
	assign xly = ax < ay;
endmodule

module bMax(ax, ay, xmy);
	input [3:0] ax,ay;
	output reg [3:0] xmy;
	
	wire xlarge;
	bGreater bG(ax, ay, xlarge);
	
	always@(*)
	begin
		case(xlarge)
		1'b1: xmy = ax;
		1'b0: xmy = ay;
		endcase
	end
endmodule
