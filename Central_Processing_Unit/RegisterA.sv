module RegisterA (CBus, WriteA, Clock, Reset, ABus);

	input WriteA, Clock, Reset; input [7:0] CBus; 
	output logic [7:0] ABus;

	always_ff @ (posedge Clock) begin
		if (Reset)
		begin
			ABus <= 8'b0;
		end
		else if (WriteA)
		begin
		ABus <= CBus;
		end
	end
endmodule 

// ---- ---- ---- ---- //

`timescale 1ns / 1ps

module Register_A_B_Output_TB ();
	
	parameter CLOCK_HALF_PERIOD = 5;
	logic WriteA, Clock, Reset; logic [7:0] CBus, ABus;
	RegisterOutput simulation (.CBus(CBus), .WriteO(WriteA), .Clock(Clock), .Reset(Reset), .DisplayValue(ABus));
	
	always begin
		Clock = 1'b0;
		#CLOCK_HALF_PERIOD;
		Clock = 1'b1;
		#CLOCK_HALF_PERIOD;
	end
	
	initial begin
		Reset = 1'b1;
		#10 
		Reset = 1'b0; 
	end
	
	initial begin
		WriteA = 1'b0; CBus = 8'b00001111;
		#10;
		WriteA = 1'b1; CBus = 8'b00001111;
		#10
		WriteA = 1'b0; CBus = 8'b00000000;
		#10;
		WriteA = 1'b1; CBus = 8'b00000000;
		#10
		WriteA = 1'b0; CBus = 8'b11111111;
		#10;
		WriteA = 1'b1; CBus = 8'b11111111;
		#10
		WriteA = 1'b0; CBus = 8'b01010101;
		#10;
		WriteA = 1'b1; CBus = 8'b01010101;
		#10
		WriteA = 1'b0; CBus = 8'b11110000;
		#10;
		WriteA = 1'b1; CBus = 8'b11110000;
		#10
		WriteA = 1'b0; CBus = 8'b10101010;
		#10;
		WriteA = 1'b1; CBus = 8'b10101010;
		#10;
	end
endmodule
