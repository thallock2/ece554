module transmit_control_tb();

// DUT1 inputs
reg[1:0] ioaddr;
reg[7:0] bus_out;
reg fifo_write;

// DUT2 inputs
reg clk, rst_n;
reg baud;

wire tbr, txd;

// iDUT receive_control
transmit_control DUT1(.clk(clk), .rst_n(rst_n), .baud(baud), .ioaddr(ioaddr), 
		   .fifo_write(fifo_write), .txd(txd), .tbr(tbr), .bus_out(bus_out));


always #5 clk = ~clk;

initial begin
	bus_out = 8'b10011001;
	clk = 1'b0;
	baud = 1'b0;
	ioaddr = 2'b10;
	fifo_write = 1'b1;
	#10;
	fifo_write = 1'b0;
	#800;
	fifo_write = 1'b1;
	bus_out = 8'b11100111;
	#10;
	fifo_write = 1'b0;

end

initial begin
	rst_n = 1'b0;
	#1
	rst_n = 1'b1;
end

always begin
	#35;
	baud = ~baud;
	#10
	baud = ~baud;
	#5;
	
end
endmodule