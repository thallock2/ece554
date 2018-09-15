module driver_baud_tb();

// I/O
reg[7:0] transmitIn;
reg[1:0] switches;
reg TBR, RDA, clk, rst_n;
wire baud, read, write;

// Internal Sigs;
wire[15:0] divisor;
wire[7:0] DB1, DB2, SB, databus;
wire[1:0] ioaddr;
wire AK, IOCS, IORW, update;

// DUTs
driver_control DC(AK, update, divisor, DB1, DB2, ioaddr, TBR, RDA, IORW, IOCS, clk, rst_n);
switch_reader SR(switches, divisor, update, AK, clk, rst_n);
bus_control_driver BCD(databus, DB2, DB1, IORW, IOCS, clk, rst_n);
bus_control_spart BCS(databus, ioaddr, RDA, TBR, SB, transmitIn, IORW, IOCS, read, write);
baud_gen BG(ioaddr, SB, baud, clk, rst_n);


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
	// hold unused signals to be nonimportant
	#1;
	TBR = 1'b0;
	RDA = 1'b0;
	transmitIn = 8'h00;

	// set switches and see if the baud rate changes
	switches = 2'b11;
	#3260;

	switches = 2'b01;
	#900;

	$stop();
end


endmodule
