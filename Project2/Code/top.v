module top(SW, LEDR, ADC_CLK_10);
	input[9:0] SW;
	output[9:0] LEDR;
	input ADC_CLK_10;
	
	clk_divider #(14) cd(ADC_CLK_10, 14'h2710, LEDR); // Magic value = 10,000	
	
endmodule
