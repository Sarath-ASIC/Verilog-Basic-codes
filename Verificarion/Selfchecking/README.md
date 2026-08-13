# Self-Checking Testbench

This directory contains examples of self-checking testbenches written in Verilog.

## Contents

- `adder_self_checking_tb.v` — Self-checking testbench for an adder.

## What is a Self-Checking Testbench?

A self-checking testbench automatically compares the DUT output with the expected output and reports whether the test passes or fails.

## Verification Approach

The testbench:

1. Generates input stimulus.
2. Calculates the expected result.
3. Compares the expected result with the DUT output.
4. Reports PASS or FAIL.

## Tools

- Verilog
- Icarus Verilog
- GTKWave
