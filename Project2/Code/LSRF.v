module up_down_counter(clk, ctrl, value);
	input clk;
	input ctrl;
	output reg [2:0] value;
	
	always@(posedge clk)
	begin
		case(updown)
			1'b0: value <= value - 1;
			1'b1: value <= value + 1;
		endcase
	end
endmodule
