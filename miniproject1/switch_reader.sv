module switch_reader(switches, divisor, update, AK, clk, rst_n);

// Switch reader for the driver side of ECE 554 miniproject 1

////////////////////////////////////////////////////////////////////////////////

// I/O
input[1:0] switches;
input AK, clk, rst_n;
output[15:0] divisor;
output reg update;

// Internal Sigs
reg[1:0] old;

////////////////////////////////////////////////////////////////////////////////

// Value change detection
always_ff @(posedge clk, negedge rst_n) begin
	if (!rst_n) old <= 2'b01;
	else if (old != switches) old <= switches;
	else old <= old;
end

// Update flag
always_ff @(posedge clk, negedge rst_n) begin
	if (!rst_n) update <= 1'b0;
	else if (old != switches) update <= 1'b1;
	else if (AK) update <= 1'b0;
	else update <= update;
end

// Divisor Output
assign divisor = (switches == 2'b00) ? 16'h28a0 :
		(switches == 2'b01) ? 16'h1450 :
		(switches == 2'b10) ? 16'h0a20 :
		16'h0500;


endmodule
