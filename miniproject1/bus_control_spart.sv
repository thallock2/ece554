module bus_control_spart(databus, ioaddr, RDA, TBR, dataOut, transmitIn, IORW, read, write, clk, rst_n);

// Bus controller for the SPART side of ECE 554 miniproject 1

////////////////////////////////////////////////////////////////////////////////

// I/O
input[7:0] transmitIn;
input[1:0] ioaddr;
input RDA, TBR, IORW, clk, rst_n;
output reg[7:0] dataOut;
output read, write;
inout[7:0] databus;

////////////////////////////////////////////////////////////////////////////////

// databus
assign databus = (IORW && (ioaddr == 2'b00)) ? transmitIn :
		(IORW && (ioaddr == 2'b01)) ? {6'h00, TBR, RDA} :
		8'hzz;

// dataOut - for transmit buffer and baud generator
always_ff @(posedge clk, negedge rst_n) begin
	if (!rst_n) dataOut <= 8'h00;
	else if (!IORW) dataOut <= databus;
	else dataOut <= dataOut;
end

// write - for transmit buffer
assign write = (!IORW && (ioaddr == 2'b00));

// read - for recieve buffer
assign read = (IORW && (ioaddr == 2'b00));


endmodule
