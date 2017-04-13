module Shift_Reg_Async(DIN, DOUT, CLK, nCLR);
	input DIN;
	output reg [3:0] DOUT;
	input CLK;
	input nCLR;
	
	always@(posedge CLK, ~nCLR)
	begin
		if(CLK)
		begin
			DOUT[0] <= DIN; //If this was blocking assignment, note the order is wrong
			DOUT[1] <= DOUT[0];
			DOUT[2] <= DOUT[1];
			DOUT[3] <= DOUT[2];
		end
		if(~nCLR)
		begin
			DOUT = 4'b0000;
		end
	end
endmodule

module Shift_Reg_Sync(DIN, DOUT, CLK, nCLR);
	input DIN;
	output reg [3:0] DOUT;
	input CLK;
	input nCLR;
	
	always@(posedge CLK)
	begin
		if(nCLR)
		begin
			DOUT[0] <= DIN;
			DOUT[1] <= DOUT[0];
			DOUT[2] <= DOUT[1];
			DOUT[3] <= DOUT[2];
		end
		else
		begin
			DOUT = 4'b0000;
		end
	end
endmodule
