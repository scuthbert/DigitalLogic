module top(SW, KEY, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, ADC_CLK_10);
	input[9:0] SW;
	input[1:0] KEY;
	output[7:0] HEX0, HEX1, HEX2, HEX3, HEX4;
	output[9:0] LEDR;
	input ADC_CLK_10;
	
	wire slow_clk;
	wire [14:0] rand_num; 
	reg [14:0] displayed_num;
	
	clk_divider #(13) cd(ADC_CLK_10, 13'd5000, slow_clk); // Magic value = 9'b111110100
	LFSR #(15) lin(ADC_CLK_10, rand_num);
	
	always@(posedge slow_clk)
	begin
		displayed_num = rand_num;
	end
	
	//assign LEDR[9] = slow_clk;
	
	wire [19:0] count;
	BCD_counter BC(slow_clk, KEY[0], count);
	BCD_decoder BD(count, HEX0, HEX1, HEX2, HEX3, HEX4);
	
endmodule
