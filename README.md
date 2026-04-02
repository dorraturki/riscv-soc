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
