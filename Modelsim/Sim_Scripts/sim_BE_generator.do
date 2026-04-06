#Termine une éventuelle simulation précédente 
quit -sim

#Supprime le dossier de la librairie RISCV
if {[file exists RISCV] == 1} {
	file delete -force RISCV
}
#Recrée la librairie RISCV
vlib RISCV		 

#Supprime le dossier de la librairie work
if {[file exists work] == 1} {
	file delete -force work
}
#Recrée la librairie work
vlib work		 

project compileall

vsim -voptargs=+acc -debugDB RISCV.tb_BE_generator

do wave_BE_generator.do

run 2200 ns