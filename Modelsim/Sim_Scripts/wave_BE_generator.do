onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Inputs
add wave -noupdate /tb_be_generator/inst_str
add wave -noupdate /tb_be_generator/inst
add wave -noupdate /tb_be_generator/address
add wave -noupdate -divider {DUT outputs}
add wave -noupdate /tb_be_generator/BE
add wave -noupdate -divider {DUT_reference outputs}
add wave -noupdate /tb_be_generator/BE_reference
add wave -noupdate -divider Assertions
add wave -noupdate /tb_be_generator/OK
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 261
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
WaveRestoreZoom {0 ns} {2310 ns}
