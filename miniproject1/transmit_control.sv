module transmit_control(
	input clk,
	input rst_n,
	input baud,
	input [1:0] ioaddr,
	input fifo_write,
	output txd,
	output tbr,
	input [7:0] bus_out
	);
	reg r_ready;
	reg [7:0] rbuffer;

	// state machine
	typedef enum{
		IDLE = 0,
		LOAD1 = 1,
		LOAD2 = 2,
		TRANSMIT = 3
	} state_t;
	state_t state, next_state;

	// Timer
	reg[3:0] count; wire timer_done;
	reg start, set_timer;
	always_ff @(posedge baud, negedge rst_n, set_timer) begin
		if (!rst_n | set_timer)
			 count <= 4'ha;
		else if (count == 4'h0)
			 count <= 4'ha;
		else 
			count <= count - 1'b1;
	end
	assign timer_done = (count == 0);
	// FIFO INSTANTIATION FOR TRANSMIT BUFFER //
	reg fifo_read;
	wire t_buffer_empty, t_buffer_full;
	wire[7:0] fifo_out;
	fifo transmit_buffer(.dataIn(bus_out), .dataOut(fifo_out), .empty(t_buffer_empty), .full(t_buffer_full), .read(fifo_read), .write(fifo_write), .clk(clk), .rst_n(rst_n));

	// SHIFT REGISTER //
	wire[7:0] r_shift_out;
	transmit_shift shift(.clk(clk), .rst_n(rst_n), .baud(baud), .start(start), .txd(txd), .fifo_out(fifo_out));

	always@(posedge clk, negedge rst_n) begin
		if(!rst_n)
			state <= IDLE;
		else
			state <= next_state;
	end

	// NEXT STATE LOGIC //
/*	always@(*) begin
		start = 0;
		fifo_read = 0;
		if(baud) begin
			case(state)
				// wait to begin serially transmitting
				IDLE: begin
					fifo_read = 1;
					if(~t_buffer_empty) begin
						next_state = LOAD1;
						//start = 1'b1;
					end
					else
						next_state = IDLE;
				end
				LOAD1: begin
					next_state = LOAD2;
					start = 1'b1;
				end
				LOAD2: begin
					next_state = TRANSMIT;
				end
				TRANSMIT: begin
					if(~timer_done) 
						next_state = TRANSMIT;
					else
						next_state = IDLE;
				end
			endcase
		end
	end
*/

	always@(*) begin
		if(baud) begin
			fifo_read = 0;
			start = 0;
			set_timer = 0;
			case (state)
				IDLE: begin
					if(~t_buffer_empty) begin
						next_state = LOAD1;
						fifo_read = 1;
					end
					else
						next_state = IDLE;
				end
				LOAD1: begin
					next_state = LOAD2;
					start = 1;
				end
				LOAD2: begin
					next_state = TRANSMIT;
					set_timer = 1;
				end
				TRANSMIT: begin
					if(~timer_done)
						next_state= TRANSMIT;
					else
						next_state = IDLE;
				end
			endcase
		end
	end

	assign tbr = ~t_buffer_empty;

endmodule


module transmit_shift(
	input clk,
	input rst_n,
	input baud,
	input start,
	input[7:0] fifo_out,
	output txd
	);
	reg[9:0] hold;
	
	always@(posedge clk, negedge rst_n)begin
		if(~rst_n)
			hold <= 10'd0;
		else if(baud) begin
			if(start)
				hold <= {1'b1, fifo_out, 1'b0};

			else
				hold <= {{1'b0}, {hold[9:1]}};
		end
	end
	assign txd = hold[0];

endmodule
	
