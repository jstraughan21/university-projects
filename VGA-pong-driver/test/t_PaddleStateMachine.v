`timescale 1ns/100ps
module t_VGAStateMachine;
	wire t_moveUp, t_moveDown;
    wire t_delay;
    reg  t_SW, t_done;
    reg  t_CLK_100MHz, t_Reset;
	
	PaddleStateMachine	uut(t_moveUp, t_moveDown, t_delay, t_SW, t_done, t_CLK_100MHz, t_Reset);
	
	initial #1000 $finish;
	
	initial begin
		t_CLK_100MHz = 0;
		forever #5 t_CLK_100MHz = ~t_CLK_100MHz;
		end
		
	initial begin
		$dumpfile("wavedata.vcd");
		$dumpvars(0, t_PaddleStateMachine);
		end
		
	initial begin
			  t_SW = 0;
              t_done =0;
			  t_Reset = 0;
		#10   t_Reset = 1;
		#10   t_Reset = 0;
		#100  t_done = 1;
		#5    t_done = 0;
              t_SW = 1;
        #100  t_done = 1;
        #5    t_done = 0;
		end
endmodule