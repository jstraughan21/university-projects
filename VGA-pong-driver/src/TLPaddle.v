module TLPaddle(Hmin, Hmax, Vmin, Vmax, borderHmin, borderHmax, borderVmin, borderVmax, SW, LR, CLK_100MHz, Reset);
    output [9:0]    Hmin, Hmax, Vmin, Vmax;
    input  [9:0]    borderHmin, borderHmax, borderVmin, borderVmax;
    input           SW, LR;
    input           CLK_100MHz, Reset;

    wire            moveUp, moveDown, done, delay;

    PaddleStateMachine  box_u1(moveUp, moveDown, delay, SW, done, CLK_100MHz, Reset);
    delayStateMachine   box_u2(done, delay, CLK_100MHz, Reset);
    position            box_u3(Hmin, Hmax, Vmin, Vmax, borderHmin, borderHmax, borderVmin, borderVmax, moveUp, moveDown, LR, CLK_100MHz, Reset);

endmodule