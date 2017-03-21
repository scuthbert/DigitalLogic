module Magic(out, clk);
	input clk;
	output reg [9:0] out;
	
	reg reset, samp_clk;
	integer counter;
	integer LEDnum;
	integer direction;
	
	always@(posedge clk)
    if(~reset)begin
        if(counter == 500000)begin
            samp_clk <= ~samp_clk;
            counter <= 0;
        end
        else begin
            counter <= counter + 1;
        end
    end
    else begin
        samp_clk <= 0;
    end
	 
	 always@(posedge samp_clk)
    begin
			if(LEDnum == 9)begin
					direction <= -1;
			end
			if(LEDnum == 0)begin
					direction <= 1;
			end
			LEDnum <= LEDnum + 1*direction;
	
			out[LEDnum] = 1'b1;
			out[LEDnum - 1*direction] = 1'b0;
    end
	
endmodule
