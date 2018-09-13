module transmit_control(
	input clk,
	input rst_n,
	input baud,
	input [1:0] ioaddr,
	output txd,
	output tbr,
	output [7:0] out_bus
	);
	reg r_ready;
	reg [7:0] rbuffer;

	// state machine
	typedef enum{
		IDLE = 0,
		TRANSMIT = 1
	} state_t;
	state_t state, next_state;

	wire stop, start;
	
	always@(*) begin
		if(!rst_n)
			state <= IDLE;
		else
			state <= next_state;
	end

	// NEXT STATE LOGIC //
	always@(*) begin
		if(baud) begin
			case(state)
				// wait to begin serially transmitting
				IDLE: begin
					if(start)
						next_state = TRANSMIT;
					else
						next_state = IDLE;
				end
				// transmit the data out
				TRANSMIT: begin
					if(start) 
						next_state = TRANSMIT;
					else
						next_state = IDLE;
				end
			endcase
		end
	end

	// FIFO INSTANTIATION FOR TRANSMIT BUFFER //
	wire t_buffer_empty, t_buffer_full;
	wire[7:0] fifo_out;
	fifo transmit_buffer(.dataIn(out_bus), .dataOut(fifo_out), .empty(t_buffer_empty), .full(t_buffer_full), .read(), .write(), .clk(clk), .rst_n(rst_n));

	// SHIFT REGISTER //
	wire[7:0] r_shift_out;
	transmit_register shift(.rst_n(rst_n), .baud(baud), .start(start), .stop(stop), .txd(txd), .fifo_out(fifo_out));
	
	assign tbr = state;

endmodule

module timer(
	input baud,
	input reset,
	output timer_done
	);
	reg[3:0] count;

	always@(baud)begin
		if(reset | count == -1)
			count <= 4'h7;
		else
			count <= count - 1;
	end

	assign timer_done = (count == 4'h0);

endmodule

module transmit_shift(
	input rst_n,
	input baud,
	input start,
	input stop,
	input[7:0] fifo_out,
	output txd
	);
	reg[7:0] hold;
	
	always@(*)begin
		if(!rst_n)
			hold <= 8'h00;
		else if(start)
			hold <= fifo_out;
		else
			hold <= {1'b0, hold[7:1]};
	end
	
	assign txd = hold[0];

endmodule
	
