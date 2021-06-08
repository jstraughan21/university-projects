module BallStateMachine(move, delay, done, CLK_100MHz, Reset);
    output move, delay;
    input  done;
    input  CLK_100MHz, Reset;
    
    reg [1:0] state, nState;
    parameter SIDLE=2'b00, SMOVE=2'b01, SDELAY=2'b10;
    
    always @(posedge CLK_100MHz) begin
        if(Reset)
            state <= SIDLE;
        else
            state <= nState;
    end
    
    always @(state, done) begin
        case(state)
            SIDLE   : nState = SMOVE;
            SMOVE   : nState = SDELAY;
            SDELAY  : nState = done ? SIDLE : SDELAY;
            default : nState = SDELAY;
        endcase
    end
    
    assign move = (state == SMOVE);
    assign delay = (state == SDELAY);
endmodule