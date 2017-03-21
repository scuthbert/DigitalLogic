module Arithmetic(x, y, s, out);
	input [3:0] x;
	input [3:0] y;
	input [1:0] s;
	output [8:0] out;
	
	wire [7:0] z;
	assign z[3:0] = x[3:0];
	assign z[7:4] = y[3:0];
	
	wire [8:0] aout; //Output of addition
	fullAdd #(4) a1(x, y, aout[3:0], aout[8]);
	
	wire [8:0] bout;
	fullSub #(4) s1(x, y, bout[3:0], bout[8]);
	
	wire [8:0] cout;
	bMull c1(z, cout[7:0], cout[8]);
	
	wire [8:0] dout;
	bDiv d1(z, dout[7:0], dout[8]);
	
	Mux #(9) m0(aout, bout, cout, dout, s, out);
endmodule

//Addition
module bAdd(x, y, cin, s, cout);
	input cin, x, y;
	output reg s;
	output reg cout;
	
	always@(x, y, cin)
		begin
			cout = (x&y)|(y&cin)|(x&cin);
			s = x^y^cin;
		end
endmodule

module fullAdd #(parameter N = 4)(x, y, s, cout);
	input [N-1:0] x;
	input [N-1:0] y;
	
	output [N-1:0] s;
	output cout;
	
	genvar i;
	wire [N:0] c;
	
	generate
			for(i=0;i<N;i=i+1)
				begin: obligatorynamehere
					bAdd stage(x[i], y[i], c[i], s[i], c[i+1]);
				end
	endgenerate
	
	assign cout = c[N];
endmodule

//Subtraction


module fullSub #(parameter N = 4)(x, y, d, bout);
	input [N-1:0] x;
	input [N-1:0] y;
	
	output reg [N-1:0] d;
	output bout;
	
	integer i;
	reg [N:0] b;
	
	always@(*)
		begin
			b[0] = 1'b0;
			for(i=0;i<N;i=i+1)
				begin
					d[i] = x[i]^y[i]^b[i];
					b[i+1] = (~x[i]&y[i])|(~x[i]&b[i])|(y[i]&b[i]);
				end
		end
	
	assign bout = b[4];
endmodule

//Multiplication
module bMull (z, zmull, carry);
	input [7:0] z;
	output [7:0] zmull;
	output carry;
	
	assign carry = z[7];
	assign zmull[0] = 0;
	assign zmull[7:1] = z[6:0];
endmodule

//Division
module bDiv (z, zdiv, remainder);
	input [7:0] z;
	output [7:0] zdiv;
	output remainder;
	
	assign remainder = z[0];
	assign zdiv[7] = 0;
	assign zdiv[6:0] = z[7:1];
endmodule
