module BCDtoD(count, count_binary);
	input[19:0] count;
	output[19:0] count_binary;

	assign count_binary = count[3:0] +
								 15'd10*count[7:4] +
								 15'd100*count[11:8] +
								 15'd1000*count[15:12] +
								 15'd10000*count[19:16];

endmodule
