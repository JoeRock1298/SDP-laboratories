set_global_assignment -entity "pll_ltm" -library "lib_pll_ltm" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "pll_ltm" -library "lib_pll_ltm" -name IP_TOOL_VERSION "17.1"
set_global_assignment -entity "pll_ltm" -library "lib_pll_ltm" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_pll_ltm" -name SPD_FILE [file join $::quartus(sip_path) "pll_ltm.spd"]

set_global_assignment -library "lib_pll_ltm" -name MISC_FILE [file join $::quartus(sip_path) "pll_ltm_sim/pll_ltm.vo"]
