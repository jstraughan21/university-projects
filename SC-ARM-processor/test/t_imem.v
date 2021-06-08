//----------------------------------------------------------------------------//
//  t_imem.v
//  
//  This is the testbech for the instruction memory module
//
//----------------------------------------------------------------------------//
`timescale 1ns/100ps

module t_imem;
    wire  [31:0]  t_RD;
    reg   [31:0]  t_A;

    imem   uut(t_RD, t_A);

    initial begin
        $display("A\t | RD\t");
        $display("---------------------------------------------------");
        $monitor("%h\t | %h\t",t_A, t_RD);
        end

    initial begin
            t_A = 32'h0000_0000;
        #10 t_A = 32'h0000_0004;
        #20 t_A = 32'h0000_0008;
        end
endmodule