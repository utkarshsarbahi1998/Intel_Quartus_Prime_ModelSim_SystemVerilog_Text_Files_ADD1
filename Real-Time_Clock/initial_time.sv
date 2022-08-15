module initial_time (switches, digit_second_0, digit_second_1, digit_minute_0, digit_minute_1);
	
	input [15:0] switches;
	output logic [3:0] digit_second_0, digit_second_1, digit_minute_0, digit_minute_1;
	
	assign digit_second_0 = {switches[3], switches[2], switches[1], switches[0]};
	assign digit_second_1 = {switches[7], switches[6], switches[5], switches[4]};
	assign digit_minute_0 = {switches[11], switches[10], switches[9], switches[8]};
	assign digit_minute_1 = {switches[15], switches[14], switches[13], switches[12]};

endmodule

// ---- ---- ---- ---- //

`timescale 1ns / 1ps

module initial_time_test_bench ();
	
	logic [15:0] switches_TB; logic [3:0] digit_second_0_TB, digit_second_1_TB, digit_minute_0_TB, digit_minute_1_TB;
	parameter DELAY = 100;
	initial_time simulation (.switches (switches_TB), .digit_second_0 (digit_second_0_TB), .digit_second_1 (digit_second_1_TB), .digit_minute_0 (digit_minute_0_TB), .digit_minute_1 (digit_minute_1_TB));
	
	initial
	begin
		switches_TB = 16'b11_11_11_11_11_11_11_11;
		#DELAY;
		switches_TB = 16'b00_00_00_00_00_00_00_00;
		#DELAY;
		switches_TB = 16'b11_00_00_11_11_00_00_11;
		#DELAY;
		switches_TB = 16'b11_11_00_00_11_11_00_00;
	end

endmodule
