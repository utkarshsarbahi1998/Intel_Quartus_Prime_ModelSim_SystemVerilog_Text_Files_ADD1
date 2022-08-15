module ControlUnit (Key_0, Opcode, f_4, MuxSelect, WriteA, WriteB, WriteO, WriteCZ);

	input Key_0; input [3:0] Opcode;
	output logic WriteA, WriteB, WriteO, WriteCZ; 
	output logic [1:0] MuxSelect; 
	output logic [3:0] f_4; 

	logic flag;

	always_latch begin
		if (Key_0 == 1'b1)
		begin
			f_4 = Opcode;
			WriteA = 1'b0; WriteB = 1'b0; WriteO = 1'b0; WriteCZ = 1'b0; MuxSelect = 2'b00;
			case (f_4)
			4'd0: WriteCZ = 1'b1;
			4'd1: begin
				WriteA = 1'b1;
				WriteCZ = 1'b1;
				MuxSelect = 2'b11; end
			4'd2: begin
				WriteA = 1'b1;
				WriteO = 1'b1; end
			4'd3: begin
				WriteA = 1'b1;
				WriteCZ = 1'b1; end
			4'd4: begin
				WriteB = 1'b1;
				WriteCZ = 1'b1; end
			4'd5: WriteB = 1'b1;
			4'd6: begin
				WriteA = 1'b1;
				WriteCZ = 1'b1; end
			4'd7: begin
				WriteA = 1'b1;
				WriteCZ = 1'b1; end
			4'd8: begin
				WriteA = 1'b1;
				WriteCZ = 1'b1; end
			4'd9: begin
				WriteA = 1'b1;
				WriteCZ = 1'b1; end
			4'd10: begin
				WriteA = 1'b1;
				WriteCZ = 1'b1; end
			4'd11: begin
				WriteA = 1'b1;
				WriteCZ = 1'b1; end
			default: ;
			endcase
			flag = 1'b1;
		end
		else if (Key_0 == 1'b0 && flag == 1'b1)
		begin
		case (f_4)
			4'd1: MuxSelect = 2'b11;
			default: MuxSelect = 2'b00;
		endcase
		end
	end
endmodule

// ---- ---- ---- ---- //

`timescale 1ns / 1ps

module ControlUnit_TB ();
	
	logic key_0, writeA, writeB, writeO, writeCZ; logic [1:0] muxSelect; logic [3:0] opcode, f_4;
	ControlUnit simulation(.Key_0(key_0), .Opcode(opcode), .f_4(f_4), .MuxSelect(muxSelect), .WriteA(writeA), .WriteB(writeB), .WriteO(writeO), .WriteCZ(writeCZ));
	
	initial begin
		key_0 = 1'b0; opcode = 4'b0000;          
		#10;  
		key_0 = 1'b0; opcode = 4'b0001; 
		#10;
		key_0 = 1'b0; opcode = 4'b0010;          
		#10;  
		key_0 = 1'b0; opcode = 4'b0011; 
		#10;
		key_0 = 1'b0; opcode = 4'b0100;          
		#10;  
		key_0 = 1'b0; opcode = 4'b0101; 
		#10;
		key_0 = 1'b1; opcode = 4'b0000;          
		#10; 
		key_0 = 1'b1; opcode = 4'b0001; 
		#10;
		key_0 = 1'b1; opcode = 4'b0010;          
		#10;  
		key_0 = 1'b1; opcode = 4'b0011; 
		#10;
		key_0 = 1'b1; opcode = 4'b0100;          
		#10;
		key_0 = 1'b1; opcode = 4'b0101; 
		#10;
		key_0 = 1'b0; opcode = 4'b0110;          
		#10;
		key_0 = 1'b0; opcode = 4'b0111; 
		#10;
		key_0 = 1'b0; opcode = 4'b1000;          
		#10; 
		key_0 = 1'b0; opcode = 4'b1001; 
		#10;
		key_0 = 1'b0; opcode = 4'b1010;          
		#10;
		key_0 = 1'b0; opcode = 4'b1011; 
		#10;
		key_0 = 1'b1; opcode = 4'b0110;          
		#10; 
		key_0 = 1'b1; opcode = 4'b0111; 
		#10;
		key_0 = 1'b1; opcode = 4'b1000;          
		#10;
		key_0 = 1'b1; opcode = 4'b1001; 
		#10;
		key_0 = 1'b1; opcode = 4'b1010;          
		#10; 
		key_0 = 1'b1; opcode = 4'b1011; 
		#10;
	end
endmodule
