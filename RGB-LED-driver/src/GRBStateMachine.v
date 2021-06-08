//----------------------------------------------------------------------------//
//  GRBStateMachine.v
//  
//  Output qmode tells the NZRbitGEN module whether to send a 0, 1, or RESET.
//  Supports WS281B reset code of > 280us. 
//  bdone ticks every bit period (1.28us)
//  RESET is > 280us, use 281000 clks = 281us
//
//----------------------------------------------------------------------------//

module GRBStateMachine(qmode,Done,ShiftPattern,StartCoding,
          ClrCounter,IncCounter,ShipGRB,theBit,bdone,Count,clk,reset,allDone, nextLED, delay, changeColor,lost, ShipClr, loadClr, loadColor, lCount);
	output	[1:0] qmode;
	output  [3:0] lCount;
	output	allDone, Done, ShiftPattern, StartCoding, ClrCounter, IncCounter, nextLED, changeColor, lost, loadClr, loadColor;
	input	ShipGRB, theBit, bdone, delay, ShipClr;
	input   [7:0] Count;
	input	clk, reset;
  
	reg	     	S, nS;
	parameter	SSHIPRET=1'b0, SSHIPGRB=1'b1;
	reg [7:0]   COMPAREVAL;

	reg      [14:0]  rCount;  		// Counter for RESET time
	reg      [3:0]   lCount = 4'b0000;
	reg      [22:0]  dCount = 23'd0;

	// Set the state to the right value on the rising edge of the clock
	always @(posedge clk) begin
		if(reset)
			S <= SSHIPRET;
		else
			S <= nS;
		end

	// Determine the next state based on the inputs
	always @(S, ShipGRB, bdone, Count, COMPAREVAL, ShipClr) begin
		case(S)
			SSHIPRET:  nS = (ShipGRB || ShipClr) ? SSHIPGRB : SSHIPRET;	// Ready to send data?
			SSHIPGRB:  nS = (bdone && (Count==COMPAREVAL)) ? SSHIPRET : SSHIPGRB;	// All bits sent?
			default:   nS = SSHIPRET;
		endcase
		end

	// Assign the outputs based on the current state and inputs
	assign loadColor      = (S==SSHIPRET) && ShipGRB;
	assign loadClr        = (S==SSHIPRET) && ShipClr;
	assign ClrCounter     = (S==SSHIPRET) && (ShipGRB || ShipClr);
	assign StartCoding    = (S==SSHIPRET) && (ShipGRB || ShipClr);
	assign ShiftPattern   = (S==SSHIPGRB) && bdone;
	assign IncCounter     = (S==SSHIPGRB) && bdone;
	assign qmode          = (S==SSHIPRET) ? 2'b10 : {1'b0,theBit};
	assign Done           = (S==SSHIPGRB) && bdone && (Count==COMPAREVAL);
	assign allDone        = (S==SSHIPRET) && (rCount==15'd28100); // 281 us
	assign nextLED        = (S==SSHIPRET) && (dCount == 23'd5000000); // 0.5s
	assign changeColor    = (lCount == 4'd10) && (dCount == 23'd5000000);
	assign lost           = (lCount == 4'd11);

	// Count the time needed for RESET, with 10ns per tick
	always @(posedge clk) begin
		if(reset || Done)
			rCount <= 0;
		else if (S==SSHIPRET)
			rCount <= rCount+1; 
		else 
			rCount <= rCount;
		end
		
	always @(posedge clk) begin
	   if(reset)
	       lCount <= 4'd0;
	   else if (S==SSHIPRET && ShipGRB)
	       lCount <= (lCount==4'd11) ? 4'd1 : lCount + 1;
	   else 
	       lCount <= lCount;
	   end
		
	always @(posedge clk) begin
	   if(reset)
	       dCount <= 0;
       else if (delay)
           dCount <= dCount + 1;
       else
           dCount <= dCount;
       end
		
		
	// How many LED modules are we sending to?
	always @(lCount) begin
		case(lCount)
			4'd1:  COMPAREVAL = 23;  // 1*24 = 24 bits
			4'd2:  COMPAREVAL = 47;  // 2*24 = 48 bits
			4'd3:  COMPAREVAL = 71;  // 3*24 = 72 bits
			4'd4:  COMPAREVAL = 95;  // 4*24 = 96 bits
			4'd5:  COMPAREVAL = 119; // 5*24 = 120 bits
			4'd6:  COMPAREVAL = 143;  // 1*24 = 24 bits
			4'd7:  COMPAREVAL = 167;  // 2*24 = 48 bits
			4'd8:  COMPAREVAL = 191;  // 3*24 = 72 bits
			4'd9:  COMPAREVAL = 215;  // 4*24 = 96 bits
			4'd10: COMPAREVAL = 239; // 5*24 = 120 bits
			4'd11: COMPAREVAL = 239;
			default: COMPAREVAL = 23;
		endcase
		end		
endmodule