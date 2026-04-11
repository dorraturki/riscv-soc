onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider System
add wave -noupdate /tb_soc/DUT/reset
add wave -noupdate /tb_soc/DUT/clk
add wave -noupdate /tb_soc/DUT/B0_bus_error
add wave -noupdate /tb_soc/DUT/B1_bus_error
add wave -noupdate -divider {CPU instructions}
add wave -noupdate /tb_soc/DUT/CPU/decoded_inst
add wave -noupdate /tb_soc/DUT/CPU_IAddr
add wave -noupdate /tb_soc/DUT/CPU_IData
add wave -noupdate -divider {CPU data}
add wave -noupdate -radix binary /tb_soc/DUT/CPU_DBE
add wave -noupdate /tb_soc/DUT/CPU_DAddr
add wave -noupdate /tb_soc/DUT/CPU_DRead
add wave -noupdate /tb_soc/DUT/CPU_DWrite
add wave -noupdate /tb_soc/DUT/CPU_DData_out
add wave -noupdate /tb_soc/DUT/CPU_DData_in
add wave -noupdate -divider {I0 : ROM}
add wave -noupdate /tb_soc/DUT/I0_IAddr
add wave -noupdate /tb_soc/DUT/I0_IData
add wave -noupdate -divider {D0 : ROM}
add wave -noupdate /tb_soc/DUT/D0_DAddr
add wave -noupdate /tb_soc/DUT/D0_DData_rd
add wave -noupdate -divider {D1 : RAM}
add wave -noupdate -radix binary -childformat {{/tb_soc/DUT/D1_DBE(3) -radix binary} {/tb_soc/DUT/D1_DBE(2) -radix binary} {/tb_soc/DUT/D1_DBE(1) -radix binary} {/tb_soc/DUT/D1_DBE(0) -radix binary}} -subitemconfig {/tb_soc/DUT/D1_DBE(3) {-radix binary} /tb_soc/DUT/D1_DBE(2) {-radix binary} /tb_soc/DUT/D1_DBE(1) {-radix binary} /tb_soc/DUT/D1_DBE(0) {-radix binary}} /tb_soc/DUT/D1_DBE
add wave -noupdate /tb_soc/DUT/D1_DAddr
add wave -noupdate /tb_soc/DUT/D1_DRead
add wave -noupdate /tb_soc/DUT/D1_DWrite
add wave -noupdate /tb_soc/DUT/D1_DData_wr
add wave -noupdate /tb_soc/DUT/D1_DData_rd
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
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
