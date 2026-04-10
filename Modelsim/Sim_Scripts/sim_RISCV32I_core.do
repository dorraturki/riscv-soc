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

vsim -voptargs=+acc -debugDB RISCV.RISCV32I_core