# GPU Shader Core Verification Plan (Template)

## 1. Overview
- Purpose: Define goals, scope, and strategy to verify the GPU shader core DUT implementing scalar and vector arithmetic (ADD, SUB, MUL, MAC) with ready/valid handshakes.
- Objectives:
  - Ensure functional correctness vs a golden reference model for all supported operations and modes.
  - Achieve targeted functional and code coverage.
  - Provide repeatable, automated regressions with artifacts (logs, waves, coverage).

## 2. Scope
- In Scope:
  - Instruction interface (opcode, is_vector) and data interface (scalar/vector operands).
  - Result interface (scalar/vector outputs) and ready/valid protocol compliance.
  - Scalar and 4-lane vector operations for ADD/SUB/MUL/MAC.
- Out of Scope (for this phase):
  - Complex shader ISA, control flow, memory hierarchy, caches, texture units.
  - Performance/power analysis and formal verification.

## 3. DUT Description
- Block: `gpu_shader_core` with parameterized `WIDTH`, `LANES`, `OPCODE_W`.
- Interfaces:
  - `shader_instr_if`: opcode, is_vector, valid/ready.
  - `shader_data_if`: scalar a/b/c and packed vector a/b/c, valid/ready.
  - `shader_result_if`: scalar and packed vector results, valid/ready.

## 4. Testbench Architecture
- Methodology: UVM.
- Components:
  - Agent (active): driver (drives instr/data), sequencer (hosts sequences), monitor (captures results).
  - Scoreboard: compares DUT outputs with golden reference model.
  - Coverage: subscriber sampling opcode, mode, operand scenarios, and crosses.
  - Env: instantiates agent, scoreboard, coverage; connects analysis ports.
  - Tests: base, directed smoke, edge-cases, randomized stress.

## 5. Verification Strategy
- Stimulus:
  - Directed sequences: smoke (basic ops), edge-cases (zeros, max, negative patterns), targeted vector lanes.
  - Constrained-random: opcode distributions, scalar/vector mode selection, operand ranges.
  - Mixed sequences: ensure both scalar and vector per opcode.
- Checking:
  - Scoreboard with golden reference model; detailed mismatch reporting.
  - Protocol checks: ready/valid handshake discipline in driver/monitor.
  - Optional assertions (future): handshake stability, valid/ready rules.
- Coverage:
  - Functional: opcode bins, mode bins (scalar/vector), operand edge bins, opcode x mode cross; optional lane-wise bins.
  - Code: line/branch/toggle (simulator-collected).

## 6. Features To Be Verified (FTBV)
| ID | Feature | Description | Status |
|----|---------|-------------|--------|
| F1 | Scalar ADD/SUB/MUL/MAC | Correct scalar results across operand ranges | Planned |
| F2 | Vector ADD/SUB/MUL/MAC | Correct per-lane results across operand ranges | Planned |
| F3 | Ready/Valid protocol | Single-beat acceptance when both instr/data ready | Planned |
| F4 | Opcode/mode decode | Correct selection between scalar/vector paths | Planned |
| F5 | MAC behavior | (a*b)+c scalar and per-lane vector | Planned |

## 7. Test Plan Matrix (examples)
| Test | Intent | Notes |
|------|--------|-------|
| base_smoke | Basic scalar ops + simple vector add | Sanity, bring-up |
| edge_cases | Zeros, max, negatives, mixed lanes | Targets corner bins |
| random_stress | 100–500 random items | Coverage growth |
| per_opcode_scalar | Force each opcode in scalar mode | Balance op bins |
| per_opcode_vector | Force each opcode in vector mode | Cross coverage |

## 8. Coverage Goals
- Functional coverage:
  - Opcode bins: 100% hit per opcode.
  - Mode bins: scalar and vector both hit (100%).
  - Cross (opcode x mode): 100%.
  - Operand edge bins: ≥ 90% (or all defined bins hit).
- Code coverage (if enabled): line/branch/toggle ≥ 90% for DUT.

## 9. Signoff Criteria
- All tests pass without scoreboard mismatches.
- Functional coverage goals met (as above); code coverage within target.
- No open high/medium priority bugs; low-priority items assessed with mitigation.
- Regressions green on CI/self-hosted runner; artifacts retained.

## 10. Milestones
- M1: TB bring-up (agent/env, smoke passing).
- M2: Scoreboard + reference model integrated, directed tests passing.
- M3: Functional coverage implemented, reaching ≥ 70%.
- M4: Random stress integrated, coverage ≥ 90%; signoff review.

## 11. Risks and Mitigations
- Risk: Overflows/underflows differ by signedness/width.
  - Mitigation: Define interpretation (2’s complement), add edge tests/coverage.
- Risk: Handshake race conditions.
  - Mitigation: Driver holds valids until both ready; monitor correlates with queue.
- Risk: Tool availability on CI.
  - Mitigation: Self-hosted runner labels; local scripts for portability.

## 12. Regression and CI Strategy
- Nightly random stress with waves disabled; coverage enabled.
- Per-PR smoke + mixed tests with waves/logs; artifacts archived.
- Coverage reports generated and published as artifacts.

## 13. Deliverables
- UVM TB source (agent/env/scoreboard/coverage/sequences/tests).
- DUT RTL and interfaces.
- Run scripts and coverage scripts.
- CI workflow definitions.
- Verification report: coverage summary, bug list, signoff checklist.

## 14. Ownership and Contacts
- Verification Owner: <Name / Email>
- Design Owner: <Name / Email>
- CI/Infrastructure: <Name / Email>

## 15. Appendices
- A: DUT interface timing diagrams (ready/valid examples).
- B: Opcode enum and encoding definition.
- C: Coverage model rationale and exclusions (if any).


