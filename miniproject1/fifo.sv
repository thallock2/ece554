module fifo(dataIn, dataOut, empty, full, read, write, clk, rst_n);

// 8x8 FIFO for ECE 554

////////////////////////////////////////////////////////////////////////////////

// I/O
input[7:0] dataIn;
input read, write, clk, rst_n;
output[7:0] dataOut;
output empty, full;

// FIFO Storage Spots
reg[7:0] spot0;
reg[7:0] spot1;
reg[7:0] spot2;
reg[7:0] spot3;
reg[7:0] spot4;
reg[7:0] spot5;
reg[7:0] spot6;
reg[7:0] spot7;

// Internal Sigs
reg[2:0] front;
reg[2:0] back;

////////////////////////////////////////////////////////////////////////////////

// R/W pointers
always_ff @(posedge clk, negedge rst_n) begin
	if (!rst_n) front <= 3'h0;
	else if (read && !empty) front <= front + 1'h1;
end
always_ff @(posedge clk, negedge rst_n) begin
	if (!rst_n) back <= 3'h0;
	else if (write && !full) back <= back + 1'h1;
end

// Empty and Full
assign empty = ({1'b0, back} - {1'b0, front}) == 4'h0;
assign full = ({1'b0, back} - {1'b0, front}) == 4'h7;

// dataOut
assign dataOut = (front == 3'h0) ? spot7 :
               (front == 3'h1) ? spot0 :
               (front == 3'h2) ? spot1 :
               (front == 3'h3) ? spot2 :
               (front == 3'h4) ? spot3 :
               (front == 3'h5) ? spot4 :
               (front == 3'h6) ? spot5 :
               spot6;

//FIFO Data
always_ff @(posedge clk, negedge rst_n) begin
	if (!rst_n) spot0 <= 8'h00;
	else if (write && !full && back == 3'h0) spot0 <= dataIn;
end
always_ff @(posedge clk, negedge rst_n) begin
	if (!rst_n) spot1 <= 8'h00;
	else if (write && !full && back == 3'h1) spot1 <= dataIn;
end
always_ff @(posedge clk, negedge rst_n) begin
	if (!rst_n) spot2 <= 8'h00;
	else if (write && !full && back == 3'h2) spot2 <= dataIn;
end
always_ff @(posedge clk, negedge rst_n) begin
	if (!rst_n) spot3 <= 8'h00;
	else if (write && !full && back == 3'h3) spot3 <= dataIn;
end
always_ff @(posedge clk, negedge rst_n) begin
	if (!rst_n) spot4 <= 8'h00;
	else if (write && !full && back == 3'h4) spot4 <= dataIn;
end
always_ff @(posedge clk, negedge rst_n) begin
	if (!rst_n) spot5 <= 8'h00;
	else if (write && !full && back == 3'h5) spot5 <= dataIn;
end
always_ff @(posedge clk, negedge rst_n) begin
	if (!rst_n) spot6 <= 8'h00;
	else if (write && !full && back == 3'h6) spot6 <= dataIn;
end
always_ff @(posedge clk, negedge rst_n) begin
	if (!rst_n) spot7 <= 8'h00;
	else if (write && !full && back == 3'h7) spot7 <= dataIn;
end


endmodule