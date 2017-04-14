module top(SW, LEDR, ADC_CLK_10);
	input[9:0] SW;
	output[9:0] LEDR;
	input ADC_CLK_10;
	
	wire slow_clk;
	wire [6:0] rand_num; 
	reg [6:0] displayed_num;
	
	clk_divider #(24) cd(ADC_CLK_10, 24'd10000000, slow_clk); // Magic value = 1s
	LFSR #(7) lin(ADC_CLK_10, rand_num);
	
	always@(posedge slow_clk)
	begin
		displayed_num = rand_num;
	end
	
	assign LEDR[6:0] = displayed_num;
	assign LEDR[8:7] = SW[8:7];
	assign LEDR[9] = slow_clk;
	
endmodule
