module spart_tb();

// I/O
reg[1:0] ioaddr_2, br_cfg, data_control;
reg clk, rst_n, iocs_2, iorw_2;
wire[7:0] databus_2;

// Internal Sigs
wire[7:0] databus;
wire[1:0] ioaddr;
wire txd, rxd, iorw, iocs, rda, tbr, rda_2, tbr_2;

// DUTs
spart SPART_1(clk, rst_n, iocs, iorw, rda, tbr, ioaddr, databus, txd, rxd);
spart SPART_2(clk, rst_n, iocs_2, iorw_2, rda_2, tbr_2, ioaddr_2, databus_2, rxd, txd);
driver DRIVE_1(clk, rst_n, br_cfg, iocs, iorw, rda, tbr, ioaddr, databus);

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

// databus_2
assign databus_2 = (data_control == 2'b00) ? 8'h11 :
		(data_control == 2'b01) ? 8'h22 :
		(data_control == 2'b10) ? 8'h33 :
		8'hzz;

// tests
initial begin
	// send three words and see if we get them back
	#1;
	iorw_2 = 1'b0;
	ioaddr_2 = 2'b00;
	br_cfg = 2'b01;
	iocs_2 = 1'b1;
	data_control = 2'b00;
	#10
	data_control = 2'b01;
	#10
	data_control = 2'b10;
	#10
	iocs_2 = 1'b0;
	// wait a VERY long time due to baud rate
	#200000;
	$stop();
end


endmodule
