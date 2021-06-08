//----------------------------------------------------------------------------//
//  regfile.v.v
//  
//  The register file hold the contents of each of the 16 registers
//
//----------------------------------------------------------------------------//

module regfile(RD1, RD2, A1, A2, A3, WD3, R15, WE3, clk, reset, DBtheRegVal, DBtheReg);
	output  [31:0]  RD1, RD2;
	input   [3:0]   A1, A2, A3;
	input   [31:0]  WD3, R15;
	input           WE3, clk, reset;
	output  [31:0]  DBtheRegVal;
	input   [3:0]   DBtheReg;

	// Memory created: 32bit words x 16 addresses
	reg     [31:0]  rf[14:0];

	// Determine the value of the registers
	always @(posedge clk, posedge reset) begin
		if(reset) begin
			rf[0] <= 32'b0; 
			rf[1] <= 32'b0;
			rf[2] <= 32'b0;
			rf[3] <= 32'b0;
			rf[4] <= 32'b0;
			rf[5] <= 32'b0;
			rf[6] <= 32'b0;
			rf[7] <= 32'b0;
			rf[8] <= 32'b0;
			rf[9] <= 32'b0;
			rf[10] <= 32'b0;
			rf[11] <= 32'b0;
			rf[12] <= 32'b0;
			rf[13] <= 32'b0;
			rf[14] <= 32'b0;
		end
		else if(WE3)
			rf[A3] <= WD3;
		else begin
			rf[0] <= rf[0];
			rf[1] <= rf[1];
			rf[2] <= rf[2];
			rf[3] <= rf[3];
			rf[4] <= rf[4];
			rf[5] <= rf[5];
			rf[6] <= rf[6];
			rf[7] <= rf[7];
			rf[8] <= rf[8];
			rf[9] <= rf[9];
			rf[10] <= rf[10];
			rf[11] <= rf[11];
			rf[12] <= rf[12];
			rf[13] <= rf[13];
			rf[14] <= rf[14];
		end
	end

	// Assign the outputs
	assign  RD1 = (A1 == 4'd15) ? R15 : rf[A1];
	assign  RD2 = (A2 == 4'd15) ? R15 : rf[A2];
	assign  DBtheRegVal = (DBtheReg == 4'd15) ? R15 : rf[DBtheReg];
endmodule
