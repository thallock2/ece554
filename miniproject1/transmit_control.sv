module transmit_control(TX, dataIn, TBR, baud, write, clk, rst_n, nextWord);

// RS232 UART transmitter for ECE 554 miniproject 1

////////////////////////////////////////////////////////////////////////////////

// I/O
input[7:0] dataIn;
input baud, write, clk, rst_n;
output TX, TBR;

// Internal Sigs
output wire[7:0] nextWord;
wire empty, full;
reg[9:0] shiftReg;
reg [3:0] timer;
reg readBuf, setTimer, tick, loadShift, shift;

// debugging

// State Type
typedef enum reg[1:0] {IDLE, LOAD, TRANS} state_t;
state_t state;
state_t next_state;

////////////////////////////////////////////////////////////////////////////////

// Shift Reg
always @(posedge clk, negedge rst_n) begin
	if (!rst_n) shiftReg <= 10'h111;
	else if (loadShift) shiftReg <= {1'b1, nextWord, 1'b0};
	else if (shift) shiftReg <= {1'b1, shiftReg[9:1]};
	else shiftReg <= shiftReg;
end

// Timer
always @(posedge clk, negedge rst_n) begin
	if (!rst_n) timer <= 4'h0;
	else if (setTimer) timer <= 4'ha;
	else if (tick) timer <= timer - 1'b1;
	else timer <= timer;
end

// FIFO
fifo buffer(dataIn, nextWord, empty, full, readBuf, write, clk, rst_n);

// TBR
assign TBR = !full;

// TX
assign TX = shiftReg[0];

// State Flops
always @(posedge clk, negedge rst_n) begin
	if (!rst_n) state <= IDLE;
	else state <= next_state;
end

// State Logic
always_comb begin
	// Default Signals
	readBuf = 1'b0;
	setTimer = 1'b0;
	loadShift = 1'b0;
	tick = 1'b0;
	shift = 1'b0;
	next_state = IDLE;
	// State Control
	case (state)
		IDLE: begin
			if (baud) begin
				if (!empty) begin
					loadShift = 1'b1;
					next_state = LOAD;
				end
				else next_state = IDLE;
			end
			else next_state = IDLE;
		end
		LOAD: begin
			readBuf = 1'b1;
			setTimer = 1'b1;
			next_state = TRANS;
		end
		TRANS: begin
			if (baud) begin
				if (timer == 4'h0) begin
					next_state = IDLE;
				end
				else begin
					tick = 1'b1;
					shift = 1'b1;
					next_state = TRANS;
				end
			end
			else next_state = TRANS;
		end
//		default: next_state = IDLE;
	endcase
end


endmodule
	
