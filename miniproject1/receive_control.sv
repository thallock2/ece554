module recieve_control(RX, dataOut, RDA, baud, read, clk, rst_n);

// RS232 UART reciever for ECE 554 miniproject 1

////////////////////////////////////////////////////////////////////////////////

// I/O
output[7:0] dataOut;
output RDA;
input RX, baud, read, clk, rst_n;

// debugging signals
//output [8:0] shiftReg
// wire rec_state
//output [1:0] rec_state;
// Internal Sigs
wire[7:0] nextWord;
wire empty, full;
reg[8:0] shiftReg;
reg [3:0] timer;
reg writeBuf, setTimer, tick, loadShift, shift;

// State Type
typedef enum reg[1:0] {IDLE = 2'b11, REC = 2'b00} state_t;
state_t state;
state_t next_state;

////////////////////////////////////////////////////////////////////////////////

// Shift Reg
always @(posedge clk, negedge rst_n) begin
	if (!rst_n) shiftReg <= 9'h000;
	else if (loadShift) shiftReg <= 9'h000;
	else if (shift) shiftReg <= {RX, shiftReg[8:1]};
	else shiftReg <= shiftReg;
end

// Timer
always @(posedge clk, negedge rst_n) begin
	if (!rst_n) timer <= 4'h0;
	else if (setTimer) timer <= 4'h9;
	else if (tick) timer <= timer - 1'b1;
	else timer <= timer;
end

// FIFO
fifo buffer(nextWord, dataOut, empty, full, read, writeBuf, clk, rst_n);

// RDA
assign RDA = !empty;

// nextWord
assign nextWord = shiftReg[7:0];

// State Flops
always @(posedge clk, negedge rst_n) begin
	if (!rst_n) state <= IDLE;
	else state <= next_state;
end

// State Logic
always_comb begin
	// Default Signals
	writeBuf = 1'b0;
	setTimer = 1'b0;
	loadShift = 1'b0;
	tick = 1'b0;
	shift = 1'b0;
	next_state = IDLE;
	// State Control
	case (state)
		IDLE: begin
			if (baud) begin
				if (!RX) begin
					loadShift = 1'b1;
					setTimer = 1'b1;
					next_state = REC;
				end
				else next_state = IDLE;
			end
			else next_state = IDLE;
		end
		REC: begin
			if (baud) begin
				if (timer == 4'h0) begin
					next_state = IDLE;
					writeBuf = 1'b1;
				end
				else begin
					tick = 1'b1;
					shift = 1'b1;
					next_state = REC;
				end
			end
			else next_state = REC;
		end
//		default: next_state = IDLE;
	endcase
end


/*// debugging signal
assign rec_state = state;

output reg flop;
always @(posedge clk, negedge rst_n) begin 
	if (~rst_n)
			flop <= 0;
	else if(state == REC)
			flop <= 1;
	else
			flop <= flop;
end
*/
endmodule
	
