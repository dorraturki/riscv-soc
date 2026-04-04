onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Controls
add wave -noupdate /tb_regbank/reset
add wave -noupdate /tb_regbank/clk
add wave -noupdate /tb_regbank/enable
add wave -noupdate -divider {Write port}
add wave -noupdate /tb_regbank/wr
add wave -noupdate /tb_regbank/address_in
add wave -noupdate /tb_regbank/data_in
add wave -noupdate -divider {Read port 1}
add wave -noupdate /tb_regbank/address_out1
add wave -noupdate /tb_regbank/data_out1
add wave -noupdate /tb_regbank/data_out1_reference
add wave -noupdate -divider {Read port 2}
add wave -noupdate /tb_regbank/address_out2
add wave -noupdate /tb_regbank/data_out2
add wave -noupdate /tb_regbank/data_out2_reference
add wave -noupdate -divider Assertions
add wave -noupdate /tb_regbank/data_out1_ok
add wave -noupdate /tb_regbank/data_out2_ok
add wave -noupdate /tb_regbank/global_ok
add wave -noupdate -divider Internals
add wave -noupdate /tb_regbank/DUT/reset
add wave -noupdate /tb_regbank/DUT/clk
add wave -noupdate /tb_regbank/DUT/enable
add wave -noupdate /tb_regbank/DUT/wr
add wave -noupdate /tb_regbank/DUT/address_in
add wave -noupdate /tb_regbank/DUT/data_in
add wave -noupdate /tb_regbank/DUT/address_out1
add wave -noupdate /tb_regbank/DUT/data_out1
add wave -noupdate /tb_regbank/DUT/address_out2
add wave -noupdate /tb_regbank/DUT/data_out2
add wave -noupdate /tb_regbank/DUT/tab
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 219
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
WaveRestoreZoom {0 ns} {10500 ns}
