//----------------------------------------------------------------------------//
//  NZRbitGEN.v
//  
//  This module generates NZR line code timing for WS2812B GRB LED Module.
//	This module must receive input qmode which specifies the current NZR line 
//	code to be produced. The value of qmode should be held constant until the
//	Moore output bdone is asserted. A new qmode should then be supplied within 
//  10ns to begin the generation of the next line code. 
//
//----------------------------------------------------------------------------//

module NZRbitGEN(bout, bdone, qmode, startcoding, clk, reset);
	output  bout, bdone;  // bout  -- NZR signal
                          // bdone -- line code generation completed
	input   [1:0] qmode;  // Mode for generation:
                          // 2'b00 Produce a "0"
                          // 2'b01 Produce a "1"
                          // 2'b10 Solid low output (for resets)
                          // 2'b11 Solid high output (not used in WB2812B)
	input   startcoding;  // Like reset, drives counter to zero to synchronize code generation
	input   clk, reset;   // synchronous, 100 MHz assumed
	reg     bout;          
	reg     [6:0] bcount; // 0-127 count for generating NZR timing of a bit
                          // Note:  128*(1/100MHz) = 1.28 us (close enough to 1.25 us)

	// Implement state memory and next state for synchronous bcounter for bit time
	always @(posedge clk) begin
		// Depends on 7'h7F->7'h00 rollover at 1.28 us
		if(reset || startcoding)
			bcount <= 0;
		else
			bcount <= bcount + 1; 
		end

	always @(qmode or bcount) begin // bout produced based on qmode
		// 36*(1/(100 MHz)) = 0.36 us = 28% of 1.28 us
		// 92*(1/(100 MHz)) = 0.92 us = 72% of 1.28 us
		case(qmode)         
			2'b00:  bout = (bcount < 36) ? 1 : 0 ; // "0" in 1.28 us
			2'b01:  bout = (bcount < 92) ? 1 : 0 ; // "1" in 1.28 us
			2'b10:  bout = 0; // Produces "RESET" output, stays low
			2'b11:  bout = 1; // Reserved for future use
			default: bout = 0;
		endcase
		end

	assign bdone = (bcount == 127);  // Marks end of bit period
endmodule
