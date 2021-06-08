//----------------------------------------------------------------------------//
//	Mux4Machine.v
//  
//  This module provides a state machine to drive multiplexed four-bit values
//  for display on Digilent Basys3 seven segment displays. Assumes a highspeed
//  input clock, uses internal counter to time-multiplex. 
//
//	A count of 2^NUMSVAR total clock ticks will will occur across one full display
//  of 4 digits. Will a 100MHz clock, that means 10ns * 2^20 = 10.48 ms. That is,
//  the whole display is updated around 95 times per second (95Hz), which each
//  display being "on" for 2.62 ms out of every 10.48ms.
//
//----------------------------------------------------------------------------//

module Mux4Machine(muxd,adrive,A,B,C,D,clk,reset,blank);
	output [3:0] muxd; 			// The multiplexed output selected from A,B,C,D
	output [3:0] adrive;  		// Active low common anode drive of display
	input  [3:0] A,B,C,D,blank;
	input        clk,reset;

	reg    [3:0] muxd, adrive;
	parameter NUMSVAR=20;
	//parameter NUMSVAR=8;   		// for testing

	reg    [NUMSVAR:1] nS, S; 	// Internal states to provide clk division

	always @(posedge clk) begin
		if (reset) S <= 0;
		else  S <= nS;
	end

	always @(S) begin
		nS = S + 1;
	end

	always @(S[NUMSVAR:NUMSVAR-1] or A or B or C or D or blank) begin
		case(S[NUMSVAR:NUMSVAR-1])
			2'b11: begin muxd=A; adrive=(!blank[3] ? 4'b0111 : 4'b1111); end
			2'b10: begin muxd=B; adrive=(!blank[2] ? 4'b1011 : 4'b1111); end
			2'b01: begin muxd=C; adrive=(!blank[1] ? 4'b1101 : 4'b1111); end
			2'b00: begin muxd=D; adrive=(!blank[0] ? 4'b1110 : 4'b1111); end
			default: begin muxd=A; adrive=4'b1111; end
		endcase
	end
endmodule
