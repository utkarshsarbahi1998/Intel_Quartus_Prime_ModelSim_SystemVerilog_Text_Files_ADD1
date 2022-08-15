module lab2_alu_new (a_bus, b_bus, c_bus, f_4, cf_flag, zf_flag, ABusIndication, BBusIndication, CBusIndication);

	input [3:0] f_4; input [7:0] a_bus, b_bus;
	output logic cf_flag, zf_flag; output logic [7:0] c_bus, ABusIndication, BBusIndication, CBusIndication;

	always_latch begin  
		cf_flag = 0; zf_flag = 0;
		case (f_4)
		4'd1 : c_bus = b_bus;
		4'd2 : c_bus = a_bus;
		4'd3 : {cf_flag, c_bus} = a_bus + 1'b1;
		4'd4 : {cf_flag, c_bus} = b_bus + 1'b1;
		4'd5 : c_bus = a_bus;
		4'd6 : begin
			{cf_flag, c_bus} = a_bus + b_bus;
			if (c_bus == 0) begin
				zf_flag = 1; end
		end
		4'd7 : begin
			{cf_flag, c_bus} = a_bus - b_bus;
			if (c_bus == 0) begin
				zf_flag = 1; end
		end
		4'd8 : begin 
			c_bus = a_bus & b_bus;
			if (c_bus == 0) begin
				zf_flag = 1; end
		end
		4'd9 : begin 
			c_bus = a_bus | b_bus;
			if (c_bus == 0) begin
				zf_flag = 1; end
		end
		4'd10 : c_bus = a_bus << 1'b1;
		4'd11 : c_bus = a_bus >> 1'b1;
		default : ;
		endcase
		CBusIndication = c_bus; ABusIndication = a_bus; BBusIndication = b_bus;
	end
endmodule

// ---- ---- ---- ---- //

`timescale 1ns / 1ps

module lab2_alu_new_tb ();
	
	logic cf_flag, zf_flag; logic [3:0] f_4; logic [7:0] a_bus, b_bus, c_bus;
	lab2_alu_new simulation(.a_bus(a_bus), .b_bus(b_bus), .f_4(f_4), .c_bus(c_bus), .cf_flag(cf_flag), .zf_flag(zf_flag));
	
	initial begin
		a_bus = 8'b00001011; b_bus = 8'b00000011;          
		#20 f_4 = 4'b0000;
		#20 f_4 = 4'b0001;
		#20 f_4 = 4'b0010;
		#20 f_4 = 4'b0011;		
		#20 f_4 = 4'b0100; 
		#20 f_4 = 4'b0101;
		#20 f_4 = 4'b0110;
		#20 f_4 = 4'b0111;
		#20 f_4 = 4'b1000; 
		#20 f_4 = 4'b1001;
		#20 f_4 = 4'b1010;
		#20 f_4 = 4'b1011;
		#10 b_bus = 8'b11110000; a_bus = 8'b11110000;
		#20 f_4 = 4'b0001; 
		#20 f_4 = 4'b0110;
		#20 f_4 = 4'b0111;
		#20 f_4 = 4'b1000;
		#20 f_4 = 4'b1001;
		#10 b_bus = 8'b11110000; a_bus = 8'b01110000;
		#20 f_4 = 4'b0111;
		#10 b_bus = 8'b00000000; a_bus = 8'b00000000;
		#20 f_4 = 4'b0001;
		#20 f_4 = 4'b0110;
		#20 f_4 = 4'b0111;
	end
endmodule

