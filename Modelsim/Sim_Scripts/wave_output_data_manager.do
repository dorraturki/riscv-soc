onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Inputs
add wave -noupdate /tb_output_data_manager/inst_str
add wave -noupdate /tb_output_data_manager/inst
add wave -noupdate /tb_output_data_manager/data_in
add wave -noupdate -divider DUT
add wave -noupdate /tb_output_data_manager/DUT/inst
add wave -noupdate /tb_output_data_manager/DUT/funct3
add wave -noupdate /tb_output_data_manager/DUT/data_out
add wave -noupdate -divider {DUT reference}
add wave -noupdate /tb_output_data_manager/DUT_reference/inst
add wave -noupdate /tb_output_data_manager/DUT_reference/funct3
add wave -noupdate /tb_output_data_manager/DUT_reference/data_out
add wave -noupdate -divider Assertions
add wave -noupdate /tb_output_data_manager/OK
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 305
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
WaveRestoreZoom {0 ns} {840 ns}
