//----------------------------------------------------------------------------//
//  t_controlunit.v
//  
//  This is the testbech for the Control Unit module
//
//----------------------------------------------------------------------------//
`timescale 1ns/100ps

module t_controlunit;
  wire         t_PCSrc, t_MemtoReg, t_MemWrite, t_ALUSrc, t_RegWrite;
  wire [1:0]   t_ALUControl, t_ImmSrc, t_RegSrc;
  reg  [31:0]  t_Instr;
  reg  [3:0]   t_ALUFlags;
  reg          t_clk;


    controlunit   uut(t_PCSrc, t_MemtoReg, t_MemWrite, t_ALUControl, t_ALUSrc, t_ImmSrc, t_RegWrite, t_RegSrc,
                        t_Instr, t_ALUFlags, t_clk);

    initial #1000 $finish;
    
    initial begin
        t_clk = 0;
        forever #5 t_clk = ~ t_clk;
        end

    initial begin
        $dumpfile("wavedata.vcd");
        $dumpvars(0, t_controlunit);
        end

    initial begin
                t_ALUFlags = 4'b0000;
                t_Instr = 32'hE2132000;   // ands r2, r3, #0
        #10     t_Instr = 32'hE591500C;   // ldr r5, [r1, #12]
        end
endmodule