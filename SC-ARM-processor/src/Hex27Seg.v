//----------------------------------------------------------------------------//
//  Hex27Seg.v
//  
//  This module decodes a four-bit binary pattern `HexVal` into avtive low LED
//	excitation signals for a conventional seven-segment display. Provides
//  hexadeciaml digits 0 thru F.
//
//	  Segment:      a        b        c        d        e        f        g
//    Signal:    Leds[0]  Leds[1]  Leds[2]  Leds[3]  Leds[4]  Leds[5]  Leds[6]
//
//----------------------------------------------------------------------------//

module Hex27Seg(Leds,HexVal);
	output[0:6] Leds;
	input [3:0] HexVal;
	reg   [0:6] Leds;

	always @(HexVal) begin
		case(HexVal)
			4'h0:  Leds = 7'b000_0001;  	// forms the character for 0
			4'h1:  Leds = 7'b100_1111;  	// forms the character for 1
			4'h2:  Leds = 7'b001_0010;  	// forms the character for 2
			4'h3:  Leds = 7'b000_0110;  	// forms the character for 3
			4'h4:  Leds = 7'b100_1100;  	// forms the character for 4
			4'h5:  Leds = 7'b010_0100;  	// forms the character for 5
			4'h6:  Leds = 7'b010_0000;  	// forms the character for 6
			4'h7:  Leds = 7'b000_1111;  	// forms the character for 7
			4'h8:  Leds = 7'b000_0000;  	// forms the character for 8
			4'h9:  Leds = 7'b000_0100;  	// forms the character for 9
			4'hA:  Leds = 7'b000_1000;  	// forms the character for A
			4'hB:  Leds = 7'b110_0000;  	// forms the character for B
			4'hC:  Leds = 7'b011_0001;  	// forms the character for C
			4'hD:  Leds = 7'b100_0010;  	// forms the character for D
			4'hE:  Leds = 7'b011_0000;  	// forms the character for E
			4'hF:  Leds = 7'b011_1000;  	// forms the character for F
			default:  Leds = 7'b111_1111; //  a blank default
		endcase
	end
endmodule
