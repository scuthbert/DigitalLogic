module top(ADC_CLK_10, KEY, SW, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
	input ADC_CLK_10;
	input[1:0] KEY;
	input[9:0] SW;

	output [9:0] LEDR;
	output [7:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

	wire slow_clk;
	clk_divider #(13) cd(ADC_CLK_10,
								13'd5000,
								slow_clk); // Magic value = .5ms, posedge every 1ms

	wire super_slow_clk;
	clk_divider #(24) cds(ADC_CLK_10,
								 24'd2500000,
								 super_slow_clk); // Magic value = .5s

	wire [24:0] go_buffs;
	buffs_slider BSlider(super_slow_clk,
								go_buffs); // Make a slider for "60 buFF5"

	wire [14:0] rand_num;
	LFSR #(15) lin(ADC_CLK_10,
						rand_num); // Generate 15 bits of random, put it in rand_num.

	wire clreset;
	wire [19:0] count;
	BCD_counter BCDCounter(slow_clk,
						  		  clreset,
								  count); // Count up every slow_clk, output to count.

	wire [19:0] count_binary; // Store a binary version of the BCD counter.
	assign count_binary = count[3:0] +
								 15'd10*count[7:4] +
								 15'd100*count[11:8] +
								 15'd1000*count[15:12] +
								 15'd10000*count[19:16];

	wire [25:0] display;
	BCD_decoder BCDisplay(display,
								 HEX0,
								 HEX1,
								 HEX2,
								 HEX3,
								 HEX4,
								 HEX5); // Display the contents of reg display

	master_ctrl MasterControl(ADC_CLK_10,
								     KEY,
									  SW,
									  go_buffs,
									  rand_num,
									  count,
									  count_binary,
									  clreset,
									  display,
									  LEDR); // Do everything.


endmodule
