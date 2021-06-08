//----------------------------------------------------------------------------//
//  t_regfile.v
//  
//  This is the testbech for the register file module
//
//----------------------------------------------------------------------------//
`timescale 1ns/100ps

module t_regfile;
  wire  [31:0]  t_RD1, t_RD2;
  reg   [3:0]   t_A1, t_A2, t_A3;
  reg   [31:0]  t_WD3, t_R15;
  reg           t_WE3, t_clk, t_reset;
  wire  [31:0]  t_DBtheRegVal;
  reg   [3:0]   t_DBtheReg;

    regfileDB   uut(t_RD1, t_RD2, t_A1, t_A2, t_A3, t_WD3, t_R15, t_WE3, t_clk, t_reset, t_DBtheRegVal, t_DBtheReg);

    initial #1000 $finish;
    
    initial begin
        t_clk = 0;
        forever #5 t_clk = ~ t_clk;
        end

    initial begin
        $dumpfile("wavedata.vcd");
        $dumpvars(0, t_regfileDB);
        end

    initial begin
            t_WE3 = 1;
            t_A3  = 4'h0;               // Write F to register 0
            t_WD3 = 32'h0000_000F;
        #10 t_A3  = 4'h1;               // Write F0 to register 1
            t_WD3 = 32'h0000_00F0;
        #10 t_WE3 = 0;
            t_A1  = 4'h0;               // Read register 1
            t_A2  = 4'h1;               // Read register 2
        end
endmodule