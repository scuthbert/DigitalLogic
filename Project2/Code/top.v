module top(SW, LEDR, ADC_CLK_10);
	input[9:0] SW;
	output[9:0] LEDR;
	input ADC_CLK_10;
	
	assign LEDR = SW;

endmodule
