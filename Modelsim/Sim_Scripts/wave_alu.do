onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_alu/DUT/op
add wave -noupdate -divider {Signed values}
add wave -noupdate -radix decimal /tb_alu/DUT/a
add wave -noupdate -radix decimal /tb_alu/DUT/b
add wave -noupdate -radix decimal /tb_alu/DUT/c
add wave -noupdate -divider {Hexa values}
add wave -noupdate /tb_alu/DUT/a
add wave -noupdate /tb_alu/DUT/b
add wave -noupdate /tb_alu/DUT/c
add wave -noupdate -divider {Unsigned values}
add wave -noupdate -radix unsigned /tb_alu/DUT/a
add wave -noupdate -radix unsigned /tb_alu/DUT/b
add wave -noupdate -radix unsigned /tb_alu/DUT/c
add wave -noupdate -divider Assertions
add wave -noupdate /tb_alu/c_ok
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 89
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
WaveRestoreZoom {0 ns} {2520 ns}
