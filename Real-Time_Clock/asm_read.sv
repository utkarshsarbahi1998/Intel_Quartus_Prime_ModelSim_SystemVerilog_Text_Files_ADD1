module asm_read (clk, rst_n, key, CE, SCK, IO, HEX0, HEX1, HEX2, HEX3, SAVE, cnt_4, cnt_8);

	input clk;
	input rst_n;
	input key;

	output logic CE;
	output logic SCK;
	output logic [7:0] SAVE;
	output logic [1:0] cnt_4;
	output logic [3:0] cnt_8;
	inout IO;
	
	output logic [6:0] HEX0, HEX1, HEX2, HEX3;
	
	parameter IDLE = 3'b001; parameter COM_BYTE = 3'b010; parameter READ_BYTE = 3'b011; parameter COM_MIN_BYTE = 3'b100; parameter READ_MIN_BYTE = 3'b101;
	parameter ADR_RM_SEC = 8'b10000001;
	parameter ADR_RM_MIN = 8'b10000011;
			 
	logic [7:0] temp_read, temp_read_min;
	logic [2:0] state;
	logic [2:0] next_state;

	logic [7:0] data;
	logic [1:0] flag = 2'b00;
 
	logic io_control;
               
	always_ff @(posedge clk or negedge rst_n)
	begin
	if(rst_n == 1'b0)
		 state <= IDLE;
	else 
		 state <= next_state;
	end

	always_latch
	begin
	case (state)
		IDLE:
			if (key == 1'b0 && flag == 2'b01)
			begin
				next_state = COM_MIN_BYTE;
			end
			else if (key == 1'b0 && flag != 2'b11)
			begin
				next_state = COM_BYTE;
			end
		COM_BYTE: 
			if((cnt_8 == 4'd7) && (cnt_4 == 2'd2))
			begin
				next_state = READ_BYTE;
			end
		READ_BYTE:
			if((cnt_8 == 4'd7) && (cnt_4 == 2'd2))
			begin
				flag = 2'b01;
				temp_read = bitOrder(SAVE);
				next_state = IDLE;
			end
		COM_MIN_BYTE:    
			if((cnt_8 == 4'd7) && (cnt_4 == 2'd3))
			begin
				next_state = READ_MIN_BYTE;
			end
		READ_MIN_BYTE:
			if((cnt_8 == 4'd7) && (cnt_4 == 2'd3))
			begin
				flag = 2'b11;
				temp_read_min = bitOrder(SAVE);
				next_state = IDLE;
			end
		default : next_state = IDLE;
	
	endcase
	end

	always_ff @(posedge clk or negedge rst_n)
	begin
		if (rst_n == 1'b0)
			 data <= 8'd0;
		else if (state == IDLE && next_state == COM_BYTE)
			 data <= ADR_RM_SEC;
		else if (state == IDLE && next_state == COM_MIN_BYTE)
			 data <= ADR_RM_MIN;
		else if ((cnt_4 == 2'd2 && state == COM_BYTE) || (cnt_4 == 2'd2 && state == COM_MIN_BYTE))
			 data <= {1'b0, data[7:1]};
		else if ((cnt_4 == 2'd2 && state == READ_BYTE) || (cnt_4 == 2'd2 && state == READ_MIN_BYTE))
			 data <= {IO, data[7:1]};	
	end

	assign SAVE = data;

	always_ff @(posedge clk or negedge rst_n)
	begin
		if(rst_n == 1'b0)
			io_control <= 1'b0;
		else if (state == (COM_BYTE))
			io_control <= 1'b1;
		else if (state == (COM_MIN_BYTE))
			io_control <= 1'b1;
		else  
			io_control <= 1'b0; 
	end

	assign IO = io_control ? data[0] : 1'bz;

	always_ff @(posedge clk or negedge rst_n)
	begin
		if(rst_n == 1'b0)
			SCK <= 1'b0;
		else if(cnt_4[0])
			SCK <= ~SCK;
	end

	assign CE = (state != IDLE);

	always_ff @(posedge clk or negedge rst_n)
	begin
		if (rst_n == 1'b0) 
			cnt_4 <= 2'b0; 
		else if (CE == 1'd1)
			cnt_4 <= cnt_4 + 2'b1;
	end

	always_ff @(posedge clk or negedge rst_n)
	begin
		if (rst_n == 1'b0) 
			 cnt_8 <= 4'b0; 
		else if (cnt_4 == 2'd3) 
		begin
			cnt_8 <= cnt_8 + 4'd1; 
			if ((cnt_8 == 4'd7)) 
				cnt_8 <= 4'd0; 
		end
	end
	
	char7seg digit_0 (.value (temp_read[3:0]), .char7seg_out (HEX0));
	char7seg digit_1 (.value (temp_read[7:4]), .char7seg_out (HEX1));
	char7seg digit_2 (.value (temp_read_min[3:0]), .char7seg_out (HEX2));
	char7seg digit_3 (.value (temp_read_min[7:4]), .char7seg_out (HEX3));

	//Function for reversing the number of bits in a parallel bus.
	function [8-1:0] bitOrder(
		input [8-1:0] data);
		integer i;
		begin
			 for (i=0; i < 8; i=i+1) begin : reverse
				  bitOrder[8-1-i] = data[i];
			 end
		end
	endfunction
	
endmodule

module char7seg (value, char7seg_out);

	input [3:0] value;
	output logic [6:0] char7seg_out;

	always_comb begin
		case (value)
		4'd0: char7seg_out = 7'b1000000;
		4'd1: char7seg_out = 7'b1111001;
		4'd2: char7seg_out = 7'b0100100;
		4'd3: char7seg_out = 7'b0110000;
		4'd4: char7seg_out = 7'b0011001;
		4'd5: char7seg_out = 7'b0010010;
		4'd6: char7seg_out = 7'b0000010;
		4'd7: char7seg_out = 7'b1111000;
		4'd8: char7seg_out = 7'b0000000;
		4'd9: char7seg_out = 7'b0010000;
		default: char7seg_out = 7'b1111111;
		endcase
	end
endmodule

// ---- ---- ---- ---- //

`timescale 1ns/ 1ps

module asm_read_tb;

	logic clk;
	logic rst_n;
	logic key;

	logic CE;
	logic SCK;
	wire IO;
	logic [7:0] SAVE;
	logic [1:0] cnt_4;
	logic [3:0] cnt_8;
	logic [6:0] HEX0, HEX1, HEX2, HEX3;
	
	asm_read asm_read_inst(.clk(clk), .rst_n(rst_n), .key(key), .CE(CE), .SCK(SCK), .SAVE(SAVE), .IO(IO), .cnt_4(cnt_4), .cnt_8(cnt_8), .HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2), .HEX3(HEX3));
	
	always #10 clk = ~clk;
	
	initial begin 
		clk = 1'b1; rst_n = 1'b0; key = 1'b1;
		#10;
		rst_n =1'b1;
		#10;
		key = 1'b0;
		#20;
		key = 1'b1;
		#2600;
		key = 1'b0;
		#20;
		key = 1'b1;
		//wait (asm_clock3_inst.state == asm_clock3_inst.READ_BYTE)
		//force IO = 1'b0;
		//@ (negedge SCK)
		//force IO = 1'b0;
		//@ (negedge SCK)
		//force IO = 1'b1;
		//@ (negedge SCK)
		//force IO = 1'b0;
		//@ (negedge SCK)
		//force IO = 1'b1;
		//wait (asm_clock3_inst.state == asm_clock3_inst.READ_MIN_BYTE)
		//force IO = 1'b0;
		//@ (negedge SCK)
		//force IO = 1'b0;
		//@ (negedge SCK)
		//force IO = 1'b1;
		//@ (negedge SCK)
		//force IO = 1'b0;
		//@ (negedge SCK)
		//force IO = 1'b1;
	end

endmodule
