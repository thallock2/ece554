module switch_reader_tb();

// I/O
reg[1:0] switches;
reg clk, rst_n;
wire[15:0] divisor;
wire changed;

// DUT
switch_reader DUT(switches, changed, divisor, clk, rst_n);

////////////////////////////////////////////////////////////////////////////////

// clk and rst
initial begin
	clk = 1'b0;
	forever #5 clk = ~clk;
end
initial begin
	#1 rst_n = 1'b0;
	#1 rst_n = 1'b1;
end

// tests
initial begin
	// 

end


endmodule
