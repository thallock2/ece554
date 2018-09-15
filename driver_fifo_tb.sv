module driver_fifo_tb();

// I/O
reg[7:0] recieve;
reg[1:0] switches;
reg write, read, clk, rst_n;
wire[7:0] transmit;
wire baud;

// Internal Sigs;
wire[15:0] divisor;
wire[7:0] DB1, DB2, SB, RFB, databus;
wire[1:0] ioaddr;
wire AK, IOCS, IORW, RDA, TBR, RFR, TFW, Rfull, Rempty, Tfull, Tempty, update;

// DUTs
driver_control DC(AK, update, divisor, DB1, DB2, ioaddr, TBR, RDA, IORW, IOCS, clk, rst_n);
switch_reader SR(switches, divisor, update, AK, clk, rst_n);
bus_control_driver BCD(databus, DB2, DB1, IORW, IOCS, clk, rst_n);
bus_control_spart BCS(databus, ioaddr, RDA, TBR, SB, RFB, IORW, IOCS, RFR, TFW);
baud_gen BG(ioaddr, SB, baud, clk, rst_n);
fifo RF(recieve, RFB, Rempty, Rfull, RFR, write, clk, rst_n);
fifo TF(SB, transmit, Tempty, Tfull, read, TFW, clk, rst_n);

// RDA TBR
assign RDA = !Rempty;
assign TBR = !Tfull;

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
	// send a few packets
	#1;
	switches = 2'b01;	
	read = 1'b0;
	recieve = 8'h01;
	write = 1'b1;
	#10;
	recieve = 8'h02;
	#10;
	recieve = 8'h03;
	#10;
	recieve = 8'h04;
	#10;
	switches = 2'b11;	
	write = 1'b0;
	
	// wait a bit
	#100;
	$stop();
end


endmodule
