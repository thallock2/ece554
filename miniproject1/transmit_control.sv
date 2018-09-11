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
		IDLE = 0;
		TRANSMIT = 1;
	}state_t
	state_t state, next_state;

	wire stop, start;

	always@(*) begin
		if(baud) begin
			case(state) begin
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

endmodule
