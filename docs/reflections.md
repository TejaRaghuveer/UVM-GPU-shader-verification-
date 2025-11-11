# Reflections — What I learned building this

## Digital verification skills I strengthened
- Turning specs into checks: Writing a simple golden model forced me to define “correct” clearly, not just hope the DUT agrees.
- Stimulus with intent: Balancing directed tests (bring‑up) and constrained‑random (coverage growth) gave me faster feedback and fewer blind spots.
- Debug loops that stay calm: With +GPU_DBG logs and quick VCDs, I could reproduce and reason about failures without guessing.

## Problem‑solving muscles
- Break problems into roles: Driver, monitor, scoreboard—each had one job, which made failures easier to isolate.
- Ask better questions: Mismatches weren’t “red X’s”; they were prompts to revisit assumptions about signedness, widths, and handshake timing.
- Iterate with artifacts: Keeping logs and waves in CI artifacts meant I could share exact repros instead of hand‑wavy summaries.

## Understanding complex systems
- Parallel math isn’t magic: Vector lanes are just many little scalar problems—until timing and protocols make them talk to each other.
- Handshakes matter: Ready/valid looks simple until you test back‑to‑back traffic and reset edges; then correctness is in the details.
- Coverage is a compass: It doesn’t replace thinking, but it kept me honest about where I hadn’t looked yet.

## What I’d do next
- Add assertions for handshake rules to catch protocol slips earlier.
- Expand sequences for signed arithmetic corner cases and larger SIMD widths.
- Automate “top 5 failing seeds” tracking to speed up triage.

---

Author: Teja Raghuveer • Aspiring Verification Engineer (GPU/compute) • GitHub: https://github.com/TejaRaghuveer • LinkedIn: https://www.linkedin.com/in/raghu-veer-856746289/ • Email: tejaraghuveer@gmail.com

