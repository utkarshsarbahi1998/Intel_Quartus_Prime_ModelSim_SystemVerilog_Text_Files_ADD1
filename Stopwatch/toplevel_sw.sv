module toplevel_sw (start_stop, lap_reset, clk, rstn, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7);
	
	input start_stop, lap_reset, clk, rstn;
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;
	logic clk_10;
	
	clockdiv_10Hz instant1 (.iclk(clk), .oclk(clk_10));
	fsm_stopwatch instant2 (.start_stop(start_stop), .lap_reset(lap_reset), .reset(rstn), .clock_10(clk_10), .clock_50M(clk), .HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2), .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5), .HEX6(HEX6), .HEX7(HEX7));

endmodule

// ---- ---- ---- ---- //

`timescale 1ns / 1ps

module toplevel_sw_tb;
	
	logic start_stop, lap_reset, clk, rstn;
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;
	
	toplevel_sw dut (.start_stop(start_stop), .lap_reset(lap_reset), .clk(clk), .rstn(rstn), .HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2), .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5), .HEX6(HEX6), .HEX7(HEX7));
	
	always #5 clk = ~clk;
	
	initial begin
		clk = 1'b1; rstn = 1'b0; start_stop = 1'b1; lap_reset = 1'b1;
		#20 rstn = 1'b0; start_stop = 1'b0; lap_reset = 1'b1;
		#20 rstn = 1'b0; start_stop = 1'b1; lap_reset = 1'b0;
		#20 rstn = 1'b1; start_stop = 1'b0; lap_reset = 1'b1;
		#20 start_stop = 1'b1;
		#20 rstn = 1'b1; start_stop = 1'b0; lap_reset = 1'b1;
		#20 start_stop = 1'b1;
		#20 rstn = 1'b1; start_stop = 1'b0; lap_reset = 1'b1;
		#20 start_stop = 1'b1;
		#20 rstn = 1'b1; start_stop = 1'b1; lap_reset = 1'b0;
		#20 lap_reset = 1'b1;
		#20 rstn = 1'b1; start_stop = 1'b0; lap_reset = 1'b1;
		#20 start_stop = 1'b1;
		#20 rstn = 1'b1; start_stop = 1'b1; lap_reset = 1'b0;
		#20 lap_reset = 1'b1;
	end
	
endmodule 

// ---- ---- ---- ---- //

`timescale 1ns / 1ps

module toplevel_sw_autotb;
	
	logic start_stop, lap_reset, clk, rstn;
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;
	logic start_stop_text [0:29]; logic lap_reset_text [0:29]; logic rstn_text [0:29];
	logic [6:0] HEX0_text [0:29]; logic [6:0] HEX1_text [0:29]; logic [6:0] HEX2_text [0:29]; logic [6:0] HEX3_text [0:29]; logic [6:0] HEX4_text [0:29]; logic [6:0] HEX5_text [0:29]; logic [6:0] HEX6_text [0:29]; logic [6:0] HEX7_text [0:29]; 
	
	toplevel_sw simulation (.start_stop(start_stop), .lap_reset(lap_reset), .clk(clk), .rstn(rstn), .HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2), .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5), .HEX6(HEX6), .HEX7(HEX7));
	
	always #5 clk = ~clk;
	
	initial begin
		clk = 1'b1;
		$readmemb("start_stop.txt", start_stop_text); 
		$readmemb("lap_reset.txt", lap_reset_text); 
		$readmemb("rstn.txt", rstn_text);
		$readmemb("HEX0.txt", HEX0_text); 
		$readmemb("HEX1.txt", HEX1_text); 
		$readmemb("HEX2.txt", HEX2_text);
		$readmemb("HEX3.txt", HEX3_text);
		$readmemb("HEX4.txt", HEX4_text);
		$readmemb("HEX5.txt", HEX5_text);
		$readmemb("HEX6.txt", HEX6_text);
		$readmemb("HEX7.txt", HEX7_text);
		
		for (int i = 0; i < 30; i++) begin
			start_stop = start_stop_text[i]; lap_reset = lap_reset_text[i]; rstn = rstn_text[i];
			#10;
			if (HEX0 != HEX0_text[i] || HEX1 != HEX1_text[i] || HEX2 != HEX2_text[i] || HEX3 != HEX3_text[i] || HEX4 != HEX4_text[i] || HEX5 != HEX5_text[i] || HEX6 != HEX6_text[i] || HEX7 != HEX7_text[i]) 
			begin
				$display ("ERROR at ", $time, "ns");
				$display ("Start_stop = %b, Lap_reset = %b and Rstn = %b at Line [%d]", start_stop, lap_reset, rstn, i);
				$display ("Resulting HEX0 = %b and Expected HEX0 %b", HEX0, HEX0_text[i]);
				$display ("Resulting HEX1 = %b and Expected HEX1 %b", HEX1, HEX1_text[i]);
				$display ("Resulting HEX2 = %b and Expected HEX2 %b", HEX2, HEX2_text[i]);
				$display ("Resulting HEX3 = %b and Expected HEX3 %b", HEX3, HEX3_text[i]);
				$display ("Resulting HEX4 = %b and Expected HEX4 %b", HEX4, HEX4_text[i]);
				$display ("Resulting HEX5 = %b and Expected HEX5 %b", HEX5, HEX5_text[i]);
				$display ("Resulting HEX6 = %b and Expected HEX6 %b", HEX6, HEX6_text[i]);
				$display ("Resulting HEX7 = %b and Expected HEX7 %b", HEX7, HEX7_text[i]);
			end
			else begin
				$display ("Successful Simulation at ", $time, " ns! :)");
			end
		end
	end
	
endmodule
