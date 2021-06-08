//----------------------------------------------------------------------------//
//  t_extend.v
//  
//  This is the testbech for the extend module
//
//----------------------------------------------------------------------------//
`timescale 1ns/100ps

module t_extend;
    wire  [31:0]  t_ExtImm;
    reg   [23:0]  t_theData;
    reg   [1:0]   t_ImmSrc;

    extend   uut(t_ExtImm, t_theData, t_ImmSrc);

    initial begin
        $display("ImmSrc\t theData\t | ExtImm");
        $display("------------------------------------------------------------------------");
        $monitor("%b\t %h\t\t | %b",t_ImmSrc, t_theData, t_ExtImm);
        end

    initial begin
        t_theData = 24'h132000;
        t_ImmSrc  = 2'b00;
        end
endmodule