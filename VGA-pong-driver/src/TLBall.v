module TLBall(BHmin, BHmax, BVmin, BVmax, borderHmin, borderHmax, borderVmin, borderVmax, LHmin, LHmax, LVmin, LVmax,
                 RHmin, RHmax, RVmin, RVmax, CLK_100MHz, Reset);
    output [9:0]    BHmin, BHmax, BVmin, BVmax;
    input  [9:0]    LHmin, LHmax, LVmin, LVmax;
    input  [9:0]    RHmin, RHmax, RVmin, RVmax;
    input  [9:0]    borderHmin, borderHmax, borderVmin, borderVmax;
    input           CLK_100MHz, Reset;

    wire            move, done, delay;

    BallStateMachine    ball_u1(move, delay, done, CLK_100MHz, Reset);
    delayStateMachine   ball_u2(done, delay, CLK_100MHz, Reset);
    BallPosition        ball_u3(BHmin, BHmax, BVmin, BVmax, borderHmin, borderHmax, borderVmin, borderVmax, LHmin, LHmax, LVmin, LVmax, 
                                 RHmin, RHmax, RVmin, RVmax, move, CLK_100MHz, Reset);

endmodule