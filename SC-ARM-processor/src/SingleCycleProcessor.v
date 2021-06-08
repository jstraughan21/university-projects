//----------------------------------------------------------------------------//
//  SingleCycleProcessor.v
//  
//  This is the top level module for the processor which combines all modules
//   and creates the interconnecting blocks
//
//----------------------------------------------------------------------------//

module  SingleCycleProcessor(DBtheRegVal, Instr, DBtheReg, clk, reset);
	output  [31:0]  DBtheRegVal;
	output  [31:0]  Instr;
	input   [3:0]   DBtheReg;
	input           clk, reset;

	wire            PCSrc, MemtoReg, MemWrite, ALUSrc, RegWrite;
	wire    [1:0]   ImmSrc, RegSrc;
	wire    [2:0]   ALUControl;
	wire    [31:0]  Instr, PCPrime, PCPlus4, PCPlus8, Result, ReadData,
                  ALUResult, SrcA, SrcB, RD2, WriteData, ExtImm;
	wire    [3:0]   RA1, RA2, ALUFlags;

	reg     [31:0]  PC;

	// Wire the modules together
	controlunit     u1(PCSrc, MemtoReg, MemWrite, ALUControl, ALUSrc, ImmSrc, RegWrite, RegSrc, Instr, ALUFlags, clk);
	imem            u2(Instr, PC);
	regfile         u3(SrcA, RD2, RA1, RA2, Instr[15:12], Result, PCPlus8, RegWrite, clk, reset, DBtheRegVal, DBtheReg);
	extend          u4(ExtImm, Instr[23:0], ImmSrc);
	alu             u5(ALUResult, ALUFlags, ALUControl, SrcA, SrcB);
	dmem            u6(ReadData, ALUResult, WriteData, MemWrite, clk);

	// Create the PC Counter
	always @(posedge clk, posedge reset) begin
		if(reset)
			PC <= 0;
		else
			PC <= PCPrime;
	end


	// Create the adders and multiplexers
	assign  PCPrime = PCSrc ? Result : PCPlus4;
	assign  PCPlus4 = PC + 4'h4;
	assign  PCPlus8 = PCPlus4 + 4'h4;
	assign  Result  = MemtoReg ? ReadData : ALUResult;
	assign  RA1     = RegSrc[0] ? 4'd15 : Instr[19:16];
	assign  RA2     = RegSrc[1] ? Instr[15:12] : Instr[3:0];
	assign  SrcB    = ALUSrc ? ExtImm : RD2;
	assign  WriteData = RD2;

endmodule
