//----------------------------------------------------------------------------//
//  TopLevel.v
//  
//  This is the top level module which combines all modules and creates the
//  interconnecting blocks
//
//----------------------------------------------------------------------------//

module TopLevel(seg, adrive, Reg, TopHalf, button, showInstr, clk, reset);
	output [0:6]    seg;
	output [3:0]    adrive;
	input  [3:0]    Reg;
	input           TopHalf, button, showInstr, clk, reset;

	wire   [31:0]   RegVal, Instr;
	wire   [3:0]    val;
	wire   [3:0]    A, B, C, D;
	reg    [3:0]    Aout, Bout, Cout, Dout;
	wire   button_db;

	parameter blank = 4'b0000;

	SingleCycleProcessor    m1(RegVal, Instr, Reg, button_db, reset);
	Mux4Machine             m2(val, adrive, A, B, C, D, clk, reset, blank);
	Hex27Seg                m3(seg, val);
	debounce                m4(button_db, button, clk, reset);

	always @(RegVal, Instr, TopHalf, showInstr) begin
		case(showInstr)
			1'b1:   begin   Aout = TopHalf ? Instr[31:28] : Instr[15:12];
							Bout = TopHalf ? Instr[27:24] : Instr[11:8];
							Cout = TopHalf ? Instr[23:20] : Instr[7:4];
							Dout = TopHalf ? Instr[19:16] : Instr[3:0];
					end
			1'b0:   begin   Aout = TopHalf ? RegVal[31:28] : RegVal[15:12];
							Bout = TopHalf ? RegVal[27:24] : RegVal[11:8];
							Cout = TopHalf ? RegVal[23:20] : RegVal[7:4];
							Dout = TopHalf ? RegVal[19:16] : RegVal[3:0];
					end
			default: begin  Aout = 4'b0000;
							Bout = 4'b0000;
							Cout = 4'b0000;
							Dout = 4'b0000;
					end
		endcase
    end

	assign  A = Aout;
	assign  B = Bout;
	assign  C = Cout;
	assign  D = Dout;
    
endmodule
