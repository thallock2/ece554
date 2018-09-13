module baud_gen_tb();

//I/O
reg[7:0] dataIn;
reg[1:0] ioaddr;
reg clk, rst_n;
wire baud;

//DUT 
baud_gen DUT(ioaddr, dataIn, baud, clk, rst_n);

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
	// load divisor
	#1;
	ioaddr = 2'b10;
	dataIn = 8'h28;
	#10;
	ioaddr = 2'b11;
	dataIn = 8'h00;
	#10;
	
	// wait a long time to see if it worked...
end


endmodule
