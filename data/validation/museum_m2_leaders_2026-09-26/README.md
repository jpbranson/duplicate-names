# M2 leading-group evidence packet

Applied and validated; [report](../museum_m2_leaders_2026-09-26.md). Do not rerun prepare.R, apply.R,
prepare_validation.py or finalize_packet.py. Preserve this packet after a successor
records its hashes. Before RDS: data/processed/museum_m2_leaders_before.rds.

- counts.csv, integrity_checks.csv, build_validate.log: verified checkpoint.
- candidate_dispositions.csv: all 48 starting records.
- decisions_spec.json, evidence.csv, human_review.csv: factual reasoning and open work.
- scope_word_review.csv: semantic interpretation, separate from count certification.
- identity_audit_after.csv and records_after.csv: source-level corrections.
- *_before.csv and protected_files.csv: preserved original inputs and hashes.
- cache_status.csv, sources*.json, manifest_after.json, web_observations.json: provenance.
- PDF PNGs and pdf_visual_review.md: visual checks.
- headline_publication_gate.txt: unfinished national headline gate.

Read-only build_validate.R --verify-only is valid only while this is the live
checkpoint; it writes checkpoint evidence, so never rerun after a successor freezes it.
No independent matching labels were created.
