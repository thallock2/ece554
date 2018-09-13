//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:   
// Design Name: 
// Module Name:    spart 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module spart(
    input clk,
    input rst,
    input iocs,
    input iorw,
    output rda,
    output tbr,
    input [1:0] ioaddr,
    inout [7:0] databus,
    output txd,
    input rxd
    );

	reg RxD, TxD, RDA, TBR;
	
	// BUS INTERFACE //
	wire [7:0] bus_out, bus_in;
	wire read, write;
	bus_control_spart bus_interface(.databus(databus), .ioaddr(ioaddr), .RDA(rda), .TBR(tbr), .dataOut(bus_out), 
					.transmitIn(bus_in), .IORW(iorw), .read(read), .write(write), .clk(clk), .rst_n(rst_n));

	// BAUD RATE GENERATOR //
	baud_gen baud_generator(.ioaddr(ioaddr), .dataIn(bus_out), .baud(baud), .clk(clk), .rst_n(rst_n));

	// TRANSMIT CONTROL //
	wire baud;
	transmit_control t_control(.clk(clk), .rst_n(rst_n), .baud(baud), .ioaddr(ioaddr), 
		   .txd(txd), /*.start(start), .stop(stop)*/ .tbr(tbr), .tbuffer(tbuffer));


	// RECEIVE CONTROL //
	receive_control r_control(.clk(clk), .rst_n(rst_n), .baud(baud), .ioaddr(ioaddr), 
		   .rxd(rxd), .rda(rda), .rbuffer(rbuffer), .bus_in(bus_in));
	// in order to transfer: apply iocs, iorw, ioaddr, (databus) for one clock cycle 
endmodule


