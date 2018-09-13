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
		IDLE = 0,
		RECEIVE = 1
	}state_t;
	state_t state, next_state;	

	// Timer
	reg[3:0] count;
	reg start;
	always_ff @(posedge clk, negedge rst_n, start) begin
		if(baud) begin
			if (!rst_n | start)
				 count <= 4'h8;
			else if (count == 4'h0)
				 count <= 4'h8;
			else 
				count <= count - 1'b1;
		end
	end
	assign timer_done = (count == 4'h0);

	always@(posedge clk, negedge rst_n) begin
		if(!rst_n)
			state <= IDLE;
		else
			state <= next_state;
	end
	
	reg fifo_write;
	reg get_next_bit;
	// NEXT STATE LOGIC //
	always@(*) begin
		start = 0;
		if(baud) begin
			case(state)
				// fill up the receive shift register
				IDLE: begin
					if(~rxd) begin
						next_state = RECEIVE;
						start = 1;
					end
					else
						next_state = IDLE;
				end
				// receive the data into the databus
				RECEIVE: begin
					if(~timer_done) 
						next_state = RECEIVE;
//						get_next_bit = 1'b1
					else begin
						next_state = IDLE;
						fifo_write = 1'b1;
					end
				end
			endcase
		end
	end
	
 
	// SHIFT REGISTER //
	wire[7:0] r_shift_out;
	shift_register shift(.start(), .clk(clk), .rst_n(rst_n), .baud(baud), .rxd(rxd), .r_shift_out(r_shift_out));

	// FIFO INSTANTIATION FOR RECEIVE BUFFER //
	wire r_buffer_empty, r_buffer_full;
	fifo receive_buffer(.dataIn(r_shift_out), .dataOut(bus_in), .empty(r_buffer_empty), .full(r_buffer_full), .read(), .write(fifo_write), .clk(clk), .rst_n(rst_n));

	// OUTPUT //
	assign rda = ~r_buffer_empty;
	

endmodule

module shift_register(
	input start,
	input clk,
	input rst_n,
	input baud,
	input rxd,
	output[7:0] r_shift_out
	);

	reg[7:0] hold;

	// SHIFT IN NEW RXD VALUE //
	always_ff @(posedge clk, negedge rst_n) begin
		if (~rst_n)
			hold <= 8'h00;
		else if (baud) begin
			if (start)
				hold <= 8'h00;
			else
				hold <= {hold[6:0], rxd};
		end
//	else
//			nothing
//			hold <= hold;
	end
	
	assign r_shift_out = hold;

endmodule

