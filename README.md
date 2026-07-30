# Verilog-Basic-codes
# Basic Verilog Code

This repository contains a collection of **Verilog HDL** designs and their corresponding **testbenches** for learning and practicing digital design concepts.

## Contents

* **Logic Gates**

  * AND, OR, NOT, NAND, NOR, XOR, XNOR
* **Combinational Circuits**

  * Multiplexers (MUX)
  * Demultiplexers (DEMUX)
  * Encoders
  * Decoders
  * Adders
  * Subtractors
  * Comparators
  * Other basic combinational circuits
* **Sequential Circuits**

  * Latches
  * Flip-Flops
  * Counters
  * Shift Registers
  * Other sequential logic designs
* **Advanced Digital Circuits**

  * Advanced Verilog design examples will be added in future updates.

## Tools Used

* **Icarus Verilog** – Compilation and simulation
* **GTKWave** – Waveform visualization
## How to Run

### 1. Compile the Verilog Design and Testbench

```bash
iverilog -o sim.out design.v tb_design.v
```

### 2. Run the Simulation

```bash
vvp sim.out
```

### 3. View the Waveform

```bash
gtkwave dump.vcd
```

> **Note:** Ensure that your testbench includes waveform dumping:

```verilog
initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_design);
end
```

Replace:

* `design.v` with your design file name.
* `tb_design.v` with your testbench file name.
* `tb_design` with the name of your testbench module.

This repository is intended for students, beginners, and anyone interested in learning Verilog HDL through simple, well-organized examples with testbenches.

`Author`  : SARATH K C
