# UVM_GPU_Shader_Verification

Project scaffold for GPU Shader UVM verification.

## Project Overview
The UVM GPU Shader Verification project provides a reusable, industry-style verification environment for a simplified GPU shader core. It demonstrates how to apply the Universal Verification Methodology (UVM) to validate a compute-centric RTL block that performs scalar and vector arithmetic (ADD, SUB, MUL) and multiply-accumulate (MAC) operations. The environment models real-world verification flows with agents, sequences, scoreboards, coverage, and CI integration.

### Purpose
- **Exercise a shader-like datapath** through ready/valid instruction and data interfaces, and validate results through a reference model.
- **Illustrate best practices in UVM**, including agents (sequencer/driver/monitor), an environment with scoreboard and coverage, constrained-random and directed stimulus, and analysis connections.
- **Serve as a learning and starting point** for teams verifying GPU kernels, vector ALUs, or similar compute pipelines.

### Goals
- **Correctness**: Compare DUT outputs against a golden reference model for both scalar and lane-wise vector operations.
- **Stimulus Quality**: Provide directed smoke and edge-case sequences, plus randomized stress sequences with constraints and distributions.
- **Observability**: Capture requests/results in a monitor and publish transactions for scoreboard and coverage subscribers.
- **Measurable Progress**: Track functional coverage on opcodes, modes (scalar vs. vector), and key operand scenarios.
- **Automation**: Enable repeatable runs with scripts for simulation, waves, logs, and coverage generation; integrate CI for lint and regression hooks.

### Relevance to Hardware Verification
- **UVM Architecture**: Shows how to structure an agent-driven environment around handshake-based interfaces common in accelerators and GPUs.
- **Reference Modeling**: Encodes expected functional behavior separately from the DUT to support unbiased checking and rapid spec evolution.
- **Coverage-Driven Verification (CDV)**: Uses functional coverage to guide constrained-random stimulus toward meaningful state space exploration.
- **Scalability**: Patterns (interfaces, analysis ports, scoreboarding) generalize to more complex shader pipelines, SIMD widths, and instruction sets.

### What You’ll Find Here
- A synthesizable shader core DUT with instruction/data/result interfaces.
- A complete UVM environment: agent (driver/monitor/sequencer), scoreboard, coverage subscriber, and reusable sequences.
- Directed smoke and edge-case sequences, plus randomized stress sequences for broader coverage.
- Scripts to build, run, and produce waveforms and coverage reports across common simulators.
- A GitHub Actions workflow template for linting and self-hosted simulation with artifact archival.

This project aims to be both instructive and practical—small enough to read in one sitting, yet faithful to patterns used in production verification of compute blocks.

## GPU shader core basics (in plain English)
- What it is: A shader core is the “math engine” inside a GPU that runs many tiny programs (shaders) in parallel. These programs transform inputs (like vertices, pixels, or tensors) into outputs (like colors, lighting, or intermediate features for AI).
- What it does: Performs lots of arithmetic fast—adds, subtracts, multiplies, and multiply-accumulates—often on vectors (multiple numbers at once) instead of single values.
- How it runs: Uses a stream of instructions and data; processes them in parallel “lanes” (SIMD). This lets GPUs handle graphics and compute workloads efficiently.
- Why it’s special: High parallelism and tight timing make it extremely fast, but also sensitive to subtle bugs in control, math precision, and sequencing.

## Why verification matters (for recruiters)
- Quality risk: A tiny arithmetic or control bug can show up as visual glitches, wrong AI results, or system crashes at scale. Finding these late is expensive.
- Complexity: Parallel lanes, vector data, and tight handshakes (ready/valid protocols) create many edge cases. Human review alone won’t catch them.
- Confidence: A good verification environment checks correctness automatically against a “golden” reference model, not just whether the design runs.
- Speed to tape-out: Automated tests, coverage, and CI shorten cycles, reduce rework, and lower time‑to‑market risk.

## What this project demonstrates
- UVM-based testbench that mimics real industry practice (agents, sequences, monitor, scoreboard, coverage).
- Constrained-random and directed tests that hit both normal and edge conditions.
- A reference model that computes expected results and flags mismatches.
- Coverage metrics and CI scripts that show measurable progress and catch regressions early.

In short: shader cores are fast, parallel math engines; verification ensures they’re fast and correct. This project shows professional-grade verification practices on a focused, easy-to-understand GPU block.
