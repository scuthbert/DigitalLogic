module master_ctrl(clk,
						 btn,
						 switch,
						 go_buffs,
						 rand_num,
						 count,
						 count_binary,
						 clreset_q,
						 display_q,
						 led_q);

	input clk;
	input [1:0] btn;
	input [9:0] switch;
	input [24:0] go_buffs;
	input [14:0] rand_num;
	input [19:0] count;
	input [19:0] count_binary;

	output reg clreset_q;
	reg clreset_d;

	output reg [25:0] display_q;
	reg [25:0] display_d;

	output reg [9:0] led_q;
	reg [9:0] led_d;

	// Main state machine variables
	localparam  Paused = 2'b00,
					RandWait = 2'b01,
					UserWait = 2'b10,
					Display = 2'b11;

	reg [1:0] state_d, state_q;
	reg [3:0] switch_num_d, switch_num_q;
	reg [19:0] stored_time_d, stored_time_q;
	reg [14:0] rand_num_saved_d, rand_num_saved_q;
	reg [19:0] high_score_d, high_score_q;

	always@(*)
	begin
	
		state_d = state_q;
		switch_num_d = switch_num_q;
		stored_time_d = stored_time_q;
		rand_num_saved_d = rand_num_saved_q;
		high_score_d = high_score_q;
		
		clreset_d = clreset_q;
		display_d = display_q;
		led_d = led_q;
	
		case(state_q)
			Paused: // aka 'GO BUFFS'
				begin

					if(switch[0]) begin
						display_d[25] = 1'b0; // No decimal
						display_d[24:0] = go_buffs; // Display contents of go_buffs
					end else begin
						display_d[25] = 1'b1;
						display_d[24:0] = high_score_q;
					end

					if(~btn[1]) // If start
					begin
						rand_num_saved_d = rand_num; // Save a random number
						clreset_d = 1'b1; // Reset the clock
						state_d = RandWait; // RandWait
					end

				end
			RandWait: // RW, wait until counter = stored rand
				begin

					if(~btn[1]) // If start is pressed
					begin
						clreset_d = 1'b1; // Reset our clock
					end
					else if(clreset_q == 1) // Else, if the counter is being reset
					begin
						clreset_d = 1'b0; // Enable the counter
					end

					display_d[25] = 1'b0; // Blank
					display_d[24:0] = 24'b110111011101110111011101; // Blank

					if(rand_num_saved_q == count_binary) // Our exit scenario
					begin
						switch_num_d = count[3:0]; // Save a switch to use
						clreset_d = 1'b1; // Reset the counter
						state_d = UserWait; // Wait on the user
					end

				end
			UserWait: // UW, count time spent here
				begin

					if(clreset_q == 1'b1) // If our counter is being reset
					begin
						clreset_d = 1'b0; // Enable the counter
					end

					display_d[25] = 1'b0; // Blank
					display_d[24:0] = 24'b110111011101110111011101; // Blank

					case(switch_num_q) // Check the correct switch. If it's on, change state.
						4'b0000:
						begin
							led_d = 10'b0000000001; // Turn on the right LED.
							if(switch[0] == 1) state_d = Display; // If switch[correct], go to display.
						end
						4'b0001:
						begin
							led_d = 10'b0000000010;
							if(switch[1] == 1) state_d = Display;
						end
						4'b0010:
						begin
							led_d = 10'b0000000100;
							if(switch[2] == 1) state_d = Display;
						end
						4'b0011:
						begin
							led_d = 10'b0000001000;
							if(switch[3] == 1) state_d = Display;
						end
						4'b0100:
						begin
							led_d = 10'b0000010000;
							if(switch[4] == 1) state_d = Display;
						end
						4'b0101:
						begin
							led_d = 10'b0000100000;
							if(switch[5] == 1) state_d = Display;
						end
						4'b0110:
						begin
							led_d = 10'b0001000000;
							if(switch[6] == 1) state_d = Display;
						end
						4'b0111:
						begin
							led_d = 10'b0010000000;
							if(switch[7] == 1) state_d = Display;
						end
						4'b1000:
						begin
							led_d = 10'b0100000000;
							if(switch[8] == 1) state_d = Display;
						end
						4'b1001:
						begin
							led_d = 10'b1000000000;
							if(switch[9] == 1) state_d = Display;
						end
					endcase

				end
			Display: //DS, display the count from UW
				begin
				
					if(clreset_q == 1'b0) // If our counter is running
					begin
						stored_time_d = count; // Save the current count
						clreset_d = 1'b1; // Set the counter to reset
						if(count < high_score_q) begin
							high_score_d = count;
						end
					end

					led_d = 10'b0000000000; // Clear the LEDs
					display_d[25] = 1'b1; // Display a decimal point
					display_d[24:0] = stored_time_q; // Display the user's time

					if(~btn[1]) // If start is pressed
					begin
						clreset_d = 1'b1; // Reset the clock
						state_d = 2'b01; // Set the state to RW
					end

				end
		endcase
	end

	always@(posedge clk, negedge btn[0]) // Update super quick, or on reset
	begin
		if(~btn[0]) //Reset
		begin

			clreset_q <= 1'b1; // Set the clock to reset
			led_q <= 10'd0; // Clear the LEDs
			state_q <= Paused; // Set the state to PS

		end
		else begin

			//Toggle the state, display, etc...
			clreset_q <= clreset_d;
			display_q <= display_d;
			led_q <= led_d;
			switch_num_q <= switch_num_d;
			stored_time_q <= stored_time_d;
			rand_num_saved_q <= rand_num_saved_d;
			high_score_q <= high_score_d;
			state_q <= state_d;

		end
	end

endmodule
