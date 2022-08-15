module asm_write (clk, rstn, write, ce, sclk, io, data_sec_0, data_sec_1, data_min_0, data_min_1);
	
	input clk, rstn, write;
	input [3:0] data_sec_0, data_sec_1, data_min_0, data_min_1;
	
	output logic ce, sclk, io;
	
	parameter IDLE = 3'b001; parameter SINGLE_WRITE = 3'b010; parameter SECOND_WRITE = 3'b011; parameter MINUTE_WRITE = 3'b100;
	parameter ADR_WR_CREG = 8'b10001110;
	parameter WP = 8'b00000000;
	
	logic [7:0] sec_dat; 
	logic [7:0] min_dat; 

	assign sec_dat = {data_sec_1, data_sec_0};
	assign min_dat = {data_min_1, data_min_0};

	parameter ADR_WR_SEC_COM = 8'b10000001;
	parameter ADR_WR_MIN_COM = 8'b10000010;
						 
	logic [2:0] state; logic [2:0] next_state;
 
	logic [1:0] cnt_4;
	logic [3:0] cnt_8;    
	logic [15:0] data;
	logic [1:0] flag = 2'b00;
              
	always_ff @(posedge clk or negedge rstn)
	begin
		if (!rstn) 
			state <= IDLE;
		else  
			state <= next_state;
	end
	
	always_latch
	begin
		case (state)
			IDLE:
				if (write == 1'b0 && flag == 2'b10)
					next_state = MINUTE_WRITE;
				else if (write == 1'b0 && flag == 2'b01)
					next_state = SECOND_WRITE;	
				else if (write == 1'b0 && flag != 2'b11)
					next_state = SINGLE_WRITE;
								
			SINGLE_WRITE: 
				if ((cnt_8 == 4'd15) && (cnt_4 == 2'd3))
				begin
					flag = 2'b01;
					next_state = IDLE;
				end
			SECOND_WRITE:
				if ((cnt_8 == 4'd15) && (cnt_4 == 2'd3))
				begin
					flag = 2'b10;
					next_state = IDLE;	
				end
			MINUTE_WRITE:
				if ((cnt_8 == 4'd15) && (cnt_4 == 2'd3))
				begin
					flag = 2'b11;
					next_state = IDLE;	
				end			

			default : next_state = IDLE;
		endcase
	end

	always_ff @(posedge clk or negedge rstn)
	begin
		if (rstn == 1'b0) 
			data <= 16'd0; 
		else if (state == IDLE && next_state == SINGLE_WRITE)
			data <= {WP, ADR_WR_CREG};
		else if (state == IDLE && next_state == SECOND_WRITE)
			data <= {sec_dat, ADR_WR_SEC_COM};
		else if (state == IDLE && next_state == MINUTE_WRITE)
			data <= {min_dat, ADR_WR_MIN_COM};
		else if (cnt_4 == 2'd3)
			data <= {1'b0, data[15:1]};
	end
	
	assign io = data[0];

	always_ff @(posedge clk or negedge rstn)
	begin
		if (rstn == 1'b0) 
			sclk <= 1'b0; 
		else if (cnt_4[0])
			sclk <= ~sclk;
	end

	assign ce = (state != (IDLE));

	always_ff @(posedge clk or negedge rstn)
	begin
		if (rstn == 1'b0) 
			cnt_4 <= 2'b0; 
		else  if (ce == 1'd1) 
			cnt_4 <= cnt_4 + 2'b1; 
	end

	always_ff @(posedge clk or negedge rstn)
	begin
		if (rstn == 1'b0) 
			cnt_8 <= 4'b0; 
		else if (cnt_4 == 2'd3) 
		begin 
			cnt_8 <= cnt_8+ 1'b1; 
			if ((cnt_8 == 4'd15)) 
				cnt_8 <= 4'b0; 
		end
	end

endmodule

// ---- ---- ---- ---- //

`timescale 1ns/ 1ps

module asm_write_tb;

	logic clk;
	logic rstn;
	logic write;
	logic [3:0] data_sec_0, data_sec_1, data_min_0, data_min_1;

	wire ce;
	wire sclk;
	wire io;
	
	asm_write simulation(.clk(clk), .write(write), .rstn(rstn), .ce(ce), .sclk(sclk), .io(io), .data_sec_0(data_sec_0), .data_sec_1(data_sec_1), .data_min_0(data_min_0), .data_min_1(data_min_1));
	
	initial begin
		clk = 1'b0; rstn = 1'b0; data_sec_0 = 3'd2; data_sec_1 = 3'd1; data_min_0 = 3'd3; data_min_1 = 3'd2; 
		write = 1'b1; 
		#10;
		rstn = 1'b1; 
		#10;
		write = 1'b0; 
		#20;
		write = 1'b1;
	end

	always #10 clk = ~clk;

endmodule

