module switch_reader_tb();

// I/O
reg[1:0] switches;
reg AK, clk, rst_n;
wire[15:0] divisor;
wire update;

// DUT
switch_reader DUT(switches, divisor, update, AK, clk, rst_n);

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
	// try switches and AK the update each time
	#1;
	AK = 1'b0;
	switches = 2'b00;
	#50;
	AK = 1'b1;
	#10;

	AK = 1'b0;
	switches = 2'b01;
	#50;
	AK = 1'b1;
	#10;
	
	AK = 1'b0;
	switches = 2'b10;
	#50;
	AK = 1'b1;
	#10;

	AK = 1'b0;
	switches = 2'b11;
	#50;
	AK = 1'b1;
	#10;

	#50;
	$stop();
end


endmodule
