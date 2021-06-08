//----------------------------------------------------------------------------//
//  t_dmem.v
//  
//  This is the testbech for the data memory module
//
//----------------------------------------------------------------------------//
`timescale 1ns/100ps

module t_dmem;
    wire  [31:0]  t_RD;
    reg   [31:0]  t_A, t_WD;
    reg           t_WE, t_clk;

    dmem   uut(t_RD, t_A, t_WD, t_WE, t_clk);

    initial #1000 $finish;
    
    initial begin
        t_clk = 0;
        forever #5 t_clk = ~ t_clk;
        end

    initial begin
        $dumpfile("wavedata.vcd");
        $dumpvars(0, t_dmem);
        end

    initial begin
            t_A  = 32'h00000000;     // Write FFFF0000 to address 0   
            t_WD = 32'hFFFF0000;
            t_WE = 1;
        #10 t_A  = 32'h00000006;     // Write FFFFFFFF to address 1
            t_WD = 32'hFFFFFFFF;
        #10 t_WE = 0;
            t_A  = 32'h00000000;     // Read the data in address 0

        end
endmodule