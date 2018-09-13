module receive_control_tb();

// DUT1 inputs
reg[1:0] ioaddr;
reg[7:0] bus_out;
reg fifo_write;

//DUT1 output


// DUT2 inputs
reg clk, rst_n;
reg baud;

wire tbr, txd;

// iDUT receive_control
transmit_control DUT1(.clk(clk), .rst_n(rst_n), .baud(baud), .ioaddr(ioaddr), 
		   .fifo_write(fifo_write), .txd(txd), .tbr(tbr), .bus_out(bus_out));


always #5 clk = ~clk;

initial begin
	bus_out = 8'h0F;
	clk = 1'b0;
	ioaddr = 2'b10;
	fifo_write = 1'b1;
	#10;
	fifo_write = 1'b0;
	#500;

end

initial begin
	rst_n = 1'b0;
	#1
	rst_n = 1'b1;
end

initial begin 
	baud = 1'b0;
end
always #50 baud = ~baud;
endmodule