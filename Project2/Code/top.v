module top(SW, LEDR, HEX0, HEX1, HEX2, HEX3, ADC_CLK_10);
	input[9:0] SW;
	output[7:0] HEX0, HEX1, HEX2, HEX3;
	output[9:0] LEDR;
	input ADC_CLK_10;
	
	wire slow_clk;
	wire [14:0] rand_num; 
	reg [14:0] displayed_num;
	
	clk_divider #(24) cd(ADC_CLK_10, 24'd10000000, slow_clk); // Magic value = 1s
	LFSR #(15) lin(ADC_CLK_10, rand_num);
	
	always@(posedge slow_clk)
	begin
		displayed_num = rand_num;
	end
	
	sevenSegment S1(displayed_num[3:0], HEX0);
	sevenSegment S2(displayed_num[7:4], HEX1);
	sevenSegment S3(displayed_num[11:8], HEX2);
	sevenSegment S4(displayed_num[14:12], HEX3);
	
	assign LEDR[9] = slow_clk;
	
endmodule
