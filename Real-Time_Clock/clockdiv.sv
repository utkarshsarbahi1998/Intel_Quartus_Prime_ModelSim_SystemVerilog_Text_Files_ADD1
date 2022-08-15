module clockdiv (iclk, oclk);
	input iclk;
	output logic oclk;
	
	parameter divisor = 25;
	
	logic [5:0] count = 6'd0;
	
	always_ff @ (posedge iclk)
	begin
		count <= count + 6'd1;
		if (count >= (divisor - 1))
			count <= 6'd0;
		oclk <= (count < divisor/2) ? 1'b1 : 1'b0;
	end
endmodule

// ---- ---- ---- ---- //

`timescale 1ns / 1ps

module clockdiv_tb ();
	
	logic iclk, oclk;
	
	clockdiv simulation(.iclk(iclk), .oclk(oclk));
	
	always #1 iclk = ~iclk;
	
	initial begin
		iclk = 1'b1;
	end

endmodule
