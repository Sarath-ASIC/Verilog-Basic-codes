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



# Verification Reason

1. The purpose of verification is to prove that the 4-bit ring counter follows its specified sequence correctly.
2. The valid sequence is `0001 → 0010 → 0100 → 1000 → 0001`.
3. Reset must initialize the DUT to `0001`.
4. Each positive clock edge must advance the `1` to the next position.
5. Since there are four states, at least **4 active clock cycles** are required for one complete rotation.
6. Three cycles are insufficient because the wrap-around transition would not be verified.
7. The `1000 → 0001` transition confirms that the ring feedback operates correctly.
8. The counter must remain one-hot during normal operation.
9. The testbench therefore verifies 20 active clock cycles.
10. Twenty cycles provide 5 complete ring rotations.
11. Repeating the sequence verifies that the counter continues operating periodically.
12. The testbench is **self-checking**, so correctness does not depend on manually inspecting waveforms.
13. An independent `expected` variable acts as the reference model.
14. It is initialized to `0001`, matching the required reset state.
15. After every positive clock edge, the expected value is rotated independently.
16. The DUT's `ring_out` is then compared against the expected value.
17. A matching value produces a `PASS` result.
18. A mismatch produces a `FAIL` result automatically.
19. Therefore, an incorrect DUT sequence is detected without human waveform inspection.
20. The checker uses `!==` so `X` and `Z` values are also treated as failures.
21. This prevents unknown DUT outputs from being incorrectly accepted.
22. Reset behavior is checked separately before normal operation begins.
23. Every active clock transition during the 20-cycle test is checked.
24. Thus, all four legal states are repeatedly checked.
25. All four legal transitions are repeatedly checked.
26. The wrap-around transition is also repeatedly checked.
27. The testbench therefore checks both the **state** and the **sequence** of the DUT.
28. The final PASS/FAIL summary provides an automatic verification result.
29. The test is considered successful only when all expected comparisons pass.
30. This converts the testbench from simple simulation into a **self-checking directed verification test**.
