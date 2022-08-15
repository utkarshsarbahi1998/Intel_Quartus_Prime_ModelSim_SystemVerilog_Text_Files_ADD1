module SevenSegment (DisplayValue, LEDDisplay1, LEDDisplay2, LEDDisplay3, LEDDisplay4, LEDDisplay5, LEDDisplay6, LEDDisplay7, LEDDisplay8, DisplayValue_2);

	input [7:0] DisplayValue;
	output logic [6:0] LEDDisplay1, LEDDisplay2, LEDDisplay3, LEDDisplay4, LEDDisplay5, LEDDisplay6, LEDDisplay7, LEDDisplay8; 
	output logic [7:0] DisplayValue_2;

	logic [55:0] led_dp;

	always_comb begin
		DisplayValue_2 = DisplayValue;
		for (int i = 0; i < 8; i++) begin
			if (DisplayValue[i] == 1'b1) led_dp[(7*i) +: 7] = 7'b1111001;
			else led_dp[(7*i) +: 7] = 7'b1000000;
		end
		{LEDDisplay1, LEDDisplay2, LEDDisplay3, LEDDisplay4, LEDDisplay5, LEDDisplay6, LEDDisplay7, LEDDisplay8} = led_dp;
	end 
endmodule

// ---- ---- ---- ---- //

`timescale 1ns / 1ps

module SevenSegment_TB ();
	
	logic [6:0] ledDisplay1, ledDisplay2, ledDisplay3, ledDisplay4, ledDisplay5, ledDisplay6, ledDisplay7, ledDisplay8; logic [7:0] displayValue;
	SevenSegment simulation(.DisplayValue(displayValue), .LEDDisplay1(ledDisplay1), .LEDDisplay2(ledDisplay2), .LEDDisplay3(ledDisplay3), .LEDDisplay4(ledDisplay4), .LEDDisplay5(ledDisplay5), .LEDDisplay6(ledDisplay6), .LEDDisplay7(ledDisplay7), .LEDDisplay8(ledDisplay8));
	
	initial begin
		displayValue = 8'b11111111;
		#10;
		displayValue = 8'b00000000;
		#10;
		displayValue = 8'b10101010;
		#10;
		displayValue = 8'b01010101;
		#10;
	end
endmodule
