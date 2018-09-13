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
		TRANSMIT = 1
	} state_t;
	state_t state, next_state;

	// Timer
	reg[3:0] count; wire timer_done;
	reg start;
	always_ff @(posedge baud, negedge rst_n, start) begin
		if (!rst_n | start)
			 count <= 4'h8;
		else if (count == 4'h0)
			 count <= 4'h8;
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
	always@(*) begin
		start = 0;
		fifo_read = 0;
		if(baud) begin
			case(state)
				// wait to begin serially transmitting
				IDLE: begin
					if(~t_buffer_empty) begin
						next_state = TRANSMIT;
						start = 1'b1;
						fifo_read = 1'b1;
					end
					else
						next_state = IDLE;
				end
				// transmit the data out
				TRANSMIT: begin
					if(~timer_done) 
						next_state = TRANSMIT;
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
	reg[7:0] hold;
	
	always@(posedge clk, negedge rst_n)begin
		if(~rst_n)
			hold <= 8'h00;
		else if (baud) begin
			if(start)
				hold <= fifo_out;
			else
				hold <= {1'b0, hold[7:1]};
		end
	end
	
	assign txd = hold[0];

endmodule
	
