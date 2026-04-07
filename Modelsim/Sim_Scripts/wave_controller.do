onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Inputs
add wave -noupdate /tb_controller/C
add wave -noupdate /tb_controller/inst
add wave -noupdate -divider Assertions
add wave -noupdate /tb_controller/OK_global
add wave -noupdate -divider decoded_inst
add wave -noupdate /tb_controller/DUT/decoded_inst
add wave -noupdate /tb_controller/DUT_reference/inst
add wave -noupdate /tb_controller/OK_decoded_inst
add wave -noupdate -divider reg_write
add wave -noupdate /tb_controller/DUT/reg_write
add wave -noupdate /tb_controller/DUT_reference/reg_write
add wave -noupdate /tb_controller/OK_reg_write
add wave -noupdate -divider PCrs1d_select
add wave -noupdate /tb_controller/DUT/PCrs1d_select
add wave -noupdate /tb_controller/DUT_reference/PCrs1d_select
add wave -noupdate /tb_controller/OK_PCrs1d_select
add wave -noupdate -divider imm4BJI_select
add wave -noupdate /tb_controller/DUT/imm4BJI_select
add wave -noupdate /tb_controller/DUT_reference/imm4BJI_select
add wave -noupdate /tb_controller/OK_imm4BJI_select
add wave -noupdate -divider A_select
add wave -noupdate /tb_controller/DUT/A_select
add wave -noupdate /tb_controller/DUT_reference/A_select
add wave -noupdate /tb_controller/OK_A_select
add wave -noupdate -divider B_select
add wave -noupdate /tb_controller/DUT/B_select
add wave -noupdate /tb_controller/DUT_reference/B_select
add wave -noupdate /tb_controller/OK_B_select
add wave -noupdate -divider op
add wave -noupdate /tb_controller/DUT/op
add wave -noupdate /tb_controller/DUT_reference/op
add wave -noupdate /tb_controller/OK_op
add wave -noupdate -divider data_write
add wave -noupdate /tb_controller/DUT/data_write
add wave -noupdate /tb_controller/DUT_reference/data_write
add wave -noupdate /tb_controller/OK_data_write
add wave -noupdate -divider data_read
add wave -noupdate /tb_controller/DUT/data_read
add wave -noupdate /tb_controller/DUT_reference/data_read
add wave -noupdate /tb_controller/OK_data_read
add wave -noupdate -divider rdd_select
add wave -noupdate /tb_controller/DUT/rdd_select
add wave -noupdate /tb_controller/DUT_reference/rdd_select
add wave -noupdate /tb_controller/OK_rdd_select
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 279
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
WaveRestoreZoom {0 ns} {4200 ns}
