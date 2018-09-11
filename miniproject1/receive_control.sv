module receive_control(
	input clk,
	input baud,
	input receive_enable,
	input [1:0] ioaddr,
	output txd,
	output tbr,
	output [7:0] out_bus
	);
	reg r_ready;
	reg [7:0] rbuffer;

	// state machine
	typedef enum{
		SHIFT = 0;
		RECEIVE = 1;
	}state_t
	state_t state, next_state;

	wire stop, start;

	always@(*) begin
		if(baud) begin
			case(state) begin
				// fill up the receive shift register
				SHIFT: begin
					if(stop)
						next_state = RECEIVE;
					else
						next_state = SHIFT;
				end
				// receive the data into the databus
				RECEIVE: begin
					if(~start) 
						next_state = RECEIVE;
					else
						next_state = SHIFT;
				end
			endcase
		end
	end

endmodule

