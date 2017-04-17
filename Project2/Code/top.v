module top(SW, KEY, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, ADC_CLK_10);
	input[9:0] SW;
	input[1:0] KEY;
	output [7:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output reg [9:0] LEDR;
	input ADC_CLK_10;
	
	wire slow_clk;
	clk_divider #(13) cd(ADC_CLK_10, 13'd5000, slow_clk); // Magic value = .5ms
	
	wire super_slow_clk;
	clk_divider #(24) cds(ADC_CLK_10, 24'd2500000, super_slow_clk); // Magic value = 1s
	
	wire [14:0] rand_num;
	reg [14:0] rand_num_saved;
	LFSR #(15) lin(ADC_CLK_10, rand_num); // Generate 15 bits of random, put it in rand_num.
	
	reg clreset;
	wire [19:0] count;
	BCD_counter BC(slow_clk, clreset, count); // Count up every 1ms, output to count.
	
	wire [19:0] count_binary; // Store a binary version of the BCD counter.
	assign count_binary = (count[3:0] + 15'd10*count[7:4] + 15'd100*count[11:8] + 15'd1000*count[15:12] + 15'd10000*count[19:16]);
	
	reg decimal; 
	reg [24:0] display;
	BCD_decoder BD(decimal, display, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5); // Display the contents of reg display
	
	// GO BUFFS slider
	reg [24:0] go_buffs;
	reg [3:0] position;
	always@(posedge super_slow_clk)
	begin
	
		if(go_buffs == 24'd0)
		begin
			go_buffs = 24'b110111011101110111011101; // Blank
		end
		
		go_buffs = go_buffs << 4;
		
		if(position == 4'd12) position = 1'b0;
		else position = position + 1'b1;

		case(position)
			4'd0: go_buffs[3:0] = 4'h6;
			4'd1: go_buffs[3:0] = 4'h0;
			4'd2: go_buffs[3:0] = 4'hd;// Space
			4'd3: go_buffs[3:0] = 4'hb;
			4'd4: go_buffs[3:0] = 4'hc;// U (obvi)
			4'd5: go_buffs[3:0] = 4'hf;
			4'd6: go_buffs[3:0] = 4'hf;
			4'd7: go_buffs[3:0] = 4'h5;
			4'd8: go_buffs[3:0] = 4'hd;
			4'd9: go_buffs[3:0] = 4'hd;
			4'd10: go_buffs[3:0] = 4'hd;
			4'd11: go_buffs[3:0] = 4'hd;
			4'd12: go_buffs[3:0] = 4'hd;
		endcase

	end
	
	// Main state machine variables
	reg [1:0] state;
	reg [3:0] switch_num;
	reg [19:0] stored_time;
	
	always@(posedge ADC_CLK_10, negedge KEY[0]) // Update super quick, or on reset
	begin
	
		if(~KEY[0]) //Reset
		begin
			clreset = 1'b1; // Set the clock to reset
			LEDR = 10'd0; // Clear the LEDs
			state = 2'b00; // Set the state to PS
		end
		
		else
		begin
			case(state)
			2'b00: // PS, aka 'GO BUFFS'
				begin
				
					decimal = 1'b0; // Blank
					display = go_buffs; // Display contents of go_buffs
						
					if(~KEY[1]) // If start
					begin
						rand_num_saved = rand_num; // Save a random number
						clreset = 1'b1; // Reset the clock
						state = 2'b01; // RW
					end
					
				end
			2'b01: // RW, wait until counter = stored rand
				begin
					
					if(~KEY[1]) // If start is pressed
					begin
						clreset = 1'b1; // Reset our clock
					end
					else if(clreset == 1) // Else, if the counter is being reset
					begin
						clreset = 1'b0; // Enable the counter
					end
					
					decimal = 1'b0; // Blank
					display = 24'b110111011101110111011101; // Blank
					
					if(rand_num_saved == count_binary) // Our exit scenario
					begin
						switch_num = count[3:0]; // Save a switch to use
						clreset = 1'b1; // Reset the counter
						state = 2'b10; // Wait on the user
					end
					
				end
			2'b10: // UW, count time spent here
				begin
				
					if(clreset == 1'b1) // If our counter is being reset
					begin
						clreset = 1'b0; // Enable the counter
					end
					
					decimal = 1'b0; // Blank
					display = 24'b110111011101110111011101; // Blank
					
					case(switch_num) // Check the correct switch. If it's on, change state.
						4'b0000: 
						begin
							LEDR = 10'b0000000001; // Turn on the right LED.
							if(SW[0] == 1) state = 2'b11; // If SW[correct], go to display.
						end
						4'b0001: 
						begin
							LEDR = 10'b0000000010;
							if(SW[1] == 1) state = 2'b11;
						end
						4'b0010: 
						begin
							LEDR = 10'b0000000100;
							if(SW[2] == 1) state = 2'b11;
						end
						4'b0011: 
						begin
							LEDR = 10'b0000001000;
							if(SW[3] == 1) state = 2'b11;
						end
						4'b0100: 
						begin
							LEDR = 10'b0000010000;
							if(SW[4] == 1) state = 2'b11;
						end
						4'b0101: 
						begin
							LEDR = 10'b0000100000;
							if(SW[5] == 1) state = 2'b11;
						end
						4'b0110: 
						begin
							LEDR = 10'b0001000000;
							if(SW[6] == 1) state = 2'b11;
						end
						4'b0111: 
						begin
							LEDR = 10'b0010000000;
							if(SW[7] == 1) state = 2'b11;
						end
						4'b1000: 
						begin
							LEDR = 10'b0100000000;
							if(SW[8] == 1) state = 2'b11;
						end
						4'b1001: 
						begin
							LEDR = 10'b1000000000;
							if(SW[9] == 1) state = 2'b11;
						end
					endcase
					
				end
			2'b11: //DS, display the count from UW
				begin
					if(clreset == 1'b0) // If our counter is running
					begin
						stored_time = count; // Save the current count
						clreset = 1'b1; // Set the counter to reset
					end
					
					LEDR = 10'b0000000000; // Clear the LEDs 
					decimal = 1'b1; // Display a decimal point
					display = stored_time; // Display the user's time
					
					if(~KEY[1]) // If start is pressed
					begin
						clreset = 1'b1; // Reset the clock
						state = 2'b01; // Set the state to RW
					end
					
				end
			endcase
		end
	end
endmodule
