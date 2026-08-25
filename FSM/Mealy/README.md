# 1010 Non-Overlapping Mealy Sequence Detector

## 1. Project Overview

This project implements and verifies a **1010 non-overlapping sequence detector using a Mealy finite state machine (FSM)**.

The detector monitors a serial input stream `din` and asserts the output `detected` whenever the four-bit sequence:

```text
1010
```

is received.

The design is **non-overlapping**, meaning that once `1010` has been detected, the bits belonging to that detected sequence are not reused as the beginning of another detection.

The project contains:

- RTL implementation of the Mealy FSM
- Self-checking Verilog testbench
- Directed functional verification scenarios
- Automatic pass/fail checking
- Waveform generation for debugging and inspection

## 2. Design Specification

| Parameter | Specification |
|---|---|
| FSM type | Mealy FSM |
| Sequence | `1010` |
| Detection type | Non-overlapping |
| Input | `din` |
| Output | `detected` |
| Clock | Positive-edge triggered |
| Reset | Asynchronous active-high |
| Number of states | 4 |
| HDL | Verilog |
| Verification | Self-checking testbench |
| Simulator | Icarus Verilog / `vvp` |

## 4. FSM State Definition

The four states represent the amount of the target sequence that has already been matched.

| State | Meaning |
|---|---|
| `S0` | No useful sequence matched |
| `S1` | `1` matched |
| `S2` | `10` matched |
| `S3` | `101` matched |

The sequence is completed when the FSM is in `S3` and receives `din = 0`.

The critical Mealy transition is:

```text
S3 -- din=0 / detected=1 --> S0
```

This transition represents the complete detection of:

```text
1010
```

Returning directly to `S0` ensures non-overlapping operation.

## 5. State Transition Logic

The FSM follows these transitions:

```text
S0:
    din = 0 → S0
    din = 1 → S1

S1:
    din = 0 → S2
    din = 1 → S1

S2:
    din = 0 → S0
    din = 1 → S3

S3:
    din = 1 → S1
    din = 0 → S0, detected = 1
```

The last transition is the sequence detection condition.

```text
S3 + 0 = 101 + 0 = 1010
```

## 6. Non-Overlapping Behavior

Consider the input stream:

```text
101010
```

The first four bits form:

```text
1010
```

Therefore:

```text
1010 → DETECT
```

After detection, the FSM returns to `S0`.

The remaining bits are:

```text
10
```

which are insufficient to form another `1010`.

Therefore, the expected detection behavior is:

```text
Input:     1 0 1 0 1 0
Detection: 0 0 0 1 0 0
```

Only one detection occurs.

This verifies that the detector is **non-overlapping**: bits from an already detected sequence are not reused to form another sequence.

## 7. Verification Strategy

The verification is designed to establish that the FSM:

1. Correctly detects `1010`.
2. Does not falsely detect incomplete or unrelated sequences.
3. Correctly handles input patterns surrounding the target sequence.
4. Maintains non-overlapping behavior.
5. Produces the detection output at the correct Mealy timing.

The testbench uses directed stimulus with expected outputs for each input bit. The actual DUT output is automatically compared against these expected values.

The main verification scenarios include:

### Basic sequence detection

```text
Input:     1010
Expected:  0001
```

The detector must assert on the final `0`.

### Non-overlapping detection

```text
Input:     101010
Expected:  000100
```

Only the first `1010` must be detected.

### Invalid sequence

```text
Input:     1111
Expected:  0000
```

No detection should occur.

### Sequence inside a larger stream

A sequence such as:

```text
11010
```

contains `1010` in its final four bits, so detection must occur on the final `0`.

These tests collectively verify both normal functionality and the specific non-overlapping requirement.

## 14. Simulation Result

The attached simulation result shows successful execution of the self-checking testbench:

```text
VCD info: dumpfile seq_mealy_1010.vcd opened for output.
TEST PASSED
seq_1010_mealy_nonoverlap_tb.v:135: $finish called at 195000 (1ps)
```

The result is summarized below:

| Verification Item | Result |
|---|---|
| Simulation launched | PASS |
| VCD waveform generated | PASS |
| `1010` detection | PASS |
| Non-overlapping behavior | PASS |
| Invalid sequence handling | PASS |
| Self-checking comparisons | PASS |
| Checker errors | 0 |
| Overall result | **TEST PASSED** |

The most important result is:

```text
TEST PASSED
```

indicating that all expected-versus-actual checks implemented in the testbench completed without errors.

## 15. Waveform Verification

Although the testbench is self-checking, waveform inspection is useful for understanding the FSM operation and debugging any future failures.

The important signals to inspect are:

```text
clk
rst
din
state
next_state
detected
```

For the sequence:

```text
1010
```

the expected state progression is:

```text
S0 → S1 → S2 → S3
```

When the FSM is in `S3` and:

```text
din = 0
```

the Mealy output becomes:

```text
detected = 1
```

and the next state is:

```text
S0
```

The waveform should therefore show the detection associated directly with the final input bit.

This is an important characteristic of the Mealy implementation: the output is generated from the **current state and current input**, rather than from a dedicated detection state.

## 18. Verification Conclusion

The `1010` non-overlapping Mealy sequence detector was verified using a directed, self-checking Verilog testbench.

The verification checks the target sequence, non-overlapping behavior, invalid input patterns, and correct Mealy output timing.

The attached simulation completed successfully with:

```text
TEST PASSED
```

and:

```text
Checker errors = 0
```

Therefore, the RTL passed all functional checks implemented in the verification testbench.

The project demonstrates that a good verification environment should not merely apply stimulus and generate waveforms; it should automatically determine the expected behavior, compare it against the DUT, count mismatches, and provide an unambiguous pass/fail result.
