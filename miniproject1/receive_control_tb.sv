module receive_control_tb();


// DUT1 inputs
reg[1:0] ioaddr;
reg[7:0] bus_out;

//DUT1 output
wire baud;

// DUT2 inputs
reg clk, rst_n, rxd;

// DUT2 outputs
wire[7:0] bus_in;
wire rda;

// DUT baud_rate_generator
baud_gen DUT1(.ioaddr(ioaddr), .dataIn(bus_out), .baud(baud), .clk(clk), .rst_n(rst_n));

// iDUT receive_control
receive_control DUT2(.clk(clk), .rst_n(rst_n), .baud(baud), .ioaddr(ioaddr), 
		   .rxd(rxd), .rda(rda), .bus_in(bus_in));


always #5 clk = ~clk;

initial begin
	clk = 1'b0;
	rst_n = 1'b0;
	ioaddr = 2'b10;
	#20
	
	rst_n = 1;
	#5;
	rxd = 0;
	ioaddr = 2'b10;
	bus_out = 8'h28;
	#10;
	rxd = 1;
	ioaddr = 2'b11;
	bus_out = 8'h00;
	#10;
	rxd = 0;
	#10;
	rxd = 1;
end


endmodule
