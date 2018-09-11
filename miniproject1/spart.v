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

	reg RxD, TxD, RDA, TBR
	
	// in order to transfer: apply iocs, iorw, ioaddr, (databus) for one clock cycle
	
	 
endmodule


module transmit_control(
	input clk,
	input transmit_enable,
	input [1:0] ioaddr,
	output txd,
	output tbr,
	output [7:0] out_bus
	);
	
	reg t_ready
	reg [9:0] t_shift;
	reg [7:0] t_buffer;
	// in transmitter we go from buffer to shift register
	
	always@(posedge clk) begin
		
	end
	
	// counter
	reg[3:0] t_count;
	reg reset_timer
	always@(posedge clk, negedge rst_n) begin
		// RESET	
		if(rst_n = 0)
			t_count <= 10;

		if(t_count == 0)
			t_count <= 10;
		else
			t_count <= t_count - 1;
	end
	reg state;
	// state = 0 -> idle
	// state = 1 -> transmit
	
	reg[3:0] timer

	always@(*) begin
		if(baud) begin
			case(state) begin
				0: begin
					if(t_buff_empty)
						next_state = 1;
					else
						next_state = 0;
				end
				1: begin
					if(timer == 0) 
						next_state = 1;
					else
						next_state = 0;
				end
			endcase
		end
	end
	

endmodule

module receive_control
	input clk,
	input receive_enable,
	input [1:0] ioaddr,
	output txd,
	output tbr,
	output [7:0] out_bus
	);
	reg r_ready
	reg [7:0] rbuffer;
endmodule

module baud_rate_generator(
	input 		clk,
	input [1:0]	ioaddr,
	input [7:0] bus_out,
	output 		enable
	);
	
	reg [15:0] div_buffer;
	

	always@(posedge clk) begin
		if(ioaddr == 10)begin
			div_buffer[7:0] => bus_out;
		end
		else if (ioaddr == 11) begin
			div_buffer[15:8] => bus_out;
		end
	end
	
	
	reg[15:0] count;
	always@(posedge clk) begin
		if(count == 0) begin
			count => div_buffer
			enable => 1;
		end
		else begin
			count => count - 1;
			enable => 0;
		end
		
	end

endmodule


module bus_interface(
	
	)

endmodule

module fifo(
		output empty,
		output full
	)
	
	reg reg0, reg1, reg2, reg3;
	
endmodule