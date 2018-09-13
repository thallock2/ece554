module baud_gen(ioaddr, dataIn, baud, clk, rst_n);
	
// Baud rate generator ECE 554 miniproject 1

////////////////////////////////////////////////////////////////////////////////

// I/O
input[7:0] dataIn;
input[1:0] ioaddr;
input clk, rst_n;
output baud;

// Internal Sigs
reg [15:0] divisor, count;
	
////////////////////////////////////////////////////////////////////////////////

// Divisor Storage
always_ff @(posedge clk, negedge rst_n) begin
	if (!rst_n) divisor <= 16'h0145;
	else if (ioaddr == 2'b10) divisor[7:0] <= dataIn;
	else if (ioaddr == 2'b11) divisor[15:8] <= dataIn;
	else divisor <= divisor;
end
	
// Timer
always_ff @(posedge clk, negedge rst_n) begin
	if (!rst_n) count <= 16'h0000;
	else if (count == 16'h0000) count <= divisor;
	else count <= count - 1'b1;
end

// Baud Enable Signal
assign baud = (count == 16'h0000);

endmodule
