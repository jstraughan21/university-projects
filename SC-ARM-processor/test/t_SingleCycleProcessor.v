//----------------------------------------------------------------------------//
//  t_SingleCycleProcessor.v
//  
//  This is the testbech for the top level Single Cycle Processor
//
//----------------------------------------------------------------------------//
`timescale 1ns / 1ns

module t_SingleCycleProcessor;
  wire    [31:0]  t_DBtheRegVal;
  wire    [31:0]  t_Instr;
  reg     [3:0]   t_DBtheReg;
  reg             t_clk, t_reset;

  SingleCycleProcessor    uut(t_DBtheRegVal, t_Instr, t_DBtheReg, t_clk, t_reset);

    initial #1000 $finish;
    
    initial begin
        t_clk = 0;
        forever #5 t_clk = ~ t_clk;
        end

  initial begin
    $dumpfile("wavedata.vcd");
    $dumpvars(0, t_SingleCycleProcessor);
    $display("PC\t       Instr\t\t    Reg\t Register Value");
    $display("------------------------------------------------------");
    $monitor("%8h\t %8h\t %3d\t %8h\t", uut.PC, t_Instr, t_DBtheReg, t_DBtheRegVal);
  end

  initial begin 
            t_reset = 1;
  #10       t_reset = 0;
            t_DBtheReg = 4'h4;
  #200      t_DBtheReg = 4'h2;
  end
endmodule