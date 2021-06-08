module PaddleStateMachine(moveUp, moveDown, delay, SW, done, CLK_100MHz, Reset);
    output moveUp, moveDown;
    output delay;
    input  SW, done;
    input  CLK_100MHz, Reset;

    reg [1:0] state, nState;
    parameter SIDLE=2'b00, SUP=2'b01, SDOWN=2'b10, SDELAY=2'b11;

    always @(posedge CLK_100MHz) begin
        if(Reset)
            state <= SIDLE;
        else
            state <= nState; 
    end

    always @(state, SW, done) begin
        case(state)
            SIDLE  : nState = SW ? SUP : SDOWN;  
            SUP    : nState = SDELAY;
            SDOWN  : nState = SDELAY;
            SDELAY : nState = done ? SIDLE : SDELAY;
            default: nState = SIDLE;
        endcase
    end

    assign moveUp = (state == SUP);
    assign moveDown = (state == SDOWN);
    assign delay = (state == SDELAY);

endmodule