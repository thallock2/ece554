module receive_control_tb();


// DUT1 inputs
reg[1:0] ioaddr;
reg[7:0] bus_out;

// rxd vectors
reg[9:0] vector1, vector2, vector3;


// DUT2 inputs
reg clk, rst_n, rxd;
reg baud;
// DUT2 outputs
wire[7:0] bus_in;
wire rda;



// iDUT receive_control
receive_control DUT2(.clk(clk), .rst_n(rst_n), .baud(baud), .ioaddr(ioaddr), 
		   .rxd(rxd), .rda(rda), .bus_in(bus_in));


always #5 clk = ~clk;

initial begin
	vector1 = 10'b1001100110;
	vector2 = 10'b1010101010;
	vector3 = 10'b1111001110;
	#35
	rxd = vector1[0];
	#50;
	rxd = vector1[1];
	#50;
	rxd = vector1[2];
	#50;
	rxd = vector1[3];
	#50;
	rxd = vector1[4];
	#50;
	rxd = vector1[5];
	#50;
	rxd = vector1[6];
	#50;
	rxd = vector1[7];
	#50;
	rxd = vector1[8];
	#50;
	rxd = vector1[9];
	#100;

	rxd = vector2[0];
	#50;
	rxd = vector2[1];
	#50;
	rxd = vector2[2];
	#50;
	rxd = vector2[3];
	#50;
	rxd = vector2[4];
	#50;
	rxd = vector2[5];
	#50;
	rxd = vector2[6];
	#50;
	rxd = vector2[7];
	#50;
	rxd = vector2[8];
	#50;
	rxd = vector2[9];
	#50;

	rxd = vector3[0];
	#50;
	rxd = vector3[1];
	#50;
	rxd = vector3[2];
	#50;
	rxd = vector3[3];
	#50;
	rxd = vector3[4];
	#50;
	rxd = vector3[5];
	#50;
	rxd = vector3[6];
	#50;
	rxd = vector3[7];
	#50;
	rxd = vector3[8];
	#50;
	rxd = vector3[9];
	#100;
	
end
initial begin
	clk = 1'b0;
	ioaddr = 2'b10;
/*	#25;
	ioaddr = 2'b10;
	bus_out = 8'h28;
	#10;
	ioaddr = 2'b11;
	bus_out = 8'h00;
	#10;
	#10;
*/
end

initial begin
	rst_n = 1'b0;
	baud = 0;
	#1
	rst_n = 1'b1;
end

always begin
	#35;
	baud = ~baud;
	#10
	baud = ~baud;
	#5;
	
end
endmodule
