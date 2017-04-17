module BCD_counter (clk, reset, value);
	input clk, reset;
	output reg [19:0] value; //5 Digits
	
	always@(posedge clk, posedge reset)
	begin	
		
		//Reset
		if(reset)
		begin
			value = 19'b0000000000000000000;
		end
		
		else
		begin
			value = value + 1;
			//First Digit
			if(value[3:0] == 10)
			begin
				value[7:4] = value[7:4] + 1;
				value[3:0] = 4'b0000;
			end
			
			//Second Digit
			if(value[7:4] == 10)
			begin
				value[11:8] = value[11:8] + 1;
				value[7:4] = 4'b0000;
			end
			
			//Third Digit
			if(value[11:8] == 10)
			begin
				value[15:12] = value[15:12] + 1;
				value[11:8] = 4'b0000;
			end
			
			//Fourth Digit
			if(value[15:12] == 10)
			begin
				value[19:16] = value[19:16] + 1;
				value[15:12] = 4'b0000;
			end
			
			//Fifth Digit
			if(value[19:16] == 10)
			begin
				//Loop around
				value = 19'b0000000000000000000;
			end
		end
	end
	
endmodule
