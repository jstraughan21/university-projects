module BallPosition(BHmin, BHmax, BVmin, BVmax, borderHmin, borderHmax, borderVmin, borderVmax, LHmin, LHmax, LVmin, LVmax, 
                        RHmin, RHmax, RVmin, RVmax, move, CLK_100MHz, Reset);
    output reg [9:0]  BHmin, BHmax, BVmin, BVmax;
    input      [9:0]  borderHmin, borderHmax, borderVmin, borderVmax;
    input      [9:0]  LHmin, LHmax, LVmin, LVmax;
    input      [9:0]  RHmin, RHmax, RVmin, RVmax;
    input             move;
    input             CLK_100MHz, Reset;
	
	reg        [1:0] state, nState;
    reg        [9:0] nBHmin, nBHmax, nBVmin, nBVmax;
    parameter        SUL=2'b00, SUR=2'b01, SDL=2'b10, SDR=2'b11;
	
	
    always @(posedge CLK_100MHz) begin
        if(Reset)
            state <= SUL;
        else
            state <= nState;
    end

    always @(posedge CLK_100MHz) begin
            if(Reset) begin
                BHmin <= 395;
                BHmax <= 405;
                BVmin <= 295;
                BVmax <= 305;
            end
            else begin
                BHmin <= nBHmin;
                BHmax <= nBHmax;
                BVmin <= nBVmin;
                BVmax <= nBVmax;
            end
        end
	
	always @(state, BHmin, BHmax, BVmin, BVmax) begin
	   case(state)
	       SUL     : begin
	                 if(BVmin == borderVmin)   nState = SDL;
                     else if (BHmin == LHmax)  nState = SUR;
                     else                      nState = SUL;
                     end
	       SUR     : begin
	                 if(BVmin == borderVmin)   nState = SDR;
                     else if (BHmax == RHmin)  nState = SUL;
                     else                      nState = SUR;
                     end
	       SDL     : begin
	                 if(BVmax == borderVmax)   nState = SUL;
                     else if (BHmin == LHmax)  nState = SDR;
                     else                      nState = SDL;
                     end
	       SDR     : begin
	                 if(BVmax == borderVmax)   nState = SUR;
                     else if (BHmax == RHmin)  nState = SDL;
                     else                      nState = SDR;
                     end
	       default : nState = SUL;
	   endcase
	end
	
    always @(state, move, BHmin, BHmax, BVmin, BVmax) begin
        case(state)
            SUL     :   if(move) begin
						         nBHmin = BHmin - 1;
                                 nBHmax = BHmax - 1;
                                 nBVmin = BVmin - 1;
                                 nBVmax = BVmax - 1;
                                 end
                        else begin	
						     nBHmin = BHmin;
                             nBHmax = BHmax;
                             nBVmin = BVmin;
                             nBVmax = BVmax;
                        end
					  
					  
			SUR     :   if(move) begin
						         nBHmin = BHmin + 1;
                                 nBHmax = BHmax + 1;
                                 nBVmin = BVmin - 1;
                                 nBVmax = BVmax - 1;
                                 end
                        else begin	
						     nBHmin = BHmin;
                             nBHmax = BHmax;
                             nBVmin = BVmin;
                             nBVmax = BVmax;
                        end
					  
			
			SDL     :   if(move) begin
						         nBHmin = BHmin - 1;
                                 nBHmax = BHmax - 1;
                                 nBVmin = BVmin + 1;
                                 nBVmax = BVmax + 1;
                                 end
                        else begin	
						     nBHmin = BHmin;
                             nBHmax = BHmax;
                             nBVmin = BVmin;
                             nBVmax = BVmax;
                        end	
 
			
			SDR     :   if(move) begin
						         nBHmin = BHmin + 1;
                                 nBHmax = BHmax + 1;
                                 nBVmin = BVmin + 1;
                                 nBVmax = BVmax + 1;
                                 end
                        else begin	
						     nBHmin = BHmin;
                             nBHmax = BHmax;
                             nBVmin = BVmin;
                             nBVmax = BVmax;
                        end
						
						
            default : if(move) begin
						         nBHmin = BHmin - 1;
                                 nBHmax = BHmax - 1;
                                 nBVmin = BVmin - 1;
                                 nBVmax = BVmax - 1;
                                 end
                        else begin	
						     nBHmin = BHmin;
                             nBHmax = BHmax;
                             nBVmin = BVmin;
                             nBVmax = BVmax;
                        end
        endcase
    end

endmodule	