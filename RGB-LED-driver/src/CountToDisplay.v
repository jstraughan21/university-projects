//----------------------------------------------------------------------------//
//  CountToDisplay.v
//  
//  This module decodes a 4-bit BCD input and creates the 16-bit output `disp`
//	to be displayed on the 4 seven-segment LEDs.
//
//----------------------------------------------------------------------------//

module CountToDisplay(disp, lCount);
    output reg [15:0] disp;
    input [3:0] lCount;
    
    always @(lCount) begin
		case(lCount)
			4'd0:  disp = 16'b0000_0000_0000_0000;
			4'd1:  disp = 16'b0000_0000_0000_0001;
			4'd2:  disp = 16'b0000_0000_0000_0010;
			4'd3:  disp = 16'b0000_0000_0000_0011;
			4'd4:  disp = 16'b0000_0000_0000_0100;
			4'd5:  disp = 16'b0000_0000_0000_0101;
			4'd6:  disp = 16'b0000_0000_0000_0110;
			4'd7:  disp = 16'b0000_0000_0000_0111;
			4'd8:  disp = 16'b0000_0000_0000_1000;
			4'd9:  disp = 16'b0000_0000_0000_1001;
			4'd10: disp = 16'b0000_0000_0001_0000;
			4'd11: disp = 16'b1010_1011_1100_1101;
			default: disp = 16'b0000_0000_0000_0000;
		endcase
		end
endmodule