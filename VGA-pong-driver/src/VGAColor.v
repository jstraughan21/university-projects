// VGAColor.v - Example VGA color computation client
// UW EE 4490 
// Adapted from original code by Jerry C. Hamann
// Computes the desired color at pix (X,Y), must do this fast!

module VGAColor(RED, GREEN, BLUE, CurrentX, CurrentY, VBlank, HBlank, scoreL, scoreR, 
LHmin, LHmax, LVmin, LVmax, RHmin, RHmax, RVmin, RVmax, BHmin, BHmax, BVmin, BVmax,
                    borderHmin, borderHmax, borderVmin, borderVmax,
 LscoreHmin, RscoreHmin, scoreVmin, scoreVmax ,CLK_100MHz, Reset);
    output  [3:0]   RED, GREEN, BLUE;
    input   [10:0]  CurrentX, CurrentY;
    input           VBlank, HBlank;
    input           scoreL, scoreR;
    input   [9:0]   LHmin, LHmax, LVmin, LVmax;
    input   [9:0]   RHmin, RHmax, RVmin, RVmax;
    input   [9:0]   BHmin, BHmax, BVmin, BVmax;
    input   [9:0]   borderHmin, borderHmax, borderVmin, borderVmax;
    input   [9:0]   LscoreHmin, RscoreHmin, scoreVmin, scoreVmax;
    input           CLK_100MHz, Reset;

    reg     [3:0]   RED, GREEN, BLUE;
    reg     [2:0]   leftScoreReg, rightScoreReg;
    reg     [9:0]   leftMax, rightMax;
    
    always @(posedge CLK_100MHz) begin
        if(Reset || (leftScoreReg == 3'b100 || rightScoreReg == 3'b100)) begin
            leftScoreReg <= 3'b00;
            rightScoreReg <= 3'b00;
        end
        else if(scoreL)
            leftScoreReg <= leftScoreReg + 1;
        else if(scoreR)
            rightScoreReg <= rightScoreReg + 1;
        else begin
            leftScoreReg <= leftScoreReg;
            rightScoreReg <=rightScoreReg;
        end     
    end
  
    always @(leftScoreReg) begin
        case(leftScoreReg)
            3'b000   : leftMax = 10'd0;
            3'b001   : leftMax = 10'd25;
            3'b010   : leftMax = 10'd50;
            3'b011   : leftMax = 10'd75;
            default : leftMax = 10'd0;
        endcase
    end
    
    always @(rightScoreReg) begin
        case(rightScoreReg)
            3'b000   : rightMax = 10'd0;
            3'b001   : rightMax = 10'd25;
            3'b010   : rightMax = 10'd50;
            3'b011   : rightMax = 10'd75;
            default : rightMax = 10'd0;
        endcase
    end
  
    // Assuming an 800x600 screen resolution, paints the frame
    always @(VBlank, HBlank, CurrentX, CurrentY, LHmin, LHmax, LVmin, LVmax, RHmin, RHmax, RVmin, RVmax, BHmin, BHmax, BVmin, BVmax, borderHmin, borderHmax, borderVmin, borderVmax, LscoreHmin, RscoreHmin, rightMax, leftMax) begin
        if(VBlank || HBlank)
            {RED,GREEN,BLUE} = 0; // Must drive colors only during non-blanking times.
        else
            if((CurrentX>LscoreHmin && (CurrentX<LscoreHmin+leftMax) && CurrentY>scoreVmin && CurrentY<scoreVmax)||(CurrentX>RscoreHmin && (CurrentX<RscoreHmin+rightMax) && CurrentY>scoreVmin && CurrentY<scoreVmax))
                {RED,GREEN,BLUE} = 12'hf07;
            else if ((CurrentX<borderHmin || CurrentX>borderHmax || CurrentY<borderVmin || CurrentY>borderVmax))
                {RED,GREEN,BLUE} = 12'h39B;
            else if ((CurrentX>LHmin && CurrentX<LHmax && CurrentY>LVmin && CurrentY<LVmax)||(CurrentX>RHmin && CurrentX<RHmax && CurrentY>RVmin && CurrentY<RVmax)||(CurrentX>BHmin && CurrentX<BHmax && CurrentY>BVmin && CurrentY<BVmax))
                {RED,GREEN,BLUE} = 12'hfff;
            else
                {RED,GREEN,BLUE} = 12'h000;
    end
    
 endmodule