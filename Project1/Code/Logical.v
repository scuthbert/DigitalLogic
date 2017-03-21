module Logical(x, y, s, out);
	input [3:0] x;
	input [3:0] y;
	input [1:0] s;
	output [7:0] out;
	
	wire [7:0] z;
	assign z[3:0] = x;
	assign z[7:4] = y;
	
	wire [3:0] aout;
	bAnd a1(x, y, aout);
	
	wire [3:0] oout;
	bOr o1(x, y, oout);
	
	wire [3:0] xout;
	bXor x1(x,y, xout);
	
	wire [7:0] nout;
	bNot n1(z, nout);
	
	Mux #(8) m0(aout, oout, xout, nout, s, out);
endmodule

module bAnd(ax, ay, xandy);
	input [3:0] ax, ay;
	output [3:0] xandy;
	
	assign xandy = ax&ay;
endmodule

module bOr(ax, ay, xory);
	input [3:0] ax, ay;
	output [3:0] xory;
	
	assign xory = ax|ay;
endmodule

module bXor(ax, ay, xxory);
	input [3:0] ax,ay;
	output [3:0] xxory;
	
	assign xxory = ax^ay;
endmodule

module bNot(az, notz);
	input [7:0] az;
	output [7:0] notz;
	
	assign notz = ~az;
endmodule
