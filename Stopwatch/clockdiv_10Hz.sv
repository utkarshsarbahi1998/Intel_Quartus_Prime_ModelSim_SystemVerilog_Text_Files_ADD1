module clockdiv_10Hz (iclk, oclk);
	input iclk;
	output logic oclk;
	
	parameter divisor = 5000000;
//	parameter divisor = 2; // Used for the testbench
	
	logic [22:0] count = 23'd0;
	
	always_ff @ (posedge iclk)
	begin
		count <= count + 23'd1;
		if (count >= (divisor - 1))
			count <= 23'd0;
		oclk <= (count < divisor/2) ? 1'b1 : 1'b0;
	end
endmodule

// ---- ---- ---- ---- //

`timescale 1ns / 1ps

module clockdiv_10Hz_tb ();
	
	logic iclk, oclk;
	
	clockdiv_10Hz simulation(.iclk(iclk), .oclk(oclk));
	
	always #5 iclk = ~iclk;
	
	initial begin
	iclk = 1'b1;
	end

endmodule
