module buffs_slider(super_slow_clk, go_buffs);
	input super_slow_clk;
	output reg [24:0] go_buffs;

	reg [3:0] position;
	always@(posedge super_slow_clk)
	begin

		if(go_buffs == 24'd0)
		begin
			go_buffs = 24'b110111011101110111011101; // Blank
		end

		go_buffs = go_buffs << 4; // Shift left a digit

		if(position == 4'd12) position = 1'b0; // Loop around
		else position = position + 1'b1; // Increment

		case(position)
			4'd0: go_buffs[3:0] = 4'h6;
			4'd1: go_buffs[3:0] = 4'h0;
			4'd2: go_buffs[3:0] = 4'hd; // Space
			4'd3: go_buffs[3:0] = 4'hb;
			4'd4: go_buffs[3:0] = 4'hc; // U (obvi)
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

endmodule
