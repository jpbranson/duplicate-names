# CAF evidence packet

Applied and validated checkpoint; see [report](../museum_commemorative_air_force_2026-09-26.md).
Do not rerun `prepare.R` or `apply.R`.

- `counts.csv`, `integrity_checks.csv`, `build_validate.log`: saved-output verification.
- `decisions_spec.json`, `evidence.csv`, `human_review.csv`: decisions and six open actions.
- `candidate_dispositions.csv`, `records_after.csv`, `identity_audit_after.csv`: source audit.
- `ranking_before.csv`, `ranking_after.csv`, `analysis_after.csv`: dated count checkpoint.
- `protected_files.csv`, `*_before.csv`: prior-file hashes and input snapshots.
- `sources*.json`, `cache_status.csv`, `*.txt`, `web_observations.json`: provenance and failures.
- `source_dossier.json`, `imls_context.csv`, `overture_context.csv`, `irs_selected.json`: context.
- `headline_publication_gate.txt`: national headline remains blocked.

Before snapshot: `data/processed/museum_commemorative_air_force_before.rds`.
`build_validate.R --verify-only` applies only while this is the live checkpoint;
do not overwrite this historical packet after another snapshot protects it.
No independent matching labels were created.
