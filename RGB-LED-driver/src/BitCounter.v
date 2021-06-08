//----------------------------------------------------------------------------//
//  BitCounter.v
//  
//  This module is a simple 8-bit synchronous counter. The main inputs connect 
//	GRBStateMachine. Value of output Count keeps track of how many bits have 
//	been sent. This implies a max of 10 LED modules could be used (240 bits).
//	For longer LED strips, increase the bit width of the counter.
//
//----------------------------------------------------------------------------//

module BitCounter(Count, ClearCounter, IncCounter, clk, reset);
	output  [7:0] Count;
	input   ClearCounter, IncCounter;
	input   clk, reset;

	reg [7:0] Count, nCount;

	// Set 'Count' to it's next value on the rising edge of the clock
	always @(posedge clk) begin
		if(reset) Count <= 0;
		else Count <= nCount;
		end

	// Determine the next value of 'Count' based on the inputs
	always @(Count, reset, ClearCounter, IncCounter) begin
		if(reset || ClearCounter)
			nCount = 0;
		else if(IncCounter)
			nCount = Count + 1;
		else
			nCount = Count;
		end
endmodule
