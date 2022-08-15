module controller (rstn, clk, read, write, write_trig, read_trig);
	
	input rstn, clk, read, write;
	output logic write_trig, read_trig;
	
	logic [1:0] current_state, next_state;
	
	parameter RESET = 2'b00; parameter IDLE = 2'b01; parameter WRITE = 2'b10; parameter READ = 2'b11;
	
	always_ff @ (posedge clk)
	begin
		if (!rstn)
			current_state <= IDLE;
		else 
			current_state <= next_state;
	end
	
	always_ff @ (posedge clk)
	begin
		case (current_state)
			RESET : begin
				write_trig = 1'b1;
				read_trig = 1'b1;
				if (!write)
					next_state <= WRITE;
				else
					next_state <= IDLE;
			end
			
			WRITE : begin
				write_trig <= 1'b0;
				read_trig <= 1'b1;
				if (!rstn)
					next_state <= RESET;
				else if (!read)
					next_state <= READ;
				else
					next_state <= WRITE;
			end
			
			READ : begin
				write_trig <= 1'b1;
				read_trig <= 1'b0;
				if (!rstn)
					next_state <= RESET;
				else if (!write)
					next_state <= WRITE;
				else
					next_state <= READ;
			end
			
			IDLE : begin
				write_trig <= 1'b1;
				read_trig <= 1'b1;
				if (!rstn)
					next_state <= RESET;
				else if (!write)
					next_state <= WRITE;
				else if (!read)
					next_state <= READ;
				else 
					next_state <= IDLE;
			end
		
		endcase
	end

endmodule

// ---- ---- ---- ---- //

`timescale 1ns/ 1ps

module controller_tb;
	
	logic rstn, clk, read, write;
	logic write_trig, read_trig;
	
	controller simulation(.rstn(rstn), .clk(clk), .read(read), .write(write), .write_trig(write_trig), .read_trig(read_trig));
	
	always #10 clk = ~clk;
	initial begin
		clk = 1'b0; rstn = 1'b0; read = 1'b1; write = 1'b1;
		#20 rstn = 1'b1;
		#10 write = 1'b0;
		#20 write = 1'b1;
		#10 read = 1'b0;
		#20 read = 1'b1;
	end
	
endmodule
