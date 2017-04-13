module clk_divider #(parameter SIZE = 1)(inclk, factor, outclk);
	input inclk;
	input[SIZE-1:0] factor;
	output reg outclk;
	
	reg[SIZE-1:0] count;
	
	always@(posedge inclk)
	begin
		count = count + 1;
		if(count == factor)
		begin
			outclk = ~outclk;
			count = 1'b0;
		end
	end

endmodule
