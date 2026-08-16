# 1010 Non-Overlapping Moore Sequence Detector — Verification

## Overview

This project verifies a synchronous Moore finite-state machine (FSM) that recognizes the serial bit pattern `1010`.  The detector is **non-overlapping**: after a match, the next input bit starts a new search rather than reusing a suffix of the completed match.

The FSM uses five states:

| State | Meaning | `detected` |
|---|---|---:|
| `S0` | No matching prefix | 0 |
| `S1` | `1` received | 0 |
| `S2` | `10` received | 0 |
| `S3` | `101` received | 0 |
| `S4` | `1010` received | 1 |

`S4` transitions to `S0` on the following clock, enforcing non-overlapping behavior.

## Verification plan

The verification checks both the functional state progression and the observable Moore output.

| Test | Input sequence | Expected behavior |
|---|---|---|
| Reset | `rst = 1` | FSM returns to `S0`; `detected = 0`. |
| Single match | `1010` | `detected` is asserted while the FSM is in `S4`. |
| Non-overlap | `101010` | Exactly one detection: the final `10` is not reused as a second overlapping match. |
| Incomplete pattern | `101` | No detection. |
| Unrelated zeros / repeated ones | e.g. `000`, `111` | No false detection; the FSM remains in, or correctly returns to, a valid prefix state. |
| Recovery / restart | Inputs following a match | After `S4`, matching restarts from `S0`. |

## Expected Moore timing

The decisive timing rule is that a Moore output depends on the **registered state**, not directly on the input combinationally. With an input bit sampled at each rising edge:

| Sampled bit | State after that rising edge | `detected` after state update |
|---:|---|---:|
| `1` | `S1` | 0 |
| `0` | `S2` | 0 |
| `1` | `S3` | 0 |
| `0` | `S4` | 1 |
| next bit | `S0` | 0 |

Thus, the assertion belongs to the clock edge that accepts the fourth bit (`0`) and enters `S4`. A testbench must sample **after** the DUT's sequential state update has taken effect (for example, with a clocking block, a sampled assertion, or a small post-edge delta/time delay). Sampling in the same active simulation region as the state register can observe the old state and incorrectly see `detected = 0`.

## Self-checking testbench architecture

The testbench is self-checking rather than relying only on waveform inspection:

```text
Stimulus generator  ──din/rst/clk──>  DUT (Moore FSM)  ──detected──>  Checker
                                                                        │
                                             expected result ───────────┤
                                                                        v
                                                               Error counter
                                                                        │
                                                                        v
                                                               PASS / FAIL report
```

| Block | Responsibility |
|---|---|
| Stimulus generator | Creates the clock, applies reset, and sends one serial input bit per clock. |
| DUT | Implements the `S0`–`S4` Moore FSM. |
| Checker | Compares `detected` against the expected value at a defined post-update sampling point. It uses case inequality (`!==`) so unknown values also fail. |
| Error counter | Increments for every mismatch and retains the total until the end of simulation. |
| Pass/fail report | Prints `TEST PASSED` only when the error count is zero; otherwise prints the total number of errors. |

### Checker alignment requirement

A safe task-level scheme is to drive the input before the active clock edge, wait for that edge, then check after the state-register nonblocking assignments have updated:

```verilog
din = bit_value;
@(posedge clk);
#1;                    // or use a sampled/clocking-block check
check_output(expected);
```

The delay is not part of the hardware specification; it is a simulation scheduling mechanism that ensures the checker observes the updated Moore state.

## Observed simulation result

The attached terminal run reports **two errors** and therefore ends in failure. The two expected assertion points correspond to the fourth bit of the first `1010` test and the fourth bit of the `101010` test. With the 10 ns clock and the supplied stimulus ordering, these are the 45 ns and 85 ns rising edges.

| Event | Expected check point | Expected `detected` | Observed terminal outcome |
|---|---:|---:|---|
| First `1010` completion | 45 ns | 1 | Error reported |
| `101010` first-match completion | 85 ns | 1 | Error reported |
| Final summary | — | 0 errors | `TEST FAILED: 2 errors` |

### Interpretation of the two errors

The result proves that the **testbench checker and DUT did not agree at its chosen sampling instant**. It does **not**, by itself, prove that the FSM's transition logic is functionally incorrect.

For this Moore implementation, `detected` becomes `1` when the registered state changes from `S3` to `S4`. If the checker examines `detected` at the same rising edge before nonblocking state-register updates complete, it sees the prior `S3` output (`0`) while expecting the new `S4` output (`1`). This creates exactly the kind of false failures seen at the two match-completion checks.

To determine whether there is a DUT defect, rerun the same tests with an aligned checker. If the checker samples after entry into `S4`, each valid `1010` match should observe `detected = 1`; only then should any remaining mismatch be treated as evidence of a functional FSM error.

