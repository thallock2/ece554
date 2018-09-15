module bus_control_spart(databus, ioaddr, RDA, TBR, dataOut, receiveIn, IORW, IOCS, read, write);

// Bus controller for the SPART side of ECE 554 miniproject 1

////////////////////////////////////////////////////////////////////////////////

// I/O
input[7:0] receiveIn;
input[1:0] ioaddr;
input RDA, TBR, IORW, IOCS;
output[7:0] dataOut;
output read, write;
inout[7:0] databus;

////////////////////////////////////////////////////////////////////////////////

// databus
assign databus = (IORW && IOCS && (ioaddr == 2'b00)) ? receiveIn :
		(IORW && IOCS && (ioaddr == 2'b01)) ? {6'h00, TBR, RDA} :
		8'hzz;

// dataOut - for transmit buffer and baud generator
assign dataOut = (!IORW && IOCS) ? databus : 8'h00;

// write - for transmit buffer
assign write = (!IORW && IOCS && (ioaddr == 2'b00));

// read - for recieve buffer
assign read = (IORW && IOCS && (ioaddr == 2'b00));


endmodule
