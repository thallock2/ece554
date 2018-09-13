module receive_control_tb();


// DUT1 inputs
reg[1:0] ioaddr;
reg[7:0] bus_out;

//DUT1 output


// DUT2 inputs
reg clk, rst_n, rxd;
reg baud;
// DUT2 outputs
wire[7:0] bus_in;
wire rda;



// iDUT receive_control
receive_control DUT2(.clk(clk), .rst_n(rst_n), .baud(baud), .ioaddr(ioaddr), 
		   .rxd(rxd), .rda(rda), .bus_in(bus_in));


always #5 clk = ~clk;

initial begin
	rxd = 1'b1;
	clk = 1'b0;
	ioaddr = 2'b10;
	#25;
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
