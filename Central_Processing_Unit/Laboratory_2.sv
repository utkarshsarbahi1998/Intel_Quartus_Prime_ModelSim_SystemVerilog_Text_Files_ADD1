`timescale 1ns / 1ps

module Laboratory_2 (key_0, opcode, switchInput, clock, reset, ledDisplay1, ledDisplay2, ledDisplay3, ledDisplay4, ledDisplay5, ledDisplay6, ledDisplay7, ledDisplay8, cFlag, zFlag, displayValue_2, aBusIndication, bBusIndication, cBusIndication);

	input key_0, clock, reset; 
	input [3:0] opcode; 
	input [7:0] switchInput;
	output logic cFlag, zFlag; 
	output logic [6:0] ledDisplay1, ledDisplay2, ledDisplay3, ledDisplay4, ledDisplay5, ledDisplay6, ledDisplay7, ledDisplay8; 
	output logic [7:0] displayValue_2, aBusIndication, bBusIndication, cBusIndication;
	logic writeA, writeB, writeO, writeCZ, cf, zf; 
	logic [1:0] muxSelect; 
	logic [3:0] f_4; 
	logic [7:0] aBus, bBus, cBus, bRegister, reserved, displayValue;

	ControlUnit instant1 (.Key_0(key_0), .Opcode(opcode), .f_4(f_4), .MuxSelect(muxSelect), .WriteA(writeA), .WriteB(writeB), .WriteO(writeO), .WriteCZ(writeCZ));
	lab2_alu_new instant2 (.a_bus(aBus), .b_bus(bBus), .c_bus(cBus), .f_4(f_4), .cf_flag(cf), .zf_flag(zf), .ABusIndication(aBusIndication), .BBusIndication(bBusIndication), .CBusIndication(cBusIndication));
	Multiplexer instant3 (.MuxSelect(muxSelect), .BRegister(bRegister), .SwitchInput(switchInput), .Reserved_1(reserved), .Reserved_2(reserved), .BOutput(bBus));
	RegisterA instant4 (.CBus(cBus), .WriteA(writeA), .Clock(clock), .Reset(reset), .ABus(aBus));
	RegisterB instant5 (.CBus(cBus), .WriteB(writeB), .Clock(clock), .Reset(reset), .BBus(bRegister));
	RegisterOutput instant6 (.CBus(cBus), .WriteO(writeO), .Clock(clock), .Reset(reset), .DisplayValue(displayValue));
	SevenSegment instant7 (.DisplayValue(displayValue), .LEDDisplay1(ledDisplay1), .LEDDisplay2(ledDisplay2), .LEDDisplay3(ledDisplay3), .LEDDisplay4(ledDisplay4), .LEDDisplay5(ledDisplay5), .LEDDisplay6(ledDisplay6), .LEDDisplay7(ledDisplay7), .LEDDisplay8(ledDisplay8), .DisplayValue_2(displayValue_2));
	lab2_czReg instant8(.Clock(clock), .Reset(reset), .WriteCZ(writeCZ), .cf_flag(cf), .zf_flag(zf), .cf(cFlag), .zf(zFlag));

endmodule

// ---- ---- ---- ---- //

module Laboratory_2_Final_TB ();
	
	parameter CLOCK_HALF_PERIOD = 4;
	logic key_0, clock, reset, cFlag, zFlag; logic [3:0] opcode; logic [6:0] ledDisplay1, ledDisplay2, ledDisplay3, ledDisplay4, ledDisplay5, ledDisplay6, ledDisplay7, ledDisplay8;
	logic [7:0] switchInput, DisplayValue_2, ABusIndication, BBusIndication, CBusIndication;
	Laboratory_2 simulation(.key_0(key_0), .opcode(opcode), .switchInput(switchInput), .clock(clock), .reset(reset), .ledDisplay1(ledDisplay1), .ledDisplay2(ledDisplay2), .ledDisplay3(ledDisplay3), .ledDisplay4(ledDisplay4), .ledDisplay5(ledDisplay5), .ledDisplay6(ledDisplay6), .ledDisplay7(ledDisplay7), .ledDisplay8(ledDisplay8), .cFlag(cFlag), .zFlag(zFlag), .displayValue_2(DisplayValue_2), .aBusIndication(ABusIndication), .bBusIndication(BBusIndication), .cBusIndication(CBusIndication));
	
	always begin
		clock = 1'b0;
		#CLOCK_HALF_PERIOD;
		clock = 1'b1;
		#CLOCK_HALF_PERIOD;
	end
	
	initial begin
		reset = 1'b1;
		#8 
		reset = 1'b0;
	end
	
	initial begin
		key_0 = 1'b1; opcode = 4'b0001; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b0; opcode = 4'b0001; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b1; opcode = 4'b0001; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b0; opcode = 4'b0001; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b1; opcode = 4'b0001; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b0; opcode = 4'b0001; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b1; opcode = 4'b0010; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b0; opcode = 4'b0010; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b1; opcode = 4'b0010; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b0; opcode = 4'b0010; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b1; opcode = 4'b0010; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b0; opcode = 4'b0010; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b1; opcode = 4'b0101; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b0; opcode = 4'b0101; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b1; opcode = 4'b0101; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b0; opcode = 4'b0101; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b1; opcode = 4'b0101; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b0; opcode = 4'b0101; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b1; opcode = 4'b0011; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b0; opcode = 4'b0011; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b1; opcode = 4'b0011; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b0; opcode = 4'b0011; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b1; opcode = 4'b0011; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b0; opcode = 4'b0011; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b1; opcode = 4'b1000; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b0; opcode = 4'b1000; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b1; opcode = 4'b1000; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b0; opcode = 4'b1000; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b1; opcode = 4'b1000; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b0; opcode = 4'b1000; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b1; opcode = 4'b1001; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b0; opcode = 4'b1001; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b1; opcode = 4'b1001; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b0; opcode = 4'b1001; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b1; opcode = 4'b1001; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b0; opcode = 4'b1001; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b1; opcode = 4'b1000; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b0; opcode = 4'b1000; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b1; opcode = 4'b1000; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b0; opcode = 4'b1000; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b1; opcode = 4'b1000; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b0; opcode = 4'b1000; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b1; opcode = 4'b1001; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b0; opcode = 4'b1001; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b1; opcode = 4'b1001; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b0; opcode = 4'b1001; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b1; opcode = 4'b1001; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b0; opcode = 4'b1001; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b1; opcode = 4'b0110; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b0; opcode = 4'b0110; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b1; opcode = 4'b0110; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b0; opcode = 4'b0110; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b1; opcode = 4'b0110; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b0; opcode = 4'b0110; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b1; opcode = 4'b0111; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b0; opcode = 4'b0111; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b1; opcode = 4'b0111; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b0; opcode = 4'b0111; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b1; opcode = 4'b0111; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b0; opcode = 4'b0111; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b1; opcode = 4'b0001; switchInput = 8'b11111111;
		#10;
		key_0 = 1'b0; opcode = 4'b0001; switchInput = 8'b11111111;
		#10;
		key_0 = 1'b1; opcode = 4'b0001; switchInput = 8'b11111111;
		#10;
		key_0 = 1'b0; opcode = 4'b0001; switchInput = 8'b11111111;
		#10;
		key_0 = 1'b1; opcode = 4'b0001; switchInput = 8'b11111111;
		#10;
		key_0 = 1'b0; opcode = 4'b0001; switchInput = 8'b11111111;
		#10;
		key_0 = 1'b1; opcode = 4'b0010; switchInput = 8'b11111111;
		#10;
		key_0 = 1'b0; opcode = 4'b0010; switchInput = 8'b11111111;
		#10;
		key_0 = 1'b1; opcode = 4'b0010; switchInput = 8'b11111111;
		#10;
		key_0 = 1'b0; opcode = 4'b0010; switchInput = 8'b11111111;
		#10;
		key_0 = 1'b1; opcode = 4'b0010; switchInput = 8'b11111111;
		#10;
		key_0 = 1'b0; opcode = 4'b0010; switchInput = 8'b11111111;
		#10;
		key_0 = 1'b1; opcode = 4'b1010; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b0; opcode = 4'b1010; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b1; opcode = 4'b1010; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b0; opcode = 4'b1010; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b1; opcode = 4'b1010; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b0; opcode = 4'b1010; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b1; opcode = 4'b1011; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b0; opcode = 4'b1011; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b1; opcode = 4'b1011; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b0; opcode = 4'b1011; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b1; opcode = 4'b1011; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b0; opcode = 4'b1011; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b1; opcode = 4'b0100; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b0; opcode = 4'b0100; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b1; opcode = 4'b0100; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b0; opcode = 4'b0100; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b1; opcode = 4'b0100; switchInput = 8'b00110110;
		#10;
		key_0 = 1'b0; opcode = 4'b0100; switchInput = 8'b00110110;
		#10;
	end
endmodule

// ---- ---- ---- ---- //

module Laboratory_2_Automatic_TB ();
	
	parameter CLOCK_HALF_PERIOD = 4; parameter RESET_PERIOD = 8; parameter DELAY = 10; parameter RUNTIME = 10000;
	logic key_0, clock, reset, cFlag, zFlag; logic [3:0] opcode; logic [6:0] ledDisplay1, ledDisplay2, ledDisplay3, ledDisplay4, ledDisplay5, ledDisplay6, ledDisplay7, ledDisplay8;
	logic [7:0] switchInput, DisplayValue_2, ABusIndication, BBusIndication, CBusIndication;
	logic key_0_text [0:39]; logic [3:0] opcode_text [0:39]; logic [7:0] switchInput_text [0:39]; logic [7:0] output_text [0:39]; logic c_flag_text [0:39]; logic z_flag_text [0:39];
	Laboratory_2 simulation (.key_0(key_0), .opcode(opcode), .switchInput(switchInput), .clock(clock), .reset(reset), .ledDisplay1(ledDisplay1), .ledDisplay2(ledDisplay2), .ledDisplay3(ledDisplay3), .ledDisplay4(ledDisplay4), .ledDisplay5(ledDisplay5), .ledDisplay6(ledDisplay6), .ledDisplay7(ledDisplay7), .ledDisplay8(ledDisplay8), .cFlag(cFlag), .zFlag(zFlag), .displayValue_2(DisplayValue_2), .aBusIndication(ABusIndication), .bBusIndication(BBusIndication), .cBusIndication(CBusIndication));
	
	always begin
		clock = 1'b0;
		#CLOCK_HALF_PERIOD;
		clock = 1'b1;
		#CLOCK_HALF_PERIOD;
	end
	initial begin
		reset = 1'b1;
		#RESET_PERIOD;
		reset = 1'b0;
	end
	initial begin
		$readmemb("key_0_text.txt", key_0_text); $readmemb("opcode_text.txt", opcode_text); $readmemb("switchInput_text.txt", switchInput_text);
		$readmemb("output_text.txt", output_text); $readmemb("c_flag_text.txt", c_flag_text); $readmemb("z_flag_text.txt", z_flag_text);
		#DELAY;
		for (int i = 0; i < 40; i++) begin
			key_0 = key_0_text[i]; opcode = opcode_text[i]; switchInput = switchInput_text[i];
			#DELAY;
			if (DisplayValue_2 != output_text[i] || cFlag != c_flag_text[i] || zFlag != z_flag_text[i]) begin
				$display ("ERROR at ", $time, "ns");
				$display ("Opcode = %b and SwitchInput = %b at Line [%d]", opcode, switchInput, i);
				$display ("Resulting Output = %b and Expected Output %b", DisplayValue_2, output_text[i]);
				$display ("Resulting C-Flag Logic Level = %b and Expected C-Flag Logic Level = %b", cFlag, c_flag_text[i]);
				$display ("Resulting Z-Flag Logic Level = %b and Expected Z-Flag Logic Level = %b", zFlag, z_flag_text[i]);
			end
			else begin
				$display ("Successful Simulation at ", $time, " ns! :)");
			end
		end
	end
	initial begin
		$display("At ", $time, " ns <<Initialising the Simulation>>");
		#RUNTIME;
		$stop;
	end
endmodule
