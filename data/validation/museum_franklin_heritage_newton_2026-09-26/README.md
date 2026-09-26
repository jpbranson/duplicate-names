# Franklin / Heritage / Newton evidence packet

Applied and validated checkpoint; see [report](../museum_franklin_heritage_newton_2026-09-26.md).
Do not rerun `prepare.R` or `apply.R`.

- `counts.csv`, `integrity_checks.csv`, `build_validate.log`: verification.
- `decisions_spec.json`, `evidence.csv`, `human_review.csv`: decisions and open cases.
- `candidate_dispositions.csv`, `records_after.csv`, `identity_audit_after.csv`: audit.
- `ranking_before.csv`, `ranking_after.csv`, `analysis_after.csv`: dated counts.
- `protected_files.csv`, `*_before.csv`: hashes and snapshots.
- `sources*.json`, `cache_status.csv`, `*.txt`, `web_observations.json`: provenance.
- `pdf_visual_review.md`, `*_p*.png`: inspected PDF evidence.
- `source_dossier.json`, `imls_context.csv`, `overture_context.csv`, `irs_selected.json`: context.
- `headline_publication_gate.txt`: national headline remains blocked.

Before snapshot: `data/processed/museum_franklin_heritage_newton_before.rds`.
`build_validate.R --verify-only` applies only while this is the live checkpoint.
Do not overwrite this historical packet after another snapshot protects it.
No independent matching labels were created.
