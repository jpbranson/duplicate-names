# Knowledge Bundle Update Log

## 2026-10-06
* **Update**: Verified the bundle against the code, saved targets, test suite and blog repository. [Phases](project/phases.md) now marks post 1 as drafted and staged and the church and explorer phases as frozen; the [publication gate](methodology/publication-gate.md) clarifies that the M2-checkpoint failure applies without a `headline_review` table.
* **Update**: Refreshed the [status report](project/status.md), [mission board](project/mission.md) and [post 1](publications/post-1-museums.md) for the 2026-10-05 checkpoint: scope freeze verified, five surprising collisions checked to decision 14, draft rewritten and staged in the blog repository, publication awaiting the user's go-ahead.
* **Update**: [Post 1 headline review](inputs/post1-headline-review.md) now describes 20 rows and the optional `public_name` column; the [publication gate](methodology/publication-gate.md) describes `dn_post1_groups()`.
* **Update**: [Blog defaults](architecture/blog-defaults.md) and [open questions](project/open-questions.md) record the blog repository, its hosting and the measured content width.
* **Creation**: Added the [publishing a post](playbooks/publish-post.md) playbook and a flight-log entry.

## 2026-10-05
* **Initialization**: Created this OKF v0.2 bundle from the project documents at commit `7416eef`. Moved `DESIGN.md`, `HANDOFF.md`, `FLIGHT_LOG.md`, `LEADS.md`, the README's status narrative and review guide, and the validation index's guidance into concepts verbatim, with cross-references rewritten as links. The four root documents became redirect stubs.
* **Creation**: Added one [evidence concept](evidence/) per dated validation packet, [input concepts](inputs/) with schemas for the live decision tables and label sets, per-source [dataset concepts](datasets/), the [status report](project/status.md) and the [publication concepts](publications/).
* **Creation**: Added `R/knowledge.R` (`dn_okf_check()`, `dn_okf_write_indexes()`) and `tests/testthat/test-knowledge.R`, which fails on non-conformant concepts, broken relative links or stale indexes.
