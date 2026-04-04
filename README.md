# RISC-V RV32I SoC — Single-Cycle Implementation in VHDL
 
A complete System-on-Chip built around a single-cycle **RISC-V RV32I** processor, described in VHDL and simulated with **QuestaSim**.


## Overview
 
This project implements a fully functional SoC featuring:
 
- A **single-cycle RISC-V RV32I** CPU core
- A **AXI Bus architecture** with separate instruction and data buses
- Peripheral components: ROM, RAM, UART, GPIO, and a coprocessor (COPRO)
- Full RTL description in **VHDL**, simulatable out of the box with QuestaSim

### System Architecture

![System Architecture](/Diagrams/System_architecture.png)

## Simulation
 
### Running the simulation
 
In `/Modelsim/Sim Scripts/`, there is `sim_module.do` scripts compiles all sources and starts the simulation automatically for each module. 
 
### Reference library (validation)
 
The `Modelsim/RISCV_reference/` directory contains a pre-compiled RISC-V reference library provided by a professor. It can be added to the simulation to cross-validate your design's outputs against a known-good implementation.
 
To include it, map it in ModelSim before running:
 
```tcl
vmap RISCV_reference modelsim/RISCV_reference
``` 
### Simulation results
 
Screenshots of the simulation waveforms are available in the [`Simulation/`](Simulation/) folder, showing expected signal behaviour for key test cases.
