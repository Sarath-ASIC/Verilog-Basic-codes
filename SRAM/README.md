# SRAM RTL Design

A simple **8-bit × 16-location SRAM** designed using Verilog HDL.  
This project is intended as a beginner-level RTL design and verification exercise.

## 1. Project Overview

The design implements a small memory with:

- **16 memory locations**
- **8-bit data width**
- **4-bit address**
- Synchronous write operation
- Asynchronous read operation
- Basic Verilog testbench for functional verification

### Memory Organization

```text
Number of locations : 16
Data width          : 8 bits
Address width       : 4 bits
Total memory        : 16 × 8 = 128 bits
```

The memory can be represented as:

```text
Address       Data
-------       --------
0000          8 bits
0001          8 bits
0010          8 bits
...           ...
1111          8 bits
```

---

## 2. Interface Specification

| Signal | Direction | Width | Description |
|---|---|---:|---|
| `clk` | Input | 1 | Clock signal |
| `we` | Input | 1 | Write enable |
| `address` | Input | 4 | Memory location address |
| `data_in` | Input | 8 | Data to be written |
| `data_out` | Output | 8 | Data read from memory |

### Write Operation

When:

```text
we = 1
```

the SRAM writes `data_in` into the selected memory location on the rising edge of `clk`.

Example:

```text
we      = 1
address = 3
data_in = AA
```

After the rising clock edge:

```text
mem[3] = AA
```

### Read Operation

When:

```text
we = 0
```

the data stored at the selected address appears on `data_out`.

Example:

```text
address = 3
```

If:

```text
mem[3] = AA
```

then:

```text
data_out = AA
```

---

## 3. RTL Implementation

The memory array is declared as:

```verilog
reg [7:0] mem [0:15];
```

This represents:

```text
16 locations × 8 bits
```

The write operation is implemented using a clocked `always` block:

```verilog
always @(posedge clk)
begin
    if (we == 1)
        mem[address] <= data_in;
end
```

The read operation is implemented using a combinational `always` block:

```verilog
always @(*)
begin
    if (we == 0)
        data_out = mem[address];
end
```

---

## 4. Verification

A basic Verilog testbench is included to verify the SRAM functionality.

The testbench performs:

1. Write `8'hAA` to address `3`
2. Read address `3`
3. Write `8'h55` to address `7`
4. Read address `7`
5. Write `8'hF0` to address `10`
6. Read address `10`

Expected results:

```text
Address =  3, Data = AA
Address =  7, Data = 55
Address = 10, Data = F0
```

The current testbench uses `$display` to observe the read results.

---


---

## 5. Current Limitations

This implementation is intentionally simple and has several limitations.

- Only a single write enable signal is used.
- There is no separate read enable.
- There is no reset mechanism.
- No protection against invalid or unknown addresses.
- No byte-enable support.
- No built-in error checking.
- The testbench uses directed tests rather than randomized testing.
- No functional coverage is implemented.
- No SystemVerilog assertions are included.


These limitations are intentional because the project is being developed as a beginner-level RTL exercise.

---

## 6. Future Work
The design can be extended with:

1. Parameterized data width and memory depth.
2. Separate read and write enable signals.
3. Synchronous read operation.
4. Read/write collision handling.
5. Automatic PASS/FAIL checking in the testbench.
6. More comprehensive directed test cases.
7. SystemVerilog assertions.
8. Functional coverage.
9. Constrained-random verification.
10. Synthesis and FPGA implementation.
11. ASIC-oriented SRAM macro integration.

---

## 7. Learning Objectives

This project provides hands-on practice with:

- Verilog memory arrays
- Address decoding concepts
- Read/write operations
- Clocked RTL logic
- Combinational logic
- Testbench development
- Simulation
- Basic RTL verification

The project can serve as a starting point before moving toward more advanced **SystemVerilog, assertions, functional coverage, constrained-random verification, and UVM-based verification**.

