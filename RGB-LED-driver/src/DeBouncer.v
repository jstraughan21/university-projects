//----------------------------------------------------------------------------//
//  debounce.v
//  
//  This module sychronizes and debounces an input. Using two flip-flops and a 
//	counter
//
//----------------------------------------------------------------------------//

module DeBouncer (out, in , clk, reset);
	output reg out;
	input in, clk, reset;
	
	reg sync_0, sync_1;
	reg [22:0] Count, nCount;
	
	parameter WAIT = 23'd4999999;
	
	always @(posedge clk) begin
		if (reset) sync_0 <= 0;
		else sync_0 <= in;
		end
		
	always @(posedge clk) begin
		if (reset) sync_1 <= 0;
		else sync_1 <= sync_0;
		end
		
	always @(posedge clk) begin
		if (reset) Count <= 23'd0;
		else if (sync_0 ^ sync_1) Count <= 23'd0;
		else Count <= nCount;
		end
		
	always @(Count) begin
		nCount = Count + 1;
		end
		
	always @(posedge clk) begin
		if (reset) out <= 0;
		else out <= (Count == WAIT) ? sync_1 : out;
		end
endmodule