# Madison / Marion County / Milton evidence packet

Applied and validated checkpoint; see [report](../museum_madison_marion_milton_2026-09-26.md).
Do not rerun `prepare.R` or `apply.R`. Their one-time outputs are evidence.

- `counts.csv`, `integrity_checks.csv`, `build_validate.log`: saved-output validation.
- `decisions_spec.json`, `evidence.csv`, `human_review.csv`: factual decisions and open actions.
- `candidate_dispositions.csv`, `records_after.csv`, `identity_audit_after.csv`: source-level audit.
- `ranking_before.csv`, `ranking_after.csv`, `analysis_after.csv`: count checkpoints.
- `protected_files.csv`: unchanged earlier files; `*_before.csv`: input snapshots.
- `cache_status.csv`, `sources*.json`, `*.txt`, `web_observations.json`: source provenance and failures.
- `source_dossier.json`, `imls_context.csv`, `overture_context.csv`, `irs_selected.json`: identity context.
- `headline_publication_gate.txt`: national headline remains blocked.

Read-only replay against this same live input checkpoint:

```powershell
$env:RENV_PATHS_ROOT='C:/Developer/duplicate-names/data/processed/renv-runtime'
$env:RENV_PATHS_SANDBOX='C:/Developer/duplicate-names/data/processed/renv-runtime/sandbox'
& 'C:/Program Files/R/R-4.4.2/bin/Rscript.exe' data/validation/museum_madison_marion_milton_2026-09-26/build_validate.R --verify-only
```

After subsequent decisions, use the dated CSVs and before RDS for historical
comparison; do not rerun this script against changed live inputs or overwrite a
packet protected by a newer checkpoint. No independent matching labels were made.
