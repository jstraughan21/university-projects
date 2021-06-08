module position(Hmin, Hmax, Vmin, Vmax, borderHmin, borderHmax, borderVmin, borderVmax, moveUp, moveDown, LR, CLK_100MHz, Reset);
    output reg [9:0] Hmin, Hmax, Vmin, Vmax;
    input      [9:0] borderHmin, borderHmax, borderVmin, borderVmax;
    input            moveUp, moveDown, LR;
    input            CLK_100MHz, Reset;

    reg [1:0] state, nState;
    reg [9:0] nHmin, nHmax, nVmin, nVmax;
    parameter SIDLE=2'b00, SUP=2'b01, SDOWN=2'b10;

    always @(posedge CLK_100MHz) begin
        if(Reset)
            state <= SIDLE;
        else
            state <= nState;
    end

    always @(state, moveUp, moveDown) begin
        case(state)
            SIDLE   : if(moveUp) nState = SUP;
                      else if(moveDown) nState = SDOWN;
                      else nState = SIDLE;
            SUP     : nState = SIDLE;
            SDOWN   : nState = SIDLE;
            default : nState = SIDLE;
        endcase
    end

    always @(posedge CLK_100MHz) begin
            if(Reset) begin
                if (LR)
                    begin
                        Hmin <= 772;
                        Hmax <= 788;
                        Vmin <= 270;
                        Vmax <= 330;
                    end
                else
                    begin
                        Hmin <= 12;
                        Hmax <= 28;
                        Vmin <= 270;
                        Vmax <= 330;
                    end
            end
            else begin
                Hmin <= nHmin;
                Hmax <= nHmax;
                Vmin <= nVmin;
                Vmax <= nVmax;
            end
        end

    always @(state, Hmin, Hmax, Vmin, Vmax) begin
        case(state)
            SIDLE   : begin 
                        nHmin = Hmin;
                        nHmax = Hmax;
                        nVmin = Vmin;
                        nVmax = Vmax;
                      end
            SUP     : if(Vmin == borderVmin)
                        begin
                            nHmin = Hmin;
                            nHmax = Hmax;
                            nVmin = Vmin;
                            nVmax = Vmax;
                        end
                      else
                        begin
                            nHmin = Hmin;
                            nHmax = Hmax;
                            nVmin = Vmin - 1;
                            nVmax = Vmax - 1;
                        end
            SDOWN   : if(Vmax == borderVmax)
                        begin
                            nHmin = Hmin;
                            nHmax = Hmax;
                            nVmin = Vmin;
                            nVmax = Vmax;
                        end
                      else
                        begin
                            nHmin = Hmin;
                            nHmax = Hmax;
                            nVmin = Vmin + 1;
                            nVmax = Vmax + 1;
                        end
            default : begin 
                        nHmin = Hmin;
                        nHmax = Hmax;
                        nVmin = Vmin;
                        nVmax = Vmax;
                      end
        endcase
    end

endmodule