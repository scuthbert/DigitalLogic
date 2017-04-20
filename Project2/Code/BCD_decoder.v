module BCD_decoder(value, out0, out1, out2, out3, out4, out5);
	input[25:0] value; // 24 bits of BCD, one bit of boolean decimal
	output[7:0] out0,out1,out2,out3,out4,out5; //4 Digits
	
	sevenSegment s0(value[3:0], out0, 1'b0);
	sevenSegment s1(value[7:4], out1, 1'b0);
	sevenSegment s2(value[11:8], out2, 1'b0);
	sevenSegment s3(value[15:12], out3, value[25]); // If we should show a decimal, it would be on this digit.
	sevenSegment s4(value[19:16], out4, 1'b0);
	sevenSegment s5(value[24:20], out5, 1'b0);
	
endmodule
