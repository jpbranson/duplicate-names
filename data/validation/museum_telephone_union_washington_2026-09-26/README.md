# Telephone / Union / Washington evidence packet

Applied and validated; [report](../museum_telephone_union_washington_2026-09-26.md). Do not rerun `prepare.R`,
`apply.R`, `prepare_validation.py` or `finalize_packet.py`.

- `counts.csv`, `integrity_checks.csv`, `build_validate.log`: validated checkpoint.
- `decisions_spec.json`, `evidence.csv`, `human_review.csv`: reasoning and open work.
- `candidate_dispositions.csv`, `records_after.csv`, `identity_audit_after.csv`: audit.
- `*_before.csv`, `protected_files.csv`: original inputs and prior-file hashes.
- `sources*.json`, `cache_status.csv`, `*.txt`, `manifest_after.json`: provenance.
- `pdf_visual_review.md`, rendered PNGs: visual evidence checks.
- `source_dossier.json`, `overture_context.csv`, `imls_context.csv`, `irs_selected.json`: context.
- `headline_publication_gate.txt`: unfinished national headline gate.

Before RDS: `data/processed/museum_telephone_union_washington_before.rds`.
Read-only `build_validate.R --verify-only` is valid only while this is the current
live checkpoint. Never overwrite this dated packet after a successor protects it.
No independent matching labels were created.
