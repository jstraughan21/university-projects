//----------------------------------------------------------------------------//
//  dmem.v
//  
//  The data memory stores values and can be written to or read from with a 
//  specified address.
//
//----------------------------------------------------------------------------//

module dmem(RD, A, WD, WE, clk);
	output  [31:0]  RD;
	input   [31:0]  A, WD;
	input           WE, clk;
  
	// Create the registers for the data being read and the memory block
	// Memory created: 32bit words x 8 addresses
	reg     [31:0]  RD;
	reg     [31:0]  dMem [7:0];

	// Write the data to the address specified -> A[4:2]
	always @(posedge clk) begin
		if(WE)
			dMem[A[4:2]] <= WD;
	end

	// Read the data from the address specified -> A[4:2]
	always @(A, dMem[A[4:2]]) begin
		RD = dMem[A[4:2]];
	end
endmodule
