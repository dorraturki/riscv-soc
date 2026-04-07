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

vsim -voptargs=+acc -debugDB riscv.tb_controller

do wave_controller.do

run 4 us