module fsm_stopwatch (start_stop, lap_reset, reset, clock_10, clock_50M, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7);
	
	input start_stop, lap_reset, reset, clock_10, clock_50M;
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;
	
	logic [1:0] current_state, next_state; 
	logic [3:0] timer_0, timer_1, timer_2, timer_3, lap_0, lap_1, lap_2, lap_3; 
	
	parameter RESET = 2'b00; parameter TIMER_START = 2'b01; parameter TIMER_STOP = 2'b10; parameter LAP = 2'b11; 

	always_ff @ (posedge clock_50M)
	begin
		if (!reset)
			current_state <= RESET;
		else
			current_state <= next_state;
	end

	always_ff @ (posedge clock_10)
	begin
		case (current_state)
		RESET : begin
			timer_0 <= 4'd0; timer_1 <= 4'd0; timer_2 <= 4'd0; timer_3 <= 4'd0;
			lap_0 <= 4'd0; lap_1 <= 4'd0; lap_2 <= 4'd0; lap_3 <= 4'd0;
			if (!start_stop)
				next_state <= TIMER_START;
			else if (start_stop)
				next_state <= RESET;
		end

		TIMER_START : begin
			if (timer_0 == 4'd9)
			begin
				timer_0 <= 4'd0;
				if (timer_1 == 4'd9)
				begin
					timer_1 <= 4'd0;
					if (timer_2 == 4'd5)
					begin
						timer_2 <= 4'd0;
						if (timer_3 == 4'd9)
							timer_3 <= 4'd0;
						else
							timer_3 <= timer_3 + 4'd1;
					end
					else
						timer_2 <= timer_2 + 4'd1;
				end
				else
					timer_1 <= timer_1 + 4'd1;
			end
			else
				timer_0 <= timer_0 + 4'd1;
			if (!start_stop)
				next_state <= TIMER_STOP;
			else if (!lap_reset)
				next_state <= LAP;
			else if (start_stop || lap_reset)
				next_state <= TIMER_START;
		end

		TIMER_STOP : begin
			if (!start_stop)
				next_state <= TIMER_START;
			else if (!lap_reset)
				next_state <= RESET;
			else
				next_state <= TIMER_STOP;
		end

		LAP : begin
			lap_0 <= timer_0; lap_1 <= timer_1;	lap_2 <= timer_2;	lap_3 <= timer_3;
			next_state <= TIMER_START;
		end

		default : begin
			next_state <= current_state;
			timer_0 <= 4'd0; timer_1 <= 4'd0; timer_2 <= 4'd0;	timer_3 <= 4'd0;
		end
		endcase
	end
	
	char7seg digit_0 (.value (timer_0), .char7seg_out (HEX0));
	char7seg digit_1 (.value (timer_1), .char7seg_out (HEX1));
	char7seg digit_2 (.value (timer_2), .char7seg_out (HEX2));
	char7seg digit_3 (.value (timer_3), .char7seg_out (HEX3));
	char7seg digit_4 (.value (lap_0), .char7seg_out (HEX4));
	char7seg digit_5 (.value (lap_1), .char7seg_out (HEX5));
	char7seg digit_6 (.value (lap_2), .char7seg_out (HEX6));
	char7seg digit_7 (.value (lap_3), .char7seg_out (HEX7));

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
