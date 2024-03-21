set_property SRC_FILE_INFO {cfile:f:/Study/FPGA/Project/digit_reco7/digit_reco7.srcs/sources_1/ip/sys_mmcm/sys_mmcm.xdc rfile:../../../digit_reco7.srcs/sources_1/ip/sys_mmcm/sys_mmcm.xdc id:1 order:EARLY scoped_inst:inst} [current_design]
current_instance inst
set_property src_info {type:SCOPED_XDC file:1 line:57 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter [get_clocks -of_objects [get_ports clk_in1]] 0.2
