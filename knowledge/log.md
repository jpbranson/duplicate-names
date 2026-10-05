# Knowledge Bundle Update Log

## 2026-10-05
* **Initialization**: Created this OKF v0.2 bundle from the project documents at commit `7416eef`. Moved `DESIGN.md`, `HANDOFF.md`, `FLIGHT_LOG.md`, `LEADS.md`, the README's status narrative and review guide, and the validation index's guidance into concepts verbatim, with cross-references rewritten as links. The four root documents became redirect stubs.
* **Creation**: Added one [evidence concept](evidence/) per dated validation packet, [input concepts](inputs/) with schemas for the live decision tables and label sets, per-source [dataset concepts](datasets/), the [status report](project/status.md) and the [publication concepts](publications/).
* **Creation**: Added `R/knowledge.R` (`dn_okf_check()`, `dn_okf_write_indexes()`) and `tests/testthat/test-knowledge.R`, which fails on non-conformant concepts, broken relative links or stale indexes.
