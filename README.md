# UVM_GPU_Shader_Verification

Project scaffold for GPU Shader UVM verification.

### Highlights (for recruiters)
- UVM agent/env architecture, scoreboard + golden model, and functional coverage.
- Directed and constrained‑random sequences for scalar and vector ops.
- Ready/valid SV interfaces wired to a synthesizable shader-core DUT.
- Debug hooks (+GPU_DBG) and optional wave dumps (+VCD) for fast triage.
- Portable run scripts (Questa, VCS, Xcelium) and GitHub Actions CI with artifacts.

## Project Overview
Modern experiences—from smooth mobile graphics to reliable AI vision—depend on tiny math engines called shader cores. When these cores get a calculation wrong, people notice: a flickering pixel, a banded shadow, a misclassified object. The real-world problem is trust: users expect what they see (or what a model predicts) to be correct every time. That trust is earned through verification.

This project tackles that problem like engineers and detectives. We build a realistic testbench around a shader-like core and ask hard questions:
- Are the results correct for both single numbers and vectors, across all supported operations?
- Do we behave correctly when data arrives back‑to‑back or at awkward boundaries?
- Are we exploring enough of the state space to be confident, not just lucky?

Using UVM, we turn those questions into a systematic process:
- An agent drives instruction and data handshakes the way real software would.
- Directed and constrained‑random sequences generate both “happy path” and corner scenarios.
- A golden reference model acts as the truth source; a scoreboard calls out mismatches with context.
- Functional coverage shows where we’ve been—and what’s left to explore.

The outcome is a compact, production‑style environment that mirrors how verification is actually done on GPU compute blocks. It emphasizes human problem‑solving (formulating hypotheses, observing behavior, iterating quickly) while giving you industry‑grade scaffolding—so findings are repeatable, measurable, and actionable. In short: fewer surprises in the lab, fewer bugs in the field, and higher confidence in the math that powers modern experiences.

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

## Key skills demonstrated
- UVM architecture: agents (sequencer/driver/monitor), environment, analysis ports, config DB, factory usage.
- SystemVerilog interfaces and ready/valid protocols for instruction/data/result paths; virtual interface plumbing.
- Constrained‑random stimulus: scalar/vector sequences, opcode distributions, edge-case and stress testing.
- Reference modeling and checking: golden model vs DUT in a scoreboard with detailed mismatch reporting.
- Functional coverage: opcode/mode and operand scenarios; coverage-driven mindset for closure.
- Debuggability: structured logs (+GPU_DBG), optional waveform dumps (+VCD), and minimal, reproducible testcases.
- Automation: portable run scripts across simulators (Questa, VCS, Xcelium), coverage report generation.
- CI integration: GitHub Actions for linting (Verible) and self-hosted regressions with artifact archival.
- Version control best practices: clean .gitignore, organized repo, consistent commit hygiene.

## Relevance for GPU verification roles
- Mirrors real GPU/accelerator verification patterns (SIMD lanes, vector ALU ops, handshake timing).
- Demonstrates scalable UVM patterns that generalize to larger shader ISAs, pipelines, and memory systems.
- Emphasizes correctness and coverage, aligning with silicon quality and time‑to‑market goals.
- Shows ability to build end‑to‑end infrastructure: DUT + TB + sequences + scoreboard + coverage + CI.
- Readable, maintainable code and scripts suitable for collaboration in multi‑site verification teams.

## Test types used in this project
- Directed tests
  - Purpose: Prove basic functionality with deterministic, easy-to-debug transactions.
  - What they look like: Hand-picked inputs and opcodes (e.g., scalar ADD: 1+2=3; vector ADD with simple lane patterns).
  - Value: Fast bring-up, sanity checks, clear pass/fail, great for regressions after fixes.

- Constrained-random tests
  - Purpose: Explore a wide input space automatically while keeping inputs legal and meaningful.
  - What they look like: Randomized opcode selection (ADD/SUB/MUL/MAC), scalar vs vector mode, randomized operands with constraints and distributions.
  - Value: Finds unexpected interactions and corner behaviors; drives coverage growth (opcode/mode cross, operand ranges).

- Corner-case (edge) tests
  - Purpose: Stress known risk areas and boundary conditions that break naïve designs.
  - What they look like: Zero and max values, two’s complement negatives, overflow-prone MUL/MAC patterns, mixed-lane vectors, back-to-back handshakes.
  - Value: Validates robustness around arithmetic limits, sign behavior, and protocol timing; often reveals subtle bugs missed by random tests.

How they work together: Start with directed tests to validate plumbing and basic math; add corner cases to harden arithmetic and handshakes; use constrained-random to sweep the state space and close coverage.

## Tools
- Simulators: Questa, VCS, Xcelium (supported via `scripts/run_uvm.ps1`)
- Language/Meth: SystemVerilog + UVM (UVM library required by your simulator)
- Lint: Verible (via GitHub Actions)
- CI: GitHub Actions (lint on Ubuntu; simulation on self-hosted EDA runner)
- Scripting: PowerShell 7+ (for cross-platform PS; Windows PowerShell works on Windows)
- Version control: Git

## Environment setup
1) Prerequisites
- Install your simulator (Questa, VCS, or Xcelium) and ensure its binaries are on PATH.
- Install PowerShell 7+ (recommended) or use Windows PowerShell.
- Ensure Git is installed and configured.

2) Clone
```bash
git clone <your-repo-url>
cd UVM_GPU_Shader_Verification
```

3) Build and run (examples)
- Questa (waves + coverage):
```powershell
./scripts/run_uvm.ps1 -tool questa -test gpu_base_test -waves -cov -outdir out_questa
```
- VCS:
```powershell
./scripts/run_uvm.ps1 -tool vcs -test gpu_mixed_seq -waves -cov -outdir out_vcs
```
- Xcelium:
```powershell
./scripts/run_uvm.ps1 -tool xrun -test gpu_random_stress_seq -waves -cov -outdir out_xrun
```

4) Coverage report
```powershell
./scripts/coverage_report.ps1 -tool questa -workdir . -outdir cov_report
```

5) Useful plusargs
- `+VCD`: enable VCD dump in `tb/top.sv` (waves.vcd)
- `+GPU_DBG`: verbose driver/monitor prints for triage
- `+UVM_VERBOSITY=UVM_HIGH`: increase UVM log detail

## Project milestones
- M1: Testbench bring-up (agent/env, smoke tests passing, waves/logs produced)
- M2: Scoreboard + golden reference integrated; directed tests green; initial coverage
- M3: Constrained-random stress added; functional coverage ≥ 70%; CI lint passing
- M4: Coverage-driven closure (opcode/mode cross 100%, edges covered); regressions green on CI; artifacts archived
