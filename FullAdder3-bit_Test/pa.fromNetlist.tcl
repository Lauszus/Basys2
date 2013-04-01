
# PlanAhead Launch Script for Post-Synthesis pin planning, created by Project Navigator

create_project -name FullAdder3-bit_Test -dir "C:/.Xilinx/Projects/Kristian/FullAdder3-bit_Test/planAhead_run_2" -part xc3s100ecp132-4
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "C:/.Xilinx/Projects/Kristian/FullAdder3-bit_Test/adder3.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {C:/.Xilinx/Projects/Kristian/FullAdder3-bit_Test} }
set_param project.pinAheadLayout  yes
set_property target_constrs_file "pins.ucf" [current_fileset -constrset]
add_files [list {pins.ucf}] -fileset [get_property constrset [current_run]]
open_netlist_design
