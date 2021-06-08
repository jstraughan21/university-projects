//----------------------------------------------------------------------------//
//  t_alu.v
//  
//  This is the testbech for the ALU module
//
//----------------------------------------------------------------------------//
`timescale 1ns/100ps

module t_alu;
    wire  [31:0]  t_ALUResult;
    wire  [3:0]   t_ALUFlags;
    reg   [1:0]   t_ALUControl;
    reg   [31:0]  t_SrcA, t_SrcB;

    alu   uut(t_ALUResult, t_ALUFlags, t_ALUControl, t_SrcA, t_SrcB);

    initial begin
        $display("ALUResult\t | SrcA\t\t SrcB\t\t Operation\t");
        $display("---------------------------------------------------------");
        $monitor("%h\t | %h\t %h\t %b",t_ALUResult, t_SrcA, t_SrcB, t_ALUControl);
        end

    initial begin
           t_SrcA = 32'h0000000F;   // Set SrcA
           t_SrcB = 32'h00000000;   // Set SrcB
    #10    t_ALUControl = 2'b00;    // ADD
    #10    t_ALUControl = 2'b01;    // SUB
    #10    t_ALUControl = 2'b10;    // AND
    #10    t_ALUControl = 2'b11;    // ORR
        end
endmodule