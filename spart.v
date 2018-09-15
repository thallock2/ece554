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

// Wires
wire[7:0] receiveIn, data;
wire baud, read, write;

// Modules
baud_gen baudGen(ioaddr, data, baud, clk, rst);
bus_control_spart bus(databus, ioaddr, rda, tbr, data, receiveIn, iorw, iocs, read, write);
recieve_control rec(rxd, receiveIn, rda, baud, read, clk, rst);
transmit_control trans(txd, data, tbr, baud, write, clk, rst);


endmodule
