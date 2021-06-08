//----------------------------------------------------------------------------//
//  SSStateMachine.v
//  
//  This module allows the user to reset the system, say "Go", say "Stop", and 
//  say "Clear". Inputs come from user and GRBStateMachine module. 
//
//----------------------------------------------------------------------------//

module SSStateMachine(shipGRB, Done, Go, clk, reset, allDone, Ready2Go, Stop, nextLED, delay,lost, Clr, shipClr);
	output	shipGRB, Ready2Go, delay, shipClr;
	input	allDone, Done, Go, Stop, nextLED,lost,Clr;
	input	clk, reset;

	reg [2:0]	S, nS;
	parameter	SWAIT=3'b000, SSHIP=3'b001, SRET=3'b010, SDELAY=3'b011, SCLEAR=3'b100, SCLEARRET=3'b101;

	// Set the next state on the rising edge of the clock
	always @(posedge clk) begin
		if(reset)
			S <= SWAIT;
		else
			S <= nS;
		end
	
	// Determine the next value of the state based on the inputs
	always @(S, Go, Clr, Stop, Done, allDone, lost, nextLED) begin
		case(S)
			SWAIT:      if(Go)         nS = SSHIP;
			            else if(Clr)   nS = SCLEAR;	
			            else           nS = SWAIT;	
			SSHIP:		nS = Done    ? SRET     : SSHIP;
			SRET:       if(allDone) begin
			                 if(Stop || lost) nS = SWAIT;
			                 else             nS = SDELAY;
			                 end
			            else nS = SRET;
			SDELAY:     nS = nextLED ? SSHIP     : SDELAY;
			SCLEAR:     nS = Done    ? SCLEARRET : SCLEAR;                       
			SCLEARRET:  nS = allDone ? SWAIT     : SCLEARRET;
			default:	nS = SWAIT;
		endcase
		end

	// Assign the outputs
	assign Ready2Go = (S==SWAIT);  // okay to press Go
	assign shipGRB  = (S==SSHIP);  // send data bits
	assign shipClr  = (S==SCLEAR);
	assign delay    = (S==SDELAY);
endmodule

