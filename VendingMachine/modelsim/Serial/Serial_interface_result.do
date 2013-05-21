onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /serial_interface_test/uut/clk_50
add wave -noupdate /serial_interface_test/uut/reset
add wave -noupdate /serial_interface_test/uut/digit0
add wave -noupdate /serial_interface_test/uut/digit1
add wave -noupdate /serial_interface_test/uut/tx
add wave -noupdate /serial_interface_test/uut/new_value
add wave -noupdate /serial_interface_test/uut/current_state
add wave -noupdate /serial_interface_test/uut/serial_enable
add wave -noupdate -expand /serial_interface_test/uut/digit
add wave -noupdate /serial_interface_test/uut/digit_enable
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 249
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
WaveRestoreZoom {0 ns} {240375 ns}
