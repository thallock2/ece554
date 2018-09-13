module receive_control(
	input clk,
	input rst_n,
	input baud,
	input [1:0] ioaddr,
	input rxd,
	output rda,
	output [7:0] bus_in
	);
	reg r_ready;
	reg [7:0] rbuffer;

	// STATE MACHINE //
	typedef enum{
		FILL = 0,
		RECEIVE = 1
	}state_t;
	state_t state, next_state;	
	
	// timer for state machine
	//wire timer_done;
	//timer timer(.rst(~rst_n), .baud(baud), .rxd(rxd), .timer_done(timer_done));

	// Timer
	reg count;
	always_ff @(posedge baud, negedge rst_n) begin
		if (!rst_n) count <= 4'hA;
		else if (count == 4'h0) count <= 4'hA;
		else count <= count - 1'b1;
	end
	assign timer_done = (count == 4'h0);

	always@(*) begin
		if(!rst_n)
			state <= FILL;
		else
			state <= next_state;
	end

	// NEXT STATE LOGIC //
	always@(*) begin
		if(baud) begin
			case(state)
				// fill up the receive shift register
				FILL: begin
					if(~timer_done)
						next_state = FILL;
					else
						next_state = RECEIVE;
				end
				// receive the data into the databus
				RECEIVE: begin
					if(rxd) 
						next_state = RECEIVE;
					else
						next_state = FILL;
				end
			endcase
		end
	end
	
 
	// SHIFT REGISTER //
	wire[7:0] r_shift_out;
	shift_register shift(.rst_n(rst_n), .baud(baud), .start(start), .stop(stop), .rxd(rxd), .r_shift_out(r_shift_out));

	// FIFO INSTANTIATION FOR RECEIVE BUFFER //
	wire r_buffer_empty, r_buffer_full;
	fifo receive_buffer(.dataIn(r_shift_out), .dataOut(bus_in), .empty(r_buffer_empty), .full(r_buffer_full), .read(), .write(), .clk(clk), .rst_n(rst_n));

	// OUTPUT //
	assign rda = ~r_buffer_empty;
	

endmodule

module shift_register(
	input rst_n,
	input baud,
	input start,
	input stop,
	input rxd,
	output[7:0] r_shift_out
	);

	reg[7:0] hold;

	// SHIFT IN NEW RXD VALUE //
	always_ff @(posedge baud, negedge rst_n) begin
		if (!rst_n | start)
			hold <= 8'h00;
		else
			hold <= {hold[6:0], rxd};
	end
	
	assign r_shift_out = stop ? hold : 8'h00;

endmodule

