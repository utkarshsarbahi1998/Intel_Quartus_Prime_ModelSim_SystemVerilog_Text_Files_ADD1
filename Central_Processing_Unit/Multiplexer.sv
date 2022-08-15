module Multiplexer (MuxSelect, BRegister, SwitchInput, Reserved_1, Reserved_2, BOutput);

	input [1:0] MuxSelect; 
	input [7:0] BRegister, SwitchInput, Reserved_1, Reserved_2;
	output logic [7:0] BOutput;

	always_comb begin
		case (MuxSelect)
		2'b00: BOutput = BRegister;
		2'b01: BOutput = Reserved_1;
		2'b10: BOutput = Reserved_2;
		2'b11: BOutput = SwitchInput;
		endcase
	end	
endmodule

// ---- ---- ---- ---- //

`timescale 1ns / 1ps

module Multiplexer_TB ();
	
	logic [1:0] muxSelect; logic [7:0] bRegister, switchInput, reserved_1, reserved_2, bOutput;
	Multiplexer simulation(.MuxSelect(muxSelect), .BRegister(bRegister), .SwitchInput(switchInput), .Reserved_1(reserved_1), .Reserved_2(reserved_2), .BOutput(bOutput));
	
	initial begin
		muxSelect = 2'b00; bRegister = 8'd1; switchInput = 8'd2; reserved_1 = 8'd3; reserved_2 = 8'd4;
		#10;
		muxSelect = 2'b01; bRegister = 8'd1; switchInput = 8'd2; reserved_1 = 8'd3; reserved_2 = 8'd4;
		#10;
		muxSelect = 2'b10; bRegister = 8'd1; switchInput = 8'd2; reserved_1 = 8'd3; reserved_2 = 8'd4;
		#10;
		muxSelect = 2'b11; bRegister = 8'd1; switchInput = 8'd2; reserved_1 = 8'd3; reserved_2 = 8'd4;
		#10;
	end
endmodule 