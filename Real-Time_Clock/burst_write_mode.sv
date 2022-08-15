module burst_write_mode (clk, rstn, write, ce, sclk, io);
	
	input clk, rstn, write;
	output logic ce, sclk, io;
	
	parameter IDLE = 4'b0001; parameter BURST_WRITE = 4'b0010; 
	parameter SEC_WRITE = 4'b0011; parameter MIN_WRITE = 4'b0100; parameter HOUR_WRITE = 4'b0101; parameter DATE_WRITE = 4'b0110;
	parameter MON_WRITE = 4'b0111; parameter DAY_WRITE = 4'b1000; parameter YEAR_WRITE = 4'b1001; parameter WP_WRITE = 4'b1010;
	parameter BURST_REG = 8'b10111110; parameter ADR_WR_SEC_DAT = 8'b01010010; parameter ADR_WR_MIN_DAT = 8'b01000011; parameter ZERO = 8'b00000000;
				 
	logic [3:0] state; logic [3:0] next_state;
	logic [1:0] cnt_4; logic [3:0] cnt_8;  
	logic [7:0] data; 
	   
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
				if (write == 1'b0)
					begin
					next_state = BURST_WRITE;
					end			
			BURST_WRITE: 
				if ((cnt_8 == 4'd7) && (cnt_4 == 2'd3))
					begin
					next_state = SEC_WRITE;
					end
			SEC_WRITE:
				if ((cnt_8 == 4'd7) && (cnt_4 == 2'd3))
					begin
					next_state = MIN_WRITE;	
					end
			MIN_WRITE:
				if ((cnt_8 == 4'd7) && (cnt_4 == 2'd3))
					begin
					next_state = HOUR_WRITE;
					end	
			HOUR_WRITE:
				if ((cnt_8 == 4'd7) && (cnt_4 == 2'd3))
					begin
					next_state = DATE_WRITE;
					end	
			DATE_WRITE:
				if ((cnt_8 == 4'd7) && (cnt_4 == 2'd3))
					begin
					next_state = MON_WRITE;
					end	
			MON_WRITE:
				if ((cnt_8 == 4'd7) && (cnt_4 == 2'd3))
					begin
					next_state = DAY_WRITE;
					end
			DAY_WRITE:
				if ((cnt_8 == 4'd7) && (cnt_4 == 2'd3))
					begin
					next_state = YEAR_WRITE;
					end
			YEAR_WRITE:
				if ((cnt_8 == 4'd7) && (cnt_4 == 2'd3))
					begin
					next_state = WP_WRITE;
					end
			WP_WRITE:
				if ((cnt_8 == 4'd7) && (cnt_4 == 2'd3))
					begin
					next_state = IDLE;
					end			

			default : next_state = IDLE;
		endcase
	end

	always_ff @(posedge clk or negedge rstn)
	begin
		if (rstn == 1'b0) 
			data <= 16'd0; 
		else if (state == IDLE && next_state == BURST_WRITE)
			data <= BURST_REG;
		else if (state == BURST_WRITE && next_state == SEC_WRITE)
			data <= ADR_WR_SEC_DAT;
		else if (state == SEC_WRITE && next_state == MIN_WRITE)
			data <= ADR_WR_MIN_DAT;
		else if (state == MIN_WRITE && next_state == HOUR_WRITE)
			data <= ZERO;
		else if (state == HOUR_WRITE && next_state == DATE_WRITE)
			data <= ZERO;
		else if (state == DATE_WRITE && next_state == MON_WRITE)
			data <= ZERO;
		else if (state == MON_WRITE && next_state == DAY_WRITE)
			data <= ZERO;
		else if (state == DAY_WRITE && next_state == YEAR_WRITE)
			data <= ZERO;
		else if (state == YEAR_WRITE && next_state == WP_WRITE)
			data <= ZERO;
		else if (state == WP_WRITE && next_state == IDLE)
			data <= ZERO;
		else if (cnt_4 == 2'd3)
			data <= {1'b0, data[7:1]};
	end
	
	assign io = data[0];

	always_ff @(posedge clk or negedge rstn)
	begin
		if (rstn == 1'b0) 
			sclk <= 1'b0; 
		else  if (cnt_4[0])
			sclk <= ~sclk;
	end

	assign ce = (state != IDLE);

	always_ff @(posedge clk or negedge rstn)
	begin
		if (rstn == 1'b0) 
			cnt_4 <= 2'b0; 
		else if (ce == 1'd1) 
			cnt_4 <= cnt_4 + 2'b1; 
	end

	always_ff @(posedge clk or negedge rstn)
	begin
		if (rstn == 1'b0) 
			cnt_8 <= 4'b0; 
		else if (cnt_4 == 2'd3) 
		begin 
			cnt_8 <= cnt_8 + 4'b1; 
			if ((cnt_8 == 4'd7)) 
				cnt_8 <= 4'b0; 
		end
	end

endmodule

// ---- ---- ---- ---- //

`timescale 1ns/ 1ps

module burst_write_mode_test_bench;

	logic clk, rstn, write, ce, sclk, io;
	
	burst_write_mode simulation(.clk(clk), .rstn(rstn), .write(write), .ce(ce), .sclk(sclk), .io(io));
	
	initial 
	begin
		clk = 1'b0; 
		rstn = 1'b0; 
		write = 1'b1; 
		#10;
		rstn = 1'b1; 
		#100; 
		write = 1'b0; 
		#50; 
		write = 1'b1;
		#7500;
 		write = 1'b0; 
		#50; 
		write = 1'b1;
	end

	always #10 clk = ~clk;

endmodule


