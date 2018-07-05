
set PERIOD  6
set CLOCK_NAME clk
#set TRANSITION 0.53
set TRANSITION 0.2
set UNCERTAINTY 0.3

create_clock -period $PERIOD -name $CLOCK_NAME [get_ports $CLOCK_NAME]

set_clock_uncertainty -setup $UNCERTAINTY [get_clocks $CLOCK_NAME]
set_clock_transition -rise $TRANSITION [get_clocks $CLOCK_NAME]
set_clock_transition -fall $TRANSITION [get_clocks $CLOCK_NAME]

set_max_area 0  
