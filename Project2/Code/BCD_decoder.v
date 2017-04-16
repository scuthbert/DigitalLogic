module BCD_decoder(value, out0, out1, out2, out3, out4);
	input[19:0] value;
	output[7:0] out0,out1,out2,out3,out4; //4 Digits
	
	sevenSegment(value[3:0], out0, 1'b0);
	sevenSegment(value[7:4], out1, 1'b0);
	sevenSegment(value[11:8], out2, 1'b0);
	sevenSegment(value[15:12], out3, 1'b1);
	sevenSegment(value[19:16], out4, 1'b0);
	
endmodule
