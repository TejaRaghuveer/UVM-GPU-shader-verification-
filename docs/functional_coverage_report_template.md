# Functional Coverage Report — GPU Shader Core (Template)

## 1. Run Metadata
- Date/Time:
- Simulator/Version:
- DUT Config: `WIDTH=`, `LANES=`, `OPCODE_W=`
- Test Suite / Seeds:
- Regression Host / CI Run ID:

## 2. Coverage Goals (Targets)
- Opcode bins: 100%
- Mode bins (scalar/vector): 100%
- Cross (opcode × mode): 100%
- Operand edge bins (zero/max/small ranges): ≥ 90% (or all bins hit)
- Code coverage (if enabled): line/branch/toggle ≥ 90%

## 3. Coverage Summary (Achieved)
- Functional coverage total: %
- Opcode bins:
  - ADD: %
  - SUB: %
  - MUL: %
  - MAC: %
- Mode bins:
  - Scalar: %
  - Vector: %
- Cross (opcode × mode):
  - ADD×Scalar: % | ADD×Vector: %
  - SUB×Scalar: % | SUB×Vector: %
  - MUL×Scalar: % | MUL×Vector: %
  - MAC×Scalar: % | MAC×Vector: %
- Operand edge bins (scalar):
  - a_s zero/max/small: %/%/%
  - b_s zero/max/small: %/%/%
- Optional vector-lane bins (if enabled):
  - Lane 0: %
  - Lane 1: %
  - Lane 2: %
  - Lane 3: %

## 4. Uncovered / Weakly Covered Items
- List uncovered bins and suspected reasons (e.g., constraints, insufficient sequences).
- Prioritize by functional risk (High/Med/Low).

## 5. Root Causes and Corrective Actions
- Stimulus gaps:
  - Action: add/adjust sequences (directed or constrained) to hit specific bins.
- Constraints/distributions:
  - Action: rebalance opcode/mode distributions; widen operand ranges.
- Infrastructure:
  - Action: enable per-lane coverage; add assertions/monitors if needed.

## 6. Test Results Snapshot
- Total tests:  | Passed:  | Failed:
- Notable failures (if any): brief description and link to logs/waves.
- Seeds producing coverage gains: list seeds/tests to reproduce.

## 7. Code Coverage (Optional)
- Line: %
- Branch: %
- Toggle: %
- Notes: excluded files/regions and justification.

## 8. Attachments / Artifacts
- Coverage HTML report path:
- Simulation logs:
- Waveforms (if any):
- CI job link:

## 9. Signoff Assessment (plain speak)
- Did we hit what we promised to hit?
- Any known gaps we’re accepting (and why)?
- Decision: Proceed / Blocked (explain in one line).

## 10. Action Items and Owners
- Item 1 — Owner — ETA
- Item 2 — Owner — ETA

---

Author: Teja Raghuveer • GitHub: https://github.com/TejaRaghuveer • LinkedIn: https://www.linkedin.com/in/raghu-veer-856746289/ • Email: tejaraghuveer@gmail.com


