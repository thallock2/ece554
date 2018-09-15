module bus_control_driver(databus, dataIn, dataOut, IORW, IOCS, clk, rst_n);

// Bus controller for the driver side of ECE 554 miniproject 1

////////////////////////////////////////////////////////////////////////////////

// I/O
input[7:0] dataIn;
input IORW, IOCS, clk, rst_n;
output reg[7:0] dataOut;
inout[7:0] databus;

////////////////////////////////////////////////////////////////////////////////

// databus
assign databus = (!IORW && IOCS) ? dataIn :
		8'hzz;

// dataOut
always @(posedge clk, negedge rst_n) begin
	if (!rst_n) dataOut <= 8'h00;
	else if (IORW && IOCS) dataOut <= databus;
	else dataOut <= dataOut;
end
//assign dataOut = (IORW && IOCS) ? databus :
//		8'h00;

endmodule
