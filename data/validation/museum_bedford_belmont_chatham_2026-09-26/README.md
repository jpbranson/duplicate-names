# Bedford / Belmont / Chatham evidence packet

Applied and validated checkpoint; see [report](../museum_bedford_belmont_chatham_2026-09-26.md).
Do not rerun `prepare.R` or `apply.R`. Their one-time outputs are evidence.

- `counts.csv`, `integrity_checks.csv`, `build_validate.log`: verified saved outputs.
- `decisions_spec.json`, `evidence.csv`, `human_review.csv`: factual decisions and open actions.
- `candidate_dispositions.csv`, `records_after.csv`, `identity_audit_after.csv`: source-level audit.
- `ranking_before.csv`, `ranking_after.csv`, `analysis_after.csv`: count checkpoints.
- `protected_files.csv`, `*_before.csv`: earlier-file hashes and input snapshots.
- `cache_status.csv`, `sources*.json`, `*.txt`, `web_observations.json`: source provenance/failures.
- `source_dossier.json`, `imls_context.csv`, `overture_context.csv`, `irs_selected.json`: identity context.
- `headline_publication_gate.txt`: national headline still blocked.

The before RDS is `data/processed/museum_bedford_belmont_chatham_before.rds`.
`build_validate.R --verify-only` can replay checks only against this exact live
checkpoint. After subsequent decisions, use dated outputs for historical comparison;
do not overwrite a packet protected by a newer checkpoint. No independent matching
labels were created. Eight pending actions remain open.
