quit -sim

if {[file exists RISCV] == 1} {
	file delete -force RISCV
}

vlib RISCV		 

if {[file exists SOC] == 1} {
	file delete -force SOC
}

vlib SOC		 


if {[file exists work] == 1} {
	file delete -force work
}

vlib work		 


project compileall


vsim -voptargs=+acc -debugDB soc.tb_soc


log -r /*


do wave_soc1.do

run 1000 ns