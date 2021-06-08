/* VGASync.v - Low level VGA signal generation module
   UW EE4490 
   Adapted from original code by Jerry C. Hamann
    * Borrowed from...
    DigitalCold's ARM Challenge VGA Implementation
        Freefull's graphics demo reimplemented.
        Additional information at http://io.netgarage.org/arm/digitalcold/
    Released 4/25/13
    * EDITED 11/29/13, 12/1/14, 11/30/2015, 11/28/2016 and 11/27/2017 by Jerry C. Hamann
    * to obtain simple 800x600 SVGA driver and apply to BASYS3 board with 100 MHz clk.
    * NOTE:  also adapted to produce VGA timing based on display area as start of
    * clocking counts (ex. 0-799 is horizontal display, 0-599 is vertical display).
*/

module VGASync(VS, HS, HBlank, VBlank, CurrentX, CurrentY, CLK_100MHz, Reset);
    output VS;
    output HS;
    output HBlank;
    output VBlank;     
    output [10:0] CurrentX; 
    output [10:0] CurrentY;
    input  CLK_100MHz;
    input  Reset;

    reg VS; //vsync
    reg HS; //hsync
        
    //##### Module constants (http://tinyvga.com/vga-timing/ORIGINAL WAS 640x480@60Hz) 
    // JCH Mod to 800x600@72Hz with data from www.epanorama.net/documents/pc/vga_timing.html
    // NOTE:  Doubling of clock rate from 50MHz to 100MHz means doubling in horizontal counts.

    parameter SYNCLOGIC  =     0; // 0 means negative logic (sync pulse is "go low")

    // The horizontal units are 2*"pixel clocks" due to 100MHz clocking
    // One whole line is 2080*(1/100MHz) = 20.8 microseconds
    parameter HSyncWidth =    240; // h. pulse width
    parameter HBackPorch =    122; // h. back porch
    parameter HDisplayArea = 1612; // horizontal display area
    parameter HFrontPorch =   106; // h. front porch
    parameter HLimit =       2080; // maximum horizontal amount (limit), including pront porch, display area, back porch and synch width
    
    // The vertical units are "horizontal lines"
    // The full screen is then 666*(20.8us) = 13.8528 milliseconds (72.19 Hz)
    parameter VSyncWidth =     6; // v. pulse width   
    parameter VBackPorch =    21; // v. back porch
    parameter VDisplayArea = 604; // vertical display area
    parameter VFrontPorch =   35; // v. front porch
    parameter VLimit =       666; // maximum vertical amount (limit), including pront porch, display area, back porch and synch width
    
    reg  [12:0] CurHPos; // maximum of HLimit (2^12 - 1 = 4095), signed to allow sub/comp
    reg  [10:0] CurVPos; // maximum of VLimit (2^10 - 1 = 1023), signed to allow sub/comp
    wire Blank;
    
    // Compute the vertical and horizontal positions
    always @(posedge CLK_100MHz) begin
        if(Reset) begin          // Reset coordinate to 0,0
            CurHPos <= 0;
            CurVPos <= 0;
		  end
        else 
        if(CurHPos < HLimit-1) begin  // If horizontal position has not reached limit, increase horizontal position and vertical positions remains unchanged (horizontal scan)
            CurVPos <= CurVPos;
            CurHPos <= CurHPos + 1;
        end
        else begin                    // If horizontal position reaches limit, clear it to 0 and increase vertical position (vertical scan). If both reach limit, back to  0, 0
            CurHPos <= 0;
            if(CurVPos < VLimit-1)
                CurVPos <= CurVPos + 1;
            else
                CurVPos <= 0;
        end
    end
    
    // HSync logic
    always @(posedge CLK_100MHz)      // How many clock cycles that HSync remains low
        if( (CurHPos >= (HDisplayArea+HFrontPorch)) &&
            (CurHPos <  (HDisplayArea+HFrontPorch+HSyncWidth) ))
            HS <= SYNCLOGIC;
        else
            HS <= !SYNCLOGIC;
            
    // VSync logic        
    always @(posedge CLK_100MHz)      // How many clock cycles that VSync remains low
        if( (CurVPos >= (VDisplayArea+VFrontPorch)) &&
            (CurVPos <  (VDisplayArea+VFrontPorch+VSyncWidth) ))
            VS <= SYNCLOGIC;
        else
            VS <= !SYNCLOGIC;
        
   // Determine when color drives should be blanked        
   assign VBlank = (CurVPos >= VDisplayArea) ? 1 : 0;
   assign HBlank = (CurHPos >= HDisplayArea) ? 1 : 0;
    
    // Keep track of the current "real" X position. This is the actual current X
    // pixel location abstracted away from all the timing details, 0-799
    assign CurrentX = (CurHPos>>1);   // Divide by two due to 100MHz clocking
    // Keep track of the current "real" Y position. This is the actual current Y
    // pixel location abstracted away from all the timing details, 0-599
    assign CurrentY = (CurVPos);
    
endmodule
