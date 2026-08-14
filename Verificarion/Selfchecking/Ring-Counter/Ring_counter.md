# 4-bit Ring Counter

## 1. Overview

A ring counter is a sequential circuit built using a shift-register structure with feedback.

Unlike a conventional binary counter, which generates binary values such as:

0000 → 0001 → 0010 → 0011 → ...

a 4-bit ring counter circulates a single `1` through the register:

0001 → 0010 → 0100 → 1000 → 0001 → ...

The design implemented here is a **4-bit ring counter with an asynchronous active-high reset**.

---

## 2. Design Specifications

| Specification | Description |
|---|---|
| Counter Type | Ring Counter |
| Width | 4 bits |
| Clock | Positive-edge triggered |
| Reset | Asynchronous, active-high |
| Reset State | `0001` |
| Number of Valid States | 4 |
| Output | 4-bit one-hot pattern |
| HDL | Verilog |
| Simulation | Icarus Verilog + GTKWave |

### Valid State Sequence

The counter follows:

```text
0001
0010
0100
1000
0001
...
