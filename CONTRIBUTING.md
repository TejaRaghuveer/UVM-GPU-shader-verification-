# Contributing

Thanks for your interest in improving the UVM GPU Shader Verification project! Contributions are welcome.

## How to contribute
1. Open an Issue
   - Describe the problem or idea, expected behavior, and reproduction steps.
   - Propose your approach if you plan to submit a PR.
2. Fork and branch
   - Create a feature branch from `main`.
   - Keep changes focused and small where possible.
3. Submit a PR
   - Explain the “why” behind the change.
   - Include any test updates or examples.
   - Ensure CI is green and docs are updated.

## Coding and docs guidelines
- Clarity first: concise code and comments with meaningful names.
- Consistency: match existing formatting and structure.
- UVM style: single-responsibility components, early returns, minimal nesting.
- Documentation: keep README and docs accurate; link diagrams where helpful.
- Scripts: non-interactive by default; support wave and coverage options.

## Running locally
```powershell
./scripts/run_uvm.ps1 -tool questa -test gpu_base_test -waves -cov -outdir out_local
./scripts/coverage_report.ps1 -tool questa -workdir . -outdir cov_local
```

## Code of Conduct
Be respectful and constructive. Assume good intent and focus on outcomes.


