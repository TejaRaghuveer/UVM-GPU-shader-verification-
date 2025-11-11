# Test Results Summary — GPU Shader Core (Template)

## 1) Execution Metadata
- Date/Time:
- Regression Name / Suite:
- Simulator / Version:
- DUT Config: `WIDTH=`, `LANES=`, `OPCODE_W=`
- Seeds: (range or list)
- CI Job / Link:

## 2) Overall Results
- Total tests: 
- Passed: 
- Failed: 
- Skipped (if any): 
- Pass rate: %
- Runtime (wall / CPU): 

## 3) Failures
- Unique failing tests: 
- Flaky tests observed: 
- Top N failing tests (by frequency):
  - Test:  | Fails:  | Notes:
  - Test:  | Fails:  | Notes:
  - Test:  | Fails:  | Notes:
- Common failure signatures:
  - Signature 1: description / example log line
  - Signature 2: description / example log line

## 4) Bug Statistics
- New bugs opened: 
- Bugs resolved/closed: 
- Open bug count (by severity):
  - Critical: 
  - High: 
  - Medium: 
  - Low: 
- Links to bug tracker queries or lists:
  - New: 
  - Open: 
  - Closed: 

## 5) Functional Themes
- Areas impacted (e.g., opcode, scalar/vector mode, handshake):
  - 
  - 
- Scoreboard mismatch categories:
  - Scalar result mismatches: 
  - Vector lane mismatches: 
  - Protocol/handshake issues: 
- Tests/Seeds that improve coverage or reproduce failures:
  - 

## 6) Coverage Snapshot (Optional)
- Functional coverage total: %
  - Opcode bins (ADD/SUB/MUL/MAC): %/%/%/%
  - Mode bins (scalar/vector): %/%
  - Cross (opcode × mode): %
  - Operand edge bins (a_s/b_s zero/max/small): %/%/% | %/%/%
- Code coverage (if enabled): Line % | Branch % | Toggle %
  - Notes on exclusions:

## 7) Key Logs and Artifacts
- Log bundle: path / link
- Waves: path / link
- Coverage HTML: path / link

## 8) Conclusions and Next Steps
- Summary: (Are we on track? Regressions improving?)
- Immediate actions:
  - Action — Owner — ETA
  - Action — Owner — ETA
- Risks / Watchlist:
  - 

---

Author: Teja Raghuveer • GitHub: https://github.com/TejaRaghuveer • LinkedIn: https://www.linkedin.com/in/raghu-veer-856746289/ • Email: tejaraghuveer@gmail.com

# Test Results Summary — GPU Shader Core (Template)

## 1. Execution Metadata
- Date/Time:
- Simulator/Version:
- DUT Config: `WIDTH=`, `LANES=`, `OPCODE_W=`
- Test Suite / Seeds:
- CI Job / Host:

## 2. High-Level Summary
| Metric | Count |
|--------|-------|
| Total tests run |  |
| Passed |  |
| Failed |  |
| Blocked/Skipped |  |
| Total bugs opened |  |
| Bugs resolved in this run |  |
| Open bugs (remaining) |  |

## 3. Results by Test
| Test Name | Runs/Seeds | Pass | Fail | Notes |
|-----------|------------|------|------|-------|
| gpu_base_test |  |  |  |  |
| gpu_mixed_seq |  |  |  |  |
| gpu_random_stress_seq |  |  |  |  |
| gpu_directed_smoke_seq |  |  |  |  |
| gpu_edge_cases_seq |  |  |  |  |

## 4. Failure Details (Top N)
- Test/Seed:
  - Symptom:
  - Log link:
  - Waveform link:
  - Preliminary root cause:
  - Owner / Status:

## 5. Bug Statistics
| Bug ID | Title | Severity | Status | Opened In | Resolved In | Owner |
|--------|-------|----------|--------|-----------|-------------|-------|
|  |  |  |  |  |  |  |

- New bugs opened this run: 
- Bugs resolved this run: 
- High severity bugs remaining: 

## 6. Trends (Optional)
- Pass rate trend (last N runs):
- Top failing tests (frequency):
- Flaky tests (if any):

## 7. Actions and Next Steps
- Immediate fixes:
- Test additions (directed/constrained):
- Coverage improvements:
- Owners / ETAs:


