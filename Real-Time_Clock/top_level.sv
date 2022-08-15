module top_level (rstn, read, write, clk, ce, io, sclk, HEX0, HEX1, HEX2, HEX3, switches);
	
	input rstn, read, write, clk;
	input [15:0] switches;
	output logic ce, sclk;
	output logic [6:0] HEX0, HEX1, HEX2, HEX3;
	
	inout io;
	
	logic write_trig, read_trig, clock, sclk_2, sclk_3, ce_2, ce_3;
	logic [3:0] data_sec_0, data_sec_1, data_min_0, data_min_1;
	logic [3:0] digit_second_0, digit_second_1, digit_minute_0, digit_minute_1;
	wire io_2, io_3;
	logic [7:0] SAVE;
	logic [1:0] cnt_4;
	logic [3:0] cnt_8;

	clockdiv instant1 (.iclk(clk), .oclk(clock));
	initial_time instant2 (.switches(switches), .digit_second_0(data_sec_0), .digit_second_1(data_sec_1), .digit_minute_0(data_min_0), .digit_minute_1(data_min_1));
	controller instant3 (.rstn(rstn), .clk(clock), .read(read), .write(write), .write_trig(write_trig), .read_trig(read_trig));
	asm_write instant4 (.clk(clock), .rstn(rstn), .write(write_trig), .ce(ce_2), .io(io_2), .sclk(sclk_2), .data_sec_0(data_sec_0), .data_sec_1(data_sec_1), .data_min_0(data_min_0), .data_min_1(data_min_1));
	asm_read instant5 (.clk(clock), .rst_n(rstn), .key(read_trig), .CE(ce_3), .IO(io_3), .SCK(sclk_3), .HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2), .HEX3(HEX3), .SAVE(SAVE), .cnt_4(cnt_4), .cnt_8(cnt_8));
			
	assign sclk = write_trig ? sclk_3 : sclk_2;
	assign ce = write_trig ? ce_3 : ce_2;
	assign io = write_trig ? io_3 : io_2;
	
endmodule

// ---- ---- ---- ---- //

`timescale 1ns/ 1ps

module top_level_tb;

	logic rstn, read, write, clk;
	logic [15:0] switches;
	wire ce, sclk;
	wire io;
	logic [6:0] HEX0, HEX1, HEX2, HEX3;

	top_level top_level_inst(.rstn(rstn), .read(read), .write(write), .clk(clk), .ce(ce), .io(io), .sclk(sclk), .HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2), .HEX3(HEX3), .switches(switches));

	always #10 clk = ~clk;
		
	initial begin 
		clk = 1'b1; rstn = 1'b0; write = 1'b1; read = 1'b1; switches = 16'b1010010111110000;
		#10;
		rstn =1'b1;
		#10;
		write = 1'b1;
		#1000;
		write = 1'b0;
		#1000;
		write = 1'b1;
		#200000;
		read = 1'b1;
		#1000;
		read = 1'b0;
		#1000;
		read = 1'b1;
	end

endmodule
