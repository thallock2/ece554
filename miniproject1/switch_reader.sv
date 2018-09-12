module switch_reader(switches, changed, divisor, clk, rst_n);

// Switch reader for the driver side of ECE 554 miniproject 1

////////////////////////////////////////////////////////////////////////////////

// I/O
input[1:0] switches;
input clk, rst_n;
output[15:0] divisor;
output reg changed;

// Internal Sigs
reg[1:0] old;

////////////////////////////////////////////////////////////////////////////////

// Value change detection
always_ff @(posedge clk, negedge rst_n) begin
	if (!rst_n) begin
		old <= 2'b00;
		changed <=1'b0;
	end
	else if (old != switches) begin 
		old <= switches;
		changed <= 1'b1;
	end
	else begin
		old <= old;
		changed <=1'b0;
	end
end

// Divisor Output
assign divisor = (switches == 2'b00) ? 16'h0145 :
		(switches == 2'b01) ? 16'h00a2 :
		(switches == 2'b10) ? 16'h0050 :
		16'h0028;


endmodule
