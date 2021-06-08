## Clock signal (Generated on-board the Artix-7) 10 ns period (100 MHz)
set_property PACKAGE_PIN W5 [get_ports clk]							
	set_property IOSTANDARD LVCMOS33 [get_ports clk]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

## LEDs
# led0, to signify when it's okay to press Go button
set_property PACKAGE_PIN U16 [get_ports {Ready2Go}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {Ready2Go}] 
	
##7 segment display
set_property PACKAGE_PIN W7 [get_ports {Leds[0]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {Leds[0]}]
set_property PACKAGE_PIN W6 [get_ports {Leds[1]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {Leds[1]}]
set_property PACKAGE_PIN U8 [get_ports {Leds[2]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {Leds[2]}]
set_property PACKAGE_PIN V8 [get_ports {Leds[3]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {Leds[3]}]
set_property PACKAGE_PIN U5 [get_ports {Leds[4]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {Leds[4]}]
set_property PACKAGE_PIN V5 [get_ports {Leds[5]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {Leds[5]}]
set_property PACKAGE_PIN U7 [get_ports {Leds[6]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {Leds[6]}]

set_property PACKAGE_PIN U2 [get_ports {adrive[0]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {adrive[0]}]
set_property PACKAGE_PIN U4 [get_ports {adrive[1]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {adrive[1]}]
set_property PACKAGE_PIN V4 [get_ports {adrive[2]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {adrive[2]}]
set_property PACKAGE_PIN W4 [get_ports {adrive[3]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {adrive[3]}]
 

##Buttons
set_property PACKAGE_PIN U18 [get_ports Go]						
	set_property IOSTANDARD LVCMOS33 [get_ports Go]
set_property PACKAGE_PIN T18 [get_ports Stop]						
	set_property IOSTANDARD LVCMOS33 [get_ports Stop]
set_property PACKAGE_PIN W19 [get_ports Clr]						
	set_property IOSTANDARD LVCMOS33 [get_ports Clr]
set_property PACKAGE_PIN T17 [get_ports reset]						
	set_property IOSTANDARD LVCMOS33 [get_ports reset]
 
 
###Pmod Header JA
##Sch name = JA1
# this is the data being sent to the LED strip
set_property PACKAGE_PIN J1 [get_ports {dataOut}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {dataOut}]
	
	