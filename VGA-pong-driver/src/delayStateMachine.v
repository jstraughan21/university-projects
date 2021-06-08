module delayStateMachine(done, delay, CLK_100MHz, Reset);
    output done;
    input  delay;
    input  CLK_100MHz, Reset;

    reg [1:0] state, nState;
    reg [19:0] count;
    parameter SIDLE=2'b00, SCOUNT=2'b01, SDONE=2'b10;

    always @(posedge CLK_100MHz) begin
        if(Reset)
            state <= SIDLE;
        else
            state <= nState;
    end

    always @(posedge CLK_100MHz) begin
        if(Reset)
            count <= 20'd0;
        else if (delay)
            count <= (count == 20'd1000000) ? 20'd0 : count + 1;
        else 
            count <= count;
    end

    always @(state, delay, count) begin
        case(state)
            SIDLE   : nState = delay ? SCOUNT : SIDLE;
            SCOUNT  : nState = (count == 20'd1000000) ? SDONE : SCOUNT;
            SDONE  :  nState = SIDLE;
            default : nState = SIDLE;
        endcase
    end

    assign done = (state == SDONE);

endmodule