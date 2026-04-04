#Termine une éventuelle simulation précédente 
quit -sim

#Supprime le dossier de la librairie RISCV
if {[file exists RISCV] == 1} {
	file delete -force RISCV
}
vlib RISCV		 

#Supprime le dossier de la librairie work
if {[file exists work] == 1} {
	file delete -force work
}
vlib work		 

#Compile tous les fixhiers du projet
project compileall

#Charge le testbench dan sle simulateur
vsim -voptargs=+acc -debugDB RISCV.tb_regbank

#Mets en forme les chronogrammes
do wave_RegBank.do

#Simule pour une certaine durée
run 10 us