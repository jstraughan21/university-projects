## Clock signal
set_property PACKAGE_PIN W5 [get_ports clk]
	set_property IOSTANDARD LVCMOS33 [get_ports clk]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]


## Switches
set_property PACKAGE_PIN V17 [get_ports {reset}]
	set_property IOSTANDARD LVCMOS33 [get_ports {reset}]
set_property PACKAGE_PIN R3 [get_ports {TopHalf}]
	set_property IOSTANDARD LVCMOS33 [get_ports {TopHalf}]
set_property PACKAGE_PIN T2 [get_ports {showInstr}]
	set_property IOSTANDARD LVCMOS33 [get_ports {showInstr}]
set_property PACKAGE_PIN W2 [get_ports {Reg[0]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {Reg[0]}]
set_property PACKAGE_PIN U1 [get_ports {Reg[1]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {Reg[1]}]
set_property PACKAGE_PIN T1 [get_ports {Reg[2]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {Reg[2]}]
set_property PACKAGE_PIN R2 [get_ports {Reg[3]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {Reg[3]}]


##7 segment display
set_property PACKAGE_PIN W7 [get_ports {seg[0]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {seg[0]}]
set_property PACKAGE_PIN W6 [get_ports {seg[1]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {seg[1]}]
set_property PACKAGE_PIN U8 [get_ports {seg[2]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {seg[2]}]
set_property PACKAGE_PIN V8 [get_ports {seg[3]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {seg[3]}]
set_property PACKAGE_PIN U5 [get_ports {seg[4]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {seg[4]}]
set_property PACKAGE_PIN V5 [get_ports {seg[5]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {seg[5]}]
set_property PACKAGE_PIN U7 [get_ports {seg[6]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {seg[6]}]


set_property PACKAGE_PIN U2 [get_ports {adrive[0]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {adrive[0]}]
set_property PACKAGE_PIN U4 [get_ports {adrive[1]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {adrive[1]}]
set_property PACKAGE_PIN V4 [get_ports {adrive[2]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {adrive[2]}]
set_property PACKAGE_PIN W4 [get_ports {adrive[3]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {adrive[3]}]


##Buttons
set_property PACKAGE_PIN U18 [get_ports button]
	set_property IOSTANDARD LVCMOS33 [get_ports button]


#can be used for all designs
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]