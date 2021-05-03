set_global_assignment -entity "PLL108MHz" -library "lib_PLL108MHz" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "PLL108MHz" -library "lib_PLL108MHz" -name IP_TOOL_VERSION "16.1"
set_global_assignment -entity "PLL108MHz" -library "lib_PLL108MHz" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_PLL108MHz" -name SPD_FILE [file join $::quartus(sip_path) "PLL108MHz.spd"]

set_global_assignment -library "lib_PLL108MHz" -name MISC_FILE [file join $::quartus(sip_path) "PLL108MHz_sim/PLL108MHz.vo"]
