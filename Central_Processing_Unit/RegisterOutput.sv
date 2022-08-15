module RegisterOutput (CBus, WriteO, Clock, Reset, DisplayValue);

	input WriteO, Clock, Reset; input [7:0] CBus; 
	output logic [7:0] DisplayValue;

	always_ff @ (posedge Clock) begin
		if (Reset)
		begin
			DisplayValue <= 8'b0;
		end
		else if (WriteO)
		begin
			DisplayValue <= CBus;
		end
	end
endmodule
