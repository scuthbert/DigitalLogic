module LFSR #(parameter SIZE = 1)(clk, value);
	input clk;
	output reg [SIZE-1:0] value;

	reg feedback;
	
	always@(posedge clk)
	begin
		if(value == {(SIZE-1){1'b0}})
		begin
			value[SIZE-1] = 1'b0;
		end
		feedback = value[SIZE-1] ^ value[SIZE-2];
		value = value << 1;
		value[0] = feedback;
	end
endmodule
