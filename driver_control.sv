module driver_control(AK, update, divisor, dataIn, dataOut, ioaddr, TBR, RDA, IORW, IOCS, clk, rst_n);

// Driver control state machine for ECE 554 miniproject 1

////////////////////////////////////////////////////////////////////////////////

// I/O
input[15:0] divisor;
input[7:0] dataIn;
input update, TBR, RDA, clk, rst_n;
output reg[7:0] dataOut;
output reg[1:0] ioaddr;
output reg AK, IORW, IOCS; 

// State Type
typedef enum reg[1:0] {IDLE, DIV, TRANS} state_t;
state_t state, next_state;

////////////////////////////////////////////////////////////////////////////////

// State Flops
always @(posedge clk, negedge rst_n) begin
	if (!rst_n) state <= IDLE;
	else state <= next_state;
end

// State Logic
always_comb begin
	// Default Signals
	dataOut = 8'h00;
	ioaddr = 2'b00;
	AK = 1'b0;
	IORW = 1'b0;
	IOCS = 1'b0;
	next_state = IDLE;

	// State Controls
	case(state)
		IDLE: begin
			if (update) begin
				dataOut = divisor[7:0];
				ioaddr = 2'b10;
				IOCS = 1'b1;
				next_state = DIV;
			end
			else if (RDA) begin
				IORW = 1'b1;
				IOCS = 1'b1;
				next_state = TRANS;
			end
			else next_state = IDLE;
		end
		DIV: begin
			dataOut = divisor[15:8];
			ioaddr = 2'b11;
			AK = 1'b1;
			IOCS = 1'b1;
			next_state = IDLE;
		end
		TRANS: begin
			dataOut = dataIn;
			IORW = 1'b0;
			IOCS = 1'b1;
			next_state = IDLE;
		end
		default: next_state = IDLE;
	endcase
end


endmodule
