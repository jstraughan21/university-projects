`timescale 1ns/100ps
module t_position;
	wire [9:0] t_Hmin, t_Hmax, t_Vmin, t_Vmax;
    reg        t_moveUp, t_moveDown;
    reg        t_CLK_100MHz, t_Reset;
	
	position	uut(t_Hmin, t_Hmax, t_Vmin, t_Vmax, t_moveUp, t_moveDown, t_CLK_100MHz, t_Reset);
	
	initial #1000 $finish;
	
	initial begin
		t_CLK_100MHz = 0;
		forever #5 t_CLK_100MHz = ~t_CLK_100MHz;
		end
		
	initial begin
		$dumpfile("wavedata.vcd");
		$dumpvars(0, t_position);
		end
		
	initial begin
              t_moveUp = 0;
              t_moveDown = 0;
			  t_Reset = 0;
		#10   t_Reset = 1;
		#10   t_Reset = 0;
        #20   t_moveUp = 1;
        #100  t_moveUp = 0;
              t_moveDown = 1;
        #200  t_moveDown = 0;
		end
endmodule