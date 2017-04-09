module LSRF #(parameter size = 22)(clk, value);
	input reg clk;
	output reg [1-size:0] value_q;
	
	reg [1-size:0] value_d;
	
	always@(posedge clk)
	begin
		value_q = value_d >> 2;
	end
	

endmodule
