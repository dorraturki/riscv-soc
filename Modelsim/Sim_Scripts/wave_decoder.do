onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Inputs
add wave -noupdate /tb_decoder/inst_str
add wave -noupdate /tb_decoder/inst
add wave -noupdate -divider Assertions
add wave -noupdate /tb_decoder/OK_global
add wave -noupdate -divider rs1a
add wave -noupdate -radix unsigned /tb_decoder/rs1a
add wave -noupdate /tb_decoder/rs1a_reference
add wave -noupdate /tb_decoder/OK_rs1a
add wave -noupdate -divider rs2a
add wave -noupdate -radix unsigned /tb_decoder/rs2a
add wave -noupdate /tb_decoder/rs2a_reference
add wave -noupdate /tb_decoder/OK_rs2a
add wave -noupdate -divider rda
add wave -noupdate -radix unsigned /tb_decoder/rda
add wave -noupdate /tb_decoder/rda_reference
add wave -noupdate /tb_decoder/OK_rda
add wave -noupdate -divider immI
add wave -noupdate -radix decimal /tb_decoder/immI
add wave -noupdate -radix decimal /tb_decoder/immI_reference
add wave -noupdate /tb_decoder/OK_immI
add wave -noupdate -divider immS
add wave -noupdate -radix decimal /tb_decoder/immS
add wave -noupdate -radix decimal /tb_decoder/immS_reference
add wave -noupdate /tb_decoder/OK_immS
add wave -noupdate -divider immB
add wave -noupdate -radix decimal /tb_decoder/immB
add wave -noupdate -radix decimal /tb_decoder/immB_reference
add wave -noupdate /tb_decoder/OK_immB
add wave -noupdate -divider immU
add wave -noupdate -radix unsigned /tb_decoder/immU
add wave -noupdate -radix unsigned /tb_decoder/immU_reference
add wave -noupdate /tb_decoder/OK_immU
add wave -noupdate -divider immJ
add wave -noupdate -radix decimal /tb_decoder/immJ
add wave -noupdate /tb_decoder/OK_immJ
add wave -noupdate -radix decimal /tb_decoder/immJ_reference
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 209
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
WaveRestoreZoom {0 ns} {1050 ns}
