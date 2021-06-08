//----------------------------------------------------------------------------//
//  imem.v
//  
//  The instruction memory holds the instructions to be executed
//
//----------------------------------------------------------------------------//

module imem(RD, A);
	output  [31:0]  RD;
	input   [31:0]  A;

	reg     [31:0]  RD;

	// The instruction is read based on the address specified -> A[5:2]
	always @(A) begin
		case(A[5:2])
			4'b0000: RD = 32'hE202_2000;  //      AND  R2,R2,#0
			4'b0001: RD = 32'hE382_3000;  //      ORR  R3,R2,#0
			4'b0010: RD = 32'hE383_4005;  //      ORR  R4,R3,#5
			4'b0011: RD = 32'hE034_4004;  //      EORALS  R4,R4,R4
			4'b0100: RD = 32'hEA00_0005;  //      BEQ  T2
			4'b0101: RD = 32'hE082_2004;  // T1:  ADD  R2,R2,R4
			4'b0110: RD = 32'hE254_4001;  //      SUB  R4,R4,#1
			4'b0111: RD = 32'hE154_0003;  //      CMPAL  R4, R3
			4'b1000: RD = 32'h1AFF_FFFB;  //      BNE  T1
			4'b1001: RD = 32'hE583_2000;  //      STR  R2,[R3]
			4'b1010: RD = 32'hE593_5000;  //      LDR  R5,[R3]
			4'b1011: RD = 32'hEAFF_FFFE;  // T2:  BAL  T2
			default: RD = 32'hEAFF_FFFE;  // T3:  BAL  T3
		endcase
	end
endmodule