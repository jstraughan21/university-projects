`timescale 1ns/100ps
module t_delayStateMachine;
	wire t_done;
    reg  t_delay;
    reg  t_CLK_100MHz, t_Reset;

	delayStateMachine	uut(t_done, t_delay, t_CLK_100MHz, t_Reset);
	
	initial #1000 $finish;
	
	initial begin
		t_CLK_100MHz = 0;
		forever #5 t_CLK_100MHz = ~t_CLK_100MHz;
		end
		
	initial begin
		$dumpfile("wavedata.vcd");
		$dumpvars(0, t_delayStateMachine);
		end
		
	initial begin
              t_delay = 0;
			  t_Reset = 0;
		#10   t_Reset = 1;
		#10   t_Reset = 0;
        #20   t_delay = 1;
        #55   t_delay = 0;
		#40	  t_delay = 1;
		#75   t_delay = 0;
		end
endmodule