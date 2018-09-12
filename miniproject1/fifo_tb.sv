module fifo_tb();

// I/O
reg[7:0] dataIn;
reg read, write, clk, rst_n;
wire[7:0] dataOut;
wire empty, full;

// DUT
fifo DUT(dataIn, dataOut, empty, full, read, write, clk, rst_n);

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
	// write until fifo is full
	dataIn = 8'h00;
	read = 1'h0;
	write = 1'h0;
	#2;
	while (!full) begin
		write = 1'h1;
		#10;
		dataIn = dataIn + 8'h01;
		//$display("full is %b", {1'b0, DUT.back} - {1'b0, DUT.front});
	end
	write = 1'h0;
	
	// read two things then write two things
	read = 1'h1;
	#10;
	#10;
	read = 1'h0;
	write = 1'h1;
	#10;
	dataIn = dataIn + 8'h01;
	#10;
	dataIn = dataIn + 8'h01;
	write = 1'h0;

	// read until fifo is empty
	while (!empty) begin
		read = 1'h1;
		#10;
	end
	read = 1'h0;

	// write until fifo is full
	while (!full) begin
		write = 1'h1;
		#10;
		dataIn = dataIn + 8'h01;
	end
	write = 1'h0;

	$stop();
end


endmodule
