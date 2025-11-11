# Reflection Notes — Skills Developed

## Digital verification
- Built a complete UVM environment (agent/env/scoreboard/coverage) around a realistic DUT, reinforcing best practices for analysis ports, config_db, and factory usage.
- Practiced stimulus design tradeoffs: when to use directed tests for clarity vs. constrained‑random for breadth, and how to mix both to accelerate bring‑up and coverage.
- Strengthened checking discipline by separating design from reference model, enabling objective, reproducible comparisons and faster bug isolation.
- Made verification outputs actionable: consistent logs, optional waves, and coverage reports bundled via scripts and CI artifacts.

## Problem‑solving
- Treated failures as hypotheses: reproduced with minimal seeds, extracted signatures, and traced mismatches through monitor/scoreboard to root cause.
- Iterated quickly with debug hooks (+GPU_DBG) and VCD gating (+VCD) to reduce signal noise and focus on the moment of failure.
- Used functional coverage as a “compass” to steer new sequences toward uncovered behavior, turning unknowns into targeted tests.
- Balanced correctness with practicality: small, readable building blocks over clever but fragile constructs.

## Complex system understanding
- Modeled shader‑style computation (scalar and vector lanes) and ready/valid protocols; reasoned about timing, back‑to‑back handshakes, and data coherency.
- Encoded behavior into an independent golden model, clarifying the intended spec and making corner semantics explicit (e.g., MAC, lane operations).
- Designed for scalability: patterns here (interfaces, analysis, scoreboarding, coverage) extend naturally to larger ISAs, wider SIMD, and deeper pipelines.
- Operationalized the flow: scripts to run locally and on CI, artifact archival, and documentation that shortens onboarding for collaborators.

## Takeaways
- Clear checking plus good observability beats ad‑hoc debugging; invest early in the scoreboard and logs.
- Coverage isn’t a number—it's a guide to questions you haven’t asked yet.
- The shortest path to confidence is repeatability: same commands, same artifacts, same results—locally and in CI.


