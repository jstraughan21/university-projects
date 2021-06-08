//----------------------------------------------------------------------------//
//  SimpleSend.v
//  
//  This module is the top level module for the WS2812B LED Strip Controller.
//
//----------------------------------------------------------------------------//

module SimpleSend(dataOut, Go, clk, reset, Ready2Go, Stop, Clr, adrive, Leds);
    output [0:6] Leds;
    output [3:0] adrive;
	output	dataOut, Ready2Go;
	input	Go, clk, reset, Stop, Clr;

    wire [3:0]  lCount, muxd;
    wire [15:0] disp;
	wire		shipGRB, Done, allDone, nextLED, delay, changeColor, lost, Go_db, Stop_db, Clr_db;
	wire [1:0]	qmode;
	wire		ShiftPattern, StartCoding, ClrCounter, IncCounter, theBit, bdone, shipClr, loadClr, loadColor;
	wire [7:0]	Count;
	
	parameter blank = 4'b0000;

    DeBouncer       dbGo(Go_db, Go, clk, reset);
    DeBouncer       dbStop(Stop_db, Stop, clk, reset);
    DeBouncer       dbClr(Clr_db, Clr, clk, reset);
	SSStateMachine	sssm(shipGRB,Done,Go_db,clk,reset,allDone,Ready2Go,Stop_db, nextLED,delay,lost,Clr_db,shipClr);
	GRBStateMachine grbsm(qmode,Done,ShiftPattern,StartCoding,ClrCounter,IncCounter,
                              shipGRB,theBit,bdone,Count,clk,reset,allDone,nextLED,delay,changeColor,lost, shipClr, loadClr,loadColor, lCount);
	ShiftRegister   shftr(theBit,ShiftPattern,clk,reset,changeColor,loadClr,loadColor);
	BitCounter	    btcnt(Count,ClrCounter,IncCounter,clk,reset);
	NZRbitGEN	    nzrgn(dataOut,bdone,qmode,StartCoding,clk,reset);
	CountToDisplay  c2d(disp, lCount);
	Mux4Machine     mux(muxd, adrive, disp[15:12], disp[11:8], disp[7:4], disp[3:0], clk, reset, blank);
	Hex27Seg        h27(Leds, muxd);
endmodule
 