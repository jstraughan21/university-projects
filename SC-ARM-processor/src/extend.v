//----------------------------------------------------------------------------//
//  extend.v
//  
//  The extend module detemines the value of the immediate and extended it to
//  be 32 bits
//
//----------------------------------------------------------------------------//

module  extend(ExtImm, theData, ImmSrc);
	output  [31:0]  ExtImm;
	input   [23:0]  theData;
	input   [1:0]   ImmSrc;

	reg     [31:0]  ExtImm;

	// Based on ImmSrc and the instruction, set the immediate value
	always  @(theData, ImmSrc) begin
		case(ImmSrc)
			2'b00:  ExtImm = {24'b0, theData[7:0]};                     // DP
			2'b01:  ExtImm = {20'b0, theData[11:0]};                    // MEM
			2'b10:  ExtImm = { {6{theData[23]}}, theData[23:0], 2'b00}; // B
			default:  ExtImm = 32'b0;
		endcase
	end
endmodule



