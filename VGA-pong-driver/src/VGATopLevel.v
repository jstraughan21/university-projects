// VGATopLevel.v - Top level module for example VGA driver implementation in Verilog
// UW EE 4490 
// Adapted from original code by Jerry C. Hamann

module VGATopLevel(VS, HS, RED, GREEN, BLUE, SW1, SW2, CLK_100MHz, Reset);
    output          VS, HS; 
    output [3:0]    RED, GREEN, BLUE;
    input           SW1, SW2;
    input           CLK_100MHz, Reset;
    
    parameter borderHmin=10'd10, borderHmax=10'd790, borderVmin=10'd10, borderVmax=10'd590;
    parameter scoreVmin=10'd100, scoreVmax=10'd150;
    parameter LscoreHmin=10'd216;
	parameter RscoreHmin=10'd482;
    parameter RIGHT = 1'b1;
    parameter LEFT = 1'b0;
    
    wire            HBlank, VBlank;
    wire            scoreL, scoreR;
    wire   [10:0]   CurrentX, CurrentY;
    wire   [9:0]    LHmin, LHmax, LVmin, LVmax;
    wire   [9:0]    RHmin, RHmax, RVmin, RVmax;
    wire   [9:0]    BHmin, BHmax, BVmin, BVmax;

    VGASync             u1(VS, HS, VBlank, HBlank, CurrentX, CurrentY, CLK_100MHz, Reset);
    VGAColor            u2(RED, GREEN, BLUE, CurrentX, CurrentY, VBlank, HBlank, scoreL, scoreR, 
                            LHmin, LHmax, LVmin, LVmax, RHmin, RHmax, RVmin, RVmax, BHmin, BHmax, BVmin, BVmax,
                            borderHmin, borderHmax, borderVmin, borderVmax,
                            LscoreHmin, RscoreHmin, scoreVmin, scoreVmax ,CLK_100MHz, Reset);

    TLPaddle            left(LHmin, LHmax, LVmin, LVmax, borderHmin, borderHmax, borderVmin, borderVmax, SW2, LEFT, CLK_100MHz, Reset);
    TLPaddle            right(RHmin, RHmax, RVmin, RVmax, borderHmin, borderHmax, borderVmin, borderVmax, SW1, RIGHT, CLK_100MHz, Reset);
    
    TLBall              ball(BHmin, BHmax, BVmin, BVmax, scoreL, scoreR, borderHmin, borderHmax, borderVmin, borderVmax, 
                               LHmin, LHmax, LVmin, LVmax, RHmin, RHmax, RVmin, RVmax, CLK_100MHz, Reset);
    
endmodule
