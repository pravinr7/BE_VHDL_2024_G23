set_global_assignment -entity "anemoVER_1_0" -library "lib_anemoVER_1_0" -name IP_TOOL_NAME "Qsys"
set_global_assignment -entity "anemoVER_1_0" -library "lib_anemoVER_1_0" -name IP_TOOL_VERSION "18.1"
set_global_assignment -entity "anemoVER_1_0" -library "lib_anemoVER_1_0" -name IP_TOOL_ENV "Qsys"
set_global_assignment -library "lib_anemoVER_1_0" -name SPD_FILE [file join $::quartus(sip_path) "../anemoVER_1_0.spd"]
set_global_assignment -library "lib_anemoVER_1_0" -name MISC_FILE [file join $::quartus(sip_path) "../../anemoVER_1_0.qsys"]

set_global_assignment -library "lib_anemoVER_1_0" -name MISC_FILE [file join $::quartus(sip_path) "anemoVER_1_0.vhd"]
set_global_assignment -library "lib_anemoVER_1_0" -name MISC_FILE [file join $::quartus(sip_path) "submodules/anemoVER_1_0_RAM.hex"]
set_global_assignment -library "lib_anemoVER_1_0" -name MISC_FILE [file join $::quartus(sip_path) "submodules/anemoVER_1_0_RAM.vhd"]
set_global_assignment -library "lib_anemoVER_1_0" -name MISC_FILE [file join $::quartus(sip_path) "submodules/anemoVER_1_0_DEBUG.vhd"]
set_global_assignment -library "lib_anemoVER_1_0" -name MISC_FILE [file join $::quartus(sip_path) "submodules/anemoVER_1_0_CPU.v"]
