module lab2_czReg (Clock, Reset, WriteCZ, cf_flag, zf_flag, cf, zf);

	input WriteCZ, cf_flag, zf_flag, Clock, Reset;
	output logic cf, zf;

	always_ff @ (posedge Clock) begin
		unique casex ({Reset, WriteCZ})
		{1'b1, 1'bx} : begin
			cf <= 1'b0;
			zf <= 1'b0; end
		{1'b0, 1'b1} : begin
			cf <= cf_flag;
			zf <= zf_flag; end
		endcase
	end
endmodule

// ---- ---- ---- ---- //

`timescale 1ns / 1ps

module lab2_czReg_tb ();
	
	logic Clock, WriteCZ, cf_flag, zf_flag, Reset, cf, zf;
	lab2_czReg simulation(.Clock(Clock), .Reset(Reset), .WriteCZ(WriteCZ), .cf_flag(cf_flag), .zf_flag(zf_flag), .cf(cf), .zf(zf));
	
	always #6 Clock = ~Clock;
	
	initial begin
		Clock = 1'b0;
		#1 cf_flag = 1'b1; zf_flag = 1'b0; Reset = 1'b0; WriteCZ = 1'b1;          
		#10 cf_flag = 1'b0; zf_flag = 1'b0; Reset = 1'b0; WriteCZ = 1'b1;
		#10 cf_flag = 1'b0; zf_flag = 1'b1; Reset = 1'b0; WriteCZ = 1'b1;
		#10 cf_flag = 1'b1; zf_flag = 1'b1; Reset = 1'b0; WriteCZ = 1'b1;
		#10 cf_flag = 1'b1; zf_flag = 1'b0; Reset = 1'b0; WriteCZ = 1'b0;          
		#10 cf_flag = 1'b0; zf_flag = 1'b0; Reset = 1'b0; WriteCZ = 1'b0;
		#10 cf_flag = 1'b0; zf_flag = 1'b1; Reset = 1'b0; WriteCZ = 1'b1;
		#10 cf_flag = 1'b1; zf_flag = 1'b1; Reset = 1'b0; WriteCZ = 1'b0;
		#10 cf_flag = 1'b1; zf_flag = 1'b1; Reset = 1'b0; WriteCZ = 1'b0;
		#10 cf_flag = 1'b1; zf_flag = 1'b1; Reset = 1'b1; WriteCZ = 1'b1;
	end
endmodule

