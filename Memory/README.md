# 8×8 Memory Design in Verilog

## Overview

This project implements a simple **8-location × 8-bit memory** using Verilog.

The objective of this design is to understand how memory storage is represented and accessed in RTL.

The memory supports:

- Sequential/synchronous write operation
- Asynchronous read operation
- Independent access to all 8 memory locations
- Address-based memory selection

The design is intentionally kept simple to focus on the fundamental RTL concepts behind memory implementation.

---

# 1. Memory Specification

| Parameter | Value |
|---|---|
| Number of memory locations | 8 |
| Data width | 8 bits |
| Address width | 3 bits |
| Write type | Synchronous |
| Read type | Asynchronous |
| Clock | Required for write |
| Write enable | Required for writing |

The memory can be represented as:

```text
                 8 × 8 MEMORY

        Address          Data

           0       →    8 bits
           1       →    8 bits
           2       →    8 bits
           3       →    8 bits
           4       →    8 bits
           5       →    8 bits
           6       →    8 bits
           7       →    8 bits
```

There are **8 individual memory locations**, and each location can store an **8-bit data word**.

---

# 2. Design Architecture

The memory interface consists of the following signals:

```text
                    +----------------------+
                    |                      |
      clk --------->|                      |
                    |                      |
   wr_en ---------->|       MEMORY         |
                    |                      |
    addr ---------->|       8 × 8          |------> data_out
                    |                      |
 data_in ---------->|                      |
                    |                      |
                    +----------------------+
```

### Input Signals

| Signal | Width | Description |
|---|---:|---|
| `clk` | 1 bit | Clock used for synchronous writing |
| `wr_en` | 1 bit | Enables the write operation |
| `addr` | 3 bits | Selects one of the 8 memory locations |
| `data_in` | 8 bits | Data to be written |

### Output Signal

| Signal | Width | Description |
|---|---:|---|
| `data_out` | 8 bits | Data stored at the selected address |

---

# 3. Address Calculation

The memory contains 8 locations.

Therefore, the number of address bits required is:

```text
Number of address bits = log₂(Number of locations)

                         = log₂(8)

                         = 3 bits
```

A 3-bit address can represent:

```text
Binary Address       Decimal Location

000                  mem[0]
001                  mem[1]
010                  mem[2]
011                  mem[3]
100                  mem[4]
101                  mem[5]
110                  mem[6]
111                  mem[7]
```

Therefore, the address signal is declared as:

```verilog
input wire [2:0] addr;
```

Using a 4-bit address for this 8-location memory would allow values from `0` to `15`, while the memory only contains locations `0` to `7`.

---

# 4. RTL Design

```verilog
module memory_1_dimension (

    input wire clk,
    input wire [7:0] data_in,
    input wire wr_en,
    input wire [2:0] addr,

    output wire [7:0] data_out
);

    // Memory declaration
    reg [7:0] mem [0:7];


    // Write operation
    always @(posedge clk) begin

        if (wr_en) begin

            mem[addr] <= data_in;

        end

    end


    // Read operation
    assign data_out = mem[addr];

endmodule
```

---

# 5. Memory Declaration — Design Perspective

The most important part of the design is:

```verilog
reg [7:0] mem [0:7];
```

This declaration creates the storage structure.

It can be divided into two parts:

```text
reg [7:0]       mem [0:7]
    │               │
    │               └── Number of memory locations
    │
    └── Width of each memory location
```

## Data Width

```verilog
[7:0]
```

means every memory location stores 8 bits.

For example:

```text
mem[0] = 8'b10101010
mem[1] = 8'b11001100
mem[2] = 8'b00001111
```

Each individual location is an 8-bit word.

---

## Memory Depth

```verilog
mem [0:7]
```

means there are 8 locations.

The complete memory can therefore be visualized as:

```text
               MEMORY ARRAY

        +------------------+
mem[0]  | D7 D6 D5 ... D0  |
        +------------------+
mem[1]  | D7 D6 D5 ... D0  |
        +------------------+
mem[2]  | D7 D6 D5 ... D0  |
        +------------------+
mem[3]  | D7 D6 D5 ... D0  |
        +------------------+
mem[4]  | D7 D6 D5 ... D0  |
        +------------------+
mem[5]  | D7 D6 D5 ... D0  |
        +------------------+
mem[6]  | D7 D6 D5 ... D0  |
        +------------------+
mem[7]  | D7 D6 D5 ... D0  |
        +------------------+
```

This declaration is the RTL representation of an **8 × 8 memory**.

---

# 6. Write Operation — Design Perspective

The write logic is:

```verilog
always @(posedge clk) begin

    if (wr_en) begin

        mem[addr] <= data_in;

    end

end
```

The write operation occurs only on the rising edge of the clock.

```text
Clock

        ┌───────┐       ┌───────┐
────────┘       └───────┘       └────
        ↑
        |
     Write occurs here
```

At every rising edge:

1. The memory checks `wr_en`.
2. If `wr_en = 1`, a write operation occurs.
3. The address selects the memory location.
4. `data_in` is stored in that selected location.

The RTL statement:

```verilog
mem[addr] <= data_in;
```

can be understood as:

> Store the value present at `data_in` into the memory location selected by `addr`.

---

## Write Example

Suppose:

```text
wr_en   = 1
addr    = 3
data_in = 8'b10101010
```

At the next rising edge of `clk`:

```verilog
mem[3] <= 8'b10101010;
```

The memory becomes:

```text
Address          Data

0                --------
1                --------
2                --------
3                10101010   ← Written data
4                --------
5                --------
6                --------
7                --------
```

---

# 7. Why `wr_en` Is Required

The write enable controls whether the memory is allowed to change.

```text
wr_en = 1
    │
    └── Write data into memory
```

```text
wr_en = 0
    │
    └── Do not modify memory
```

The design does not require an `else` statement.

```verilog
always @(posedge clk) begin

    if (wr_en) begin

        mem[addr] <= data_in;

    end

end
```

If `wr_en = 0`, no assignment occurs.

Therefore, the memory automatically retains its previously stored value.

Example:

```text
Before clock edge:

mem[3] = 10101010
wr_en  = 0
```

After the clock edge:

```text
mem[3] = 10101010
```

The stored value remains unchanged.

---

# 8. Read Operation — Design Perspective

The read operation is:

```verilog
assign data_out = mem[addr];
```

This is a continuous assignment.

The address continuously selects a memory location.

```text
addr
 │
 ▼
+----------------+
| Memory Decoder |
+----------------+
         │
         ▼
   Selected Location
         │
         ▼
     data_out
```

For example:

```text
addr = 3
```

causes:

```verilog
data_out = mem[3];
```

If:

```text
mem[3] = 10101010
```

then:

```text
data_out = 10101010
```

---

# 9. Asynchronous Read

The read logic:

```verilog
assign data_out = mem[addr];
```

does not depend on the clock.

Therefore, when the address changes:

```text
addr changes
    ↓
Selected memory location changes
    ↓
data_out changes
```

No clock edge is required.

This type of read is called:

> **Asynchronous Read**

---

# 10. Complete Memory Behavior

The complete operation can be summarized as:

## Write

```text
wr_en = 1
      │
      ▼
Clock Rising Edge
      │
      ▼
Select Location Using addr
      │
      ▼
Store data_in
```

## Read

```text
addr
 │
 ▼
Select Memory Location
 │
 ▼
Output Stored Data
 │
 ▼
data_out
```

---

# 11. Timing Behavior

This design has two different timing behaviors.

```text
WRITE → Synchronous

READ  → Asynchronous
```

### Write Timing

```text
wr_en = 1
data_in valid
addr valid

       ↓

   Rising Edge of clk

       ↓

Memory is updated
```

### Read Timing

```text
addr changes

       ↓

Memory location is selected

       ↓

data_out changes
```

---

# 12. Testbench

The testbench performs the following sequence:

```text
START
  │
  ▼
Write Address 0
  │
  ▼
Write Address 1
  │
  ▼
Write Address 2
  │
  ▼
...
  │
  ▼
Write Address 7
  │
  ▼
Wait for 2 Clock Cycles
  │
  ▼
Read Address 0
  │
  ▼
Read Address 1
  │
  ▼
Read Address 2
  │
  ▼
...
  │
  ▼
Read Address 7
  │
  ▼
END
```

---

## Testbench Code

```verilog
`timescale 1ns/1ps

module memory_1_dimension_tb;

    reg clk;
    reg [7:0] data_in;
    reg wr_en;
    reg [2:0] addr;

    wire [7:0] data_out;

    integer i;


    // DUT Instantiation
    memory_1_dimension dut (

        .clk(clk),
        .data_in(data_in),
        .wr_en(wr_en),
        .addr(addr),
        .data_out(data_out)

    );


    // Clock Generation
    initial begin

        clk = 0;

        forever #5 clk = ~clk;

    end


    // Main Test Sequence
    initial begin

        // Initial values
        data_in = 8'd0;
        wr_en   = 0;
        addr    = 3'd0;


        // Write to all memory locations
        wr_en = 1;

        for (i = 0; i < 8; i = i + 1) begin

            addr    = i;
            data_in = i + 10;

            @(posedge clk);

        end


        // Disable writing
        wr_en = 0;


        // Wait for 2 clock cycles
        repeat (2) @(posedge clk);


        // Read all memory locations
        for (i = 0; i < 8; i = i + 1) begin

            addr = i;

            #1;

            $display(
                "READ: Address = %0d | Data = %0d",
                addr,
                data_out
            );

            @(posedge clk);

        end


        $finish;

    end

endmodule
```

---

# 13. Expected Memory Contents

After the write sequence:

```text
Address          Data

0                10
1                11
2                12
3                13
4                14
5                15
6                16
7                17
```

During the read sequence:

```text
Address 0 → Data 10
Address 1 → Data 11
Address 2 → Data 12
Address 3 → Data 13
Address 4 → Data 14
Address 5 → Data 15
Address 6 → Data 16
Address 7 → Data 17
```

---

# Key RTL Learning Points

This project demonstrates several fundamental RTL design concepts:

### Memory declaration

```verilog
reg [7:0] mem [0:7];
```

### Address-based memory access

```verilog
mem[addr]
```

### Clocked sequential logic

```verilog
always @(posedge clk)
```

### Write enable control

```verilog
if (wr_en)
```

### Non-blocking assignment for sequential logic

```verilog
<=
```

### Continuous combinational read

```verilog
assign data_out = mem[addr];
```

---

# Conclusion

This project implements a basic **8 × 8 RTL memory**.

The design separates memory functionality into two fundamental operations:

```text
WRITE:
Clock Edge + Write Enable + Address + Input Data
                    │
                    ▼
             Memory Updated
```

```text
READ:
Address
   │
   ▼
Memory Location Selected
   │
   ▼
Stored Data Appears at Output
```

The most important concept is that the memory array:

```verilog
reg [7:0] mem [0:7];
```

represents the **storage structure**, while the surrounding RTL defines **when data is written and how stored data is accessed**.

This design serves as a foundation for more advanced RTL structures such as:

- Synchronous-read memories
- Register files
- FIFO buffers
- Cache data arrays
- Tag memories
- RAM controllers
- Memory subsystems
