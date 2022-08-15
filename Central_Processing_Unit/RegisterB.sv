module RegisterB (CBus, WriteB, Clock, Reset, BBus);

	input WriteB, Clock, Reset; input [7:0] CBus; 
	output logic [7:0] BBus;

	always_ff @ (posedge Clock) begin
		if (Reset)
		begin
			BBus <= 8'b0;
		end
		else if (WriteB)
		begin
			BBus <= CBus;
		end
	end
endmodule
