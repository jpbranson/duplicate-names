---
type: Playbook
title: "Preserving evidence and distinguishing current outputs from archives"
description: "Which outputs are generated and overwritten, how dated packets and checksums are preserved, and where research extracts live."
tags: [provenance, review]
sequence: 3
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: validation-index
    resource: 7416eef:data/validation/README.md
    title: "data/validation/README.md Current outputs versus archives, as of commit 7416eef (moved here verbatim)"
---

Moved verbatim from the validation index as of commit `7416eef` (2026-09-26); review-sheet
sizes below describe that checkpoint. The [status report](../project/status.md) holds the
live state.

# Research extracts outside the pipeline

The [initial research notes](../../data/validation/museum_research_2026-09-15.csv) retain earlier leads; use the
later reports and evidence ledgers for resolved questions. The 38-row
[Overture context extract](../../data/validation/museum_identity_review_2026-09-15/overture_context.csv) is
archived research outside the pipeline, as is the later 41-row
[Old Jail extract](../../data/validation/museum_old_jail_review_2026-09-15/overture_context.csv) and 21-row
[Union County extract](../../data/validation/museum_union_county_review_2026-09-17/overture_context.csv), the
22- and 18-row [leaders extracts](../../data/validation/museum_leaders_review_2026-09-23/overture_context.csv) and the
15-row [methodology extract](../../data/validation/museum_methodology_2026-09-23/overture_context.csv).
Their queries and checksums are recorded in
[`data/raw/MANIFEST.json`](../../data/raw/MANIFEST.json); `tar_make()` does not recreate them.

# Generated outputs versus dated archives

`data/processed/museum_review/` is generated and overwritten. The current saved review
(M2 checkpoint) contains 432 candidate institutions, 557 source rows and 84 nearby pairs,
with a top-20 cutoff of six non-chain entities; Old Jail Museum leads at eight. It also writes `chain_summary.csv`, `chain_overlap.csv`
and `not_museum_review.csv`. The original
packet's 470 institutions, 551 rows and 159 pairs remain valid historical counts.
Diagnostic pair labels remain blank; they are not another completed validation sample.
`multisite_review` still describes the automatic baseline (249 entities).
Union County's (three) and Washington County's (four) exact-name groups
fall below that cutoff. Their packets' reviewed-institution files and follow-up queues retain those
cases, including ones merged into differently named institutions; check `museum_analysis` for
current IDs on later revisits.

The identity audit and reviewed Parquet have separate export targets. Use the complete
[selective build](../../README.md#running) to refresh them along with the review sheets.
The general archive helper reads saved targets, retains leading rankings with cutoff ties,
and refuses an existing destination. It does not archive the identity decisions/audit or
copy the inputs named in its checksums. Preserve a complete identity checkpoint separately,
following the latest packets' before/after decisions, records, evidence and audit.

Keep dated packet CSVs, reproduction scripts, logs and checksum files unchanged.
Git preserves every file under `data/validation/` and the raw manifest byte for byte,
including line endings, so checkout cannot invalidate their recorded checksums.
Historical checksums for live inputs, code or documentation describe the versions used
then; later changes do not justify replacing those hashes. Report navigation notes can
point to subsequent work without replacing checkpoint findings. Existing navigation
in checksum-protected reports describes the updates known at that checkpoint; use
this index for the latest state.

The [original IMLS rows](../../data/validation/museum_focused_review_2026-09-15/imls_original_rows.csv) exposed
the fields missing from the earlier dossiers. Generated source sheets and future archives
now retain EIN and separate physical/mailing street, city, state and ZIP fields as text.
Institution sheets add source-ID-labelled EIN and address summaries. Legacy coalesced
fields remain available, but should not replace the separate fields in identity research.
These additions leave the dated packets and all count/identity decisions unchanged; see
the [review-field guide](../playbooks/complete-museum-review.md).
The [staged publication locations](../../data/validation/museum_address_review_2026-09-15/publication_locations.csv)
carry operator points for Mandeville, Smedley and Peters Creek with separate publication
fields and dated access wording. The pipeline/Parquet do not yet consume this table;
source coordinates and generated map links remain unchanged. The address packet also
preserves selected IRS rows, manifest snapshots and the public Smedley map marker.
