module bus_interface(
	input [7:0] r_buffer
	input iorw,
	inout[7:0] databus,
	output 

	assign premux = ioaddr[0] ? {6'b0, {{rda}, {tbr}}} : r_buffer; 
	assign databus = iorw ? premux : 8'bz;
	
	// generate controls for transmit and recieve FIFOs
	// specifically, tell the receive FIFO when to read
	// and the transmit FIFO when to write.
	reg [7:0] last_valid;
	

endmodule
