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

#Charge le testbench dan sle simulateur
vsim -voptargs=+acc -debugDB RISCV.tb_regbank

do wave_RegBank.do

run 10 us