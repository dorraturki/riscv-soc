quit -sim

if {[file exists RISCV] == 1} {
	file delete -force RISCV
}
vlib RISCV		 

if {[file exists work] == 1} {
	file delete -force work
}
vlib work		 

project compileall

vsim -voptargs=+acc -debugDB RISCV.tb_alu

do wave_alu.do

run 2400 ns