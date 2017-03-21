module top(SW, KEY, LEDR, HEX0, HEX1, HEX5, ADC_CLK_10);
		input [9:0] SW; 
		input [1:0] KEY; 
		input ADC_CLK_10;
		output reg [9:0] LEDR; 
		output [7:0] HEX0; 
		output [7:0] HEX1; 
		output [7:0] HEX5; 
		
		reg [1:0] state;
	
		always@(posedge KEY[0])
			begin 
				state[0] = ~state[0];
			end
		
		
		always@(posedge KEY[1])
			begin 
				state[1] = ~state[1];
			end
		
		wire [8:0] a1out;
		Arithmetic a1(SW[3:0], SW[7:4], SW[9:8], a1out[8:0]);
		
		wire [7:0] l1out;
		Logical l1(SW[3:0], SW[7:4], SW[9:8], l1out[7:0]);
		
		wire [7:0] c1out;
		Comparison c1(SW[3:0], SW[7:4], SW[9:8], c1out[7:0]);
		
		wire [9:0] m1out;
		Magic m1(m1out[9:0], ADC_CLK_10);

		wire [8:0] out;
		Mux #(9) mt (a1out[8:0], l1out[7:0], c1out[7:0], 1'b0, state, out[8:0]);
		
		sevenSegmentMode sM(state, HEX5); //Mode Indicator
		sevenSegment s0(out[3:0], HEX0); //Lowest Significant Hex Digit
		sevenSegment s1(out[7:4], HEX1); //Most Significant Hex Digit
		
		always@(*)
		begin
			case(state)
				2'b00: begin LEDR[9] = out[8]; LEDR[8:0] = 9'b000000000; end			//Carry
				2'b01: begin LEDR[9] = out[8]; LEDR[8:0] = 9'b000000000; end			//Carry
				2'b10: begin LEDR[9] = out[8]; LEDR[8:0] = 9'b000000000; end			//Carry
				2'b11: LEDR[9:0] = m1out[9:0];	//Output from Magic
			endcase
		end
endmodule
