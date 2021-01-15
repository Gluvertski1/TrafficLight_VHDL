#************************************************************
# THIS IS A WIZARD-GENERATED FILE.                           
#
# Version 13.0.1 Build 232 06/12/2013 Service Pack 1 SJ Web Edition
#
#************************************************************

# Copyright (C) 1991-2013 Altera Corporation
# Your use of Altera Corporation's design tools, logic functions 
# and other software and tools, and its AMPP partner logic 
# functions, and any output files from any of the foregoing 
# (including device programming or simulation files), and any 
# associated documentation or information are expressly subject 
# to the terms and conditions of the Altera Program License 
# Subscription Agreement, Altera MegaCore Function License 
# Agreement, or other applicable license agreement, including, 
# without limitation, that your use is for the sole purpose of 
# programming logic devices manufactured by Altera and sold by 
# Altera or its authorized distributors.  Please refer to the 
# applicable agreement for further details.



# Clock constraints
set_time_format -unit ns -decimal_places 3
create_clock -name {clock} -period 10.000 [get_ports {clock}]
#create_clock -name {clock_virtual} -period 10.000 

# creating clock A and virtual clock A

create_clock -name clkA -period 10 [get_ports {clkA}]
create_clock -name clkA_virt -period 10 

# creating clock B and virtual Clock B
create_clock -name clkB -period 5 [get_ports {clkB}]
create_clock -name clkB_virt -period 5 

# Assigning values to timing parameters (in ns). All are outside the FPGA
set CLKAs_max 0.200
set CLKAs_min 0.100

set CLKBs_max 0.100
set CLKBs_min 0.050

set CLKAd_max 0.200
set CLKAd_min 0.100

set CLKBd_max 0.100
set CLKBd_min 0.050

set BDa_max 0.180
set BDa_min 0.120

set BDb_max 0.100
set BDb_min 0.080

set tCOa_max 0.525
set tCOa_min 0.415

set tHb 0.400
set tSUb 0.500

# Input delay is the delay at the FPGA data_in pin due to external device A.
# Assign input delay using external device A circuit timing
# The red clock pulse is the starting point of the circuit delays.

# Assign input delay (ma0 using external device A circuit timing (for vector)
set_input_delay -clock clkA_virt -max [expr $CLKAs_max + $tCOa_max + $BDa_max - $CLKAd_min] [get_ports {Y*}]

# Assign input delay (min) using external device A circuit timing (for vector)
set_input_delay -clock clkA_virt -min [expr $CLKAs_min + $tCOa_min + $BDa_min - $CLKAd_max] [get_ports {Y*}]

# Output delay is the amount (max) the FPGA data_out pin delay must be decreased
# due to the setup timing requiremenbt of external device B. However, it can't be
# decreased too much (min) due to the external device B hold requirement.
# The red clock pulse is the starting point of the circuit delays.

# assign output delay (max) using external device B circuit timing (for vector).
set_output_delay -clock clkB_virt -max [expr $CLKBs_max + $BDb_max + $tSUb - $CLKBd_min] [get_ports {L*}]

# assign output delay (min) using external device B circuit timing (for vector).
set_output_delay -clock clkB_virt -min [expr $CLKBs_min + $BDb_min - $tHb - $CLKBd_max] [get_ports {L*}]


# Automatically constrain PLL and other generated clocks
derive_pll_clocks -create_base_clocks

# Automatically calculate clock uncertainty to jitter and other effects.
derive_clock_uncertainty

# tsu/th constraints

# tco constraints

# tpd constraints

