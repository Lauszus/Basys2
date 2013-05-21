onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /vending_machine_test/uut/Inst_vending_machine_cpu/clk
add wave -noupdate /vending_machine_test/uut/Inst_vending_machine_cpu/reset
add wave -noupdate /vending_machine_test/uut/Inst_vending_machine_cpu/coin2
add wave -noupdate /vending_machine_test/uut/Inst_vending_machine_cpu/coin5
add wave -noupdate /vending_machine_test/uut/Inst_vending_machine_cpu/buy
add wave -noupdate /vending_machine_test/uut/Inst_vending_machine_cpu/price
add wave -noupdate /vending_machine_test/uut/Inst_vending_machine_cpu/sum
add wave -noupdate /vending_machine_test/uut/Inst_vending_machine_cpu/release_can
add wave -noupdate /vending_machine_test/uut/Inst_vending_machine_cpu/alarm
add wave -noupdate /vending_machine_test/uut/Inst_vending_machine_cpu/new_value
add wave -noupdate /vending_machine_test/uut/Inst_vending_machine_cpu/current_state
add wave -noupdate /vending_machine_test/uut/Inst_vending_machine_cpu/next_state
add wave -noupdate /vending_machine_test/uut/Inst_vending_machine_cpu/add_mux
add wave -noupdate /vending_machine_test/uut/Inst_vending_machine_cpu/sum_enable
add wave -noupdate /vending_machine_test/uut/Inst_vending_machine_cpu/output_enable
add wave -noupdate /vending_machine_test/uut/Inst_vending_machine_cpu/negative
add wave -noupdate /vending_machine_test/uut/Inst_vending_machine_cpu/price_val
add wave -noupdate /vending_machine_test/uut/Inst_vending_machine_cpu/sum_val
add wave -noupdate /vending_machine_test/uut/Inst_vending_machine_cpu/add_val
add wave -noupdate /vending_machine_test/uut/Inst_vending_machine_cpu/sum_val_temp
add wave -noupdate /vending_machine_test/uut/Inst_vending_machine_cpu/sum_val_new
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {129 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 400
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {150 ns} {362 ns}
