//----------------------------------------------------------------------------//
//  ShiftRegister.v
//  
//  This module determines the 24-bit control word for an LED module. It shifts
//  it out one bit at a time and keeps sending the same color to all modules.
//
//----------------------------------------------------------------------------//

// ShiftRegister.v
// determines the 24-bit control word for an LED module
// shifts it out one bit at a time
// keeps sending the same 24 bits, so same color to all modules

module ShiftRegister(CurrentBit, RotateRegisterLeft, clk, reset, changeColor, loadClr, loadColor);
	output CurrentBit;
	input  RotateRegisterLeft, changeColor, loadClr, loadColor;
	input  clk, reset;

	parameter CLEAR=24'h000000, RED=24'h00F000, GREEN=24'hF00000;  // white, half brightness

	reg [23:0]  TheReg, nTheReg;  // 24 bits for GRB control

	// Set 'TheReg' to it's next value on the rising edge of the clock
	always @(posedge clk) begin
		if(reset) 
			TheReg <= GREEN;
		else 
			TheReg <= nTheReg;
	end
      
    // Switches set the upper 4 bits of the GRB control bytes
	always @(TheReg, changeColor, RotateRegisterLeft, loadClr, loadColor) begin
	   if(loadClr)
	       nTheReg = CLEAR;
	   else if(loadColor)
	       if (TheReg == CLEAR)
	           nTheReg = GREEN;
	       else 
	           nTheReg = TheReg;
	   else if(changeColor)
	       case(TheReg)
	           GREEN:   nTheReg = RED;
	           RED:     nTheReg = RED;
	           default: nTheReg = GREEN;
	       endcase
	   else if(RotateRegisterLeft)
	       nTheReg = {TheReg[22:0],TheReg[23]};
	   else
	       nTheReg = TheReg;
	   end

	assign  CurrentBit = TheReg[23];
endmodule
