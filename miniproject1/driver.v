//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    
// Design Name: 
// Module Name:    driver 
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
module driver(
    input clk,
    input rst,
    input [1:0] br_cfg,
    output iocs,
    output iorw,
    input rda,
    input tbr,
    output [1:0] ioaddr,
    inout [7:0] databus
    );

// Wires
wire[15:0] divisor;
wire[7:0] controlIn, controlOut;
wire AK, update;

// Modules
driver_control control(AK, update, divisor, controlIn, controlOut, ioaddr, tbr, rda, iorw, iocs, clk, rst);
bus_control_driver bus(databus, controlOut, controlIn, iorw, iocs, clk, rst);
switch_reader switch(br_cfg, divisor, update, AK, clk, rst);


endmodule
