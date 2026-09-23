# Museum validation and review evidence

**Current checkpoint: 2026-09-23 [chain separation and not-a-museum decisions](museum_methodology_2026-09-23.md).**
The headline (M1/M2) now excludes chain-affiliated locations, which are reported
beside it, and a sourced `not_museum` decision removes non-museum records from the count.
The reviewed data retain 60,002 source rows, with 57,292 counted rows, 52,584 counted
institutions and 52,452 eligible for L2 name analysis. Counts remain provisional.
Nineteen institutions have complete factual reviews. Franklin, Greene and Jackson County
Historical Society and Old Jail Museum lead at 11 non-chain institutions; every leading
group still fails publication certification. See the
[follow-up queue](museum_methodology_2026-09-23/follow_up.csv), the
[leaders queue](museum_leaders_review_2026-09-23/follow_up.csv), the
[Union County queue](museum_union_county_review_2026-09-17/follow_up.csv) and the
[project handoff](../../HANDOFF.md) for the remaining work.

## Decision inputs and human labels

The three decision/rule files feed the pipeline. Preserve their prior contents in a new
dated packet before applying further decisions; dated copies describe their own checkpoint.
The human-label archive is a separate, unchanged input to resolution scoring.

| File | Purpose |
|---|---|
| [museum_chain_rules.csv](museum_chain_rules.csv) | Sourced brand-affiliation rules and ambiguous-name review hints; unknown does not mean independent |
| [museum_identity_decisions.csv](museum_identity_decisions.csv) | Explicit membership over the automatic `entities` baseline; 92 rows in 37 cases, including five source-conflict holdouts |
| [museum_decisions.csv](museum_decisions.csv) | Naming/category (including sourced `not_museum`), affiliation and overall review decisions, keyed to source records and expected names after identity reconciliation |
| [resolution_labelling_2026-09-15.csv](resolution_labelling_2026-09-15.csv) | Authoritative archive of 300 independent human pair labels; preserve unchanged and use for scoring |

The identity layer produces `museum_records`; `museum_analysis` then selects one canonical
name per entity and applies naming/affiliation decisions. Identity evidence is not an
independent matching label. Do not carry a historical-name hold onto a reconciled current
name, or infer ownership from a repeated naming template.

## Dated checkpoints, in order

The September 15 checkpoints share a date; the Union County batch follows on September 17 and the leaders review and methodology checkpoint on September 23.
Their descriptive names identify successive stages, not interchangeable copies of the latest results.

| Report | Evidence and role |
|---|---|
| [Resolution validation](resolution_validation_2026-09-15.md) | Original human-label evaluation: precision 99.17%, recall 93.70% at 0.85; sampled pairs within 150 m, not final-cluster or dataset-wide accuracy |
| [Initial Phase 2 analysis](museum_analysis_2026-09-15.md) | [Initial packet](museum_review_2026-09-15/): canonical L2 metrics, category holds, affiliation rules and review sheets; 52,497 eligible entities |
| [First source pass](museum_source_review_2026-09-15.md) | [Source packet](museum_source_review_2026-09-15/): 51 source rows researched; naming and affiliation decisions increase eligibility to 52,501 without changing baseline identity |
| [First identity pass](museum_identity_review_2026-09-15.md) | [Identity packet](museum_identity_review_2026-09-15/): nine cases reconcile 25 rows from 24 baseline entities into nine institutions; 52,621 counted and 52,489 eligible |
| [Focused follow-up](museum_focused_review_2026-09-15.md) | [Focused packet](museum_focused_review_2026-09-15/): LeMoyne consolidation, two isolated conflicts and Mandeville map evidence; 52,619 counted and 52,487 eligible |
| [Address follow-up](museum_address_review_2026-09-15.md) | [Address packet](museum_address_review_2026-09-15/): Chipley mailing and Peters Creek house/society consolidations; staged publication points; 52,617 counted and 52,485 eligible |
| [Old Jail review](museum_old_jail_review_2026-09-15.md) | [Old Jail packet](museum_old_jail_review_2026-09-15/): 15 leading-name candidates researched; 23 members in nine new cases, two complete factual reviews and sourced HTA affiliation; 52,605 counted and 52,473 eligible |
| [Union County review](museum_union_county_review_2026-09-17.md) | [Union County packet](museum_union_county_review_2026-09-17/): all 14 starting candidates researched; six corrections cover 15 source rows; exact-name group falls to seven and Creston is verified; 52,597 counted and 52,465 eligible |
| [Provisional leaders review](museum_leaders_review_2026-09-23.md) | [Leaders packet](museum_leaders_review_2026-09-23/): all 26 Museum of Illusions and Washington County Historical Society candidates researched; eight cases cover 19 source rows, one a new source conflict; 13 new complete reviews; 52,588 counted and 52,456 eligible |
| [Chain separation and not-a-museum](museum_methodology_2026-09-23.md) | [Methodology packet](museum_methodology_2026-09-23/): headline excludes chains, chain summary/overlap outputs, 14 city-suffixed Museum of Illusions locations affiliated, Atlanta duplicate reconciled, three sourced not-a-museum records; 52,584 counted and 52,452 eligible |

The [initial research notes](museum_research_2026-09-15.csv) retain earlier leads; use the
later reports and evidence ledgers for resolved questions. The 38-row
[Overture context extract](museum_identity_review_2026-09-15/overture_context.csv) is
archived research outside the pipeline, as is the later 41-row
[Old Jail extract](museum_old_jail_review_2026-09-15/overture_context.csv) and 21-row
[Union County extract](museum_union_county_review_2026-09-17/overture_context.csv), the
22- and 18-row [leaders extracts](museum_leaders_review_2026-09-23/overture_context.csv) and the
15-row [methodology extract](museum_methodology_2026-09-23/overture_context.csv).
Their queries and checksums are recorded in
[`data/raw/MANIFEST.json`](../raw/MANIFEST.json); `tar_make()` does not recreate them.

## Current outputs versus archives

`data/processed/museum_review/` is generated and overwritten. The current saved review
contains 457 candidate institutions, 560 source rows and 149 nearby pairs, with a top-20
cutoff of 8 non-chain entities. It also writes `chain_summary.csv`, `chain_overlap.csv`
and `not_museum_review.csv`. The original
packet's 470 institutions, 551 rows and 159 pairs remain valid historical counts.
Diagnostic pair labels remain blank; they are not another completed validation sample.
`multisite_review` still describes the automatic baseline (249 entities).
Union County's (seven) and Washington County's (four in the headline) exact-name groups
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

The [original IMLS rows](museum_focused_review_2026-09-15/imls_original_rows.csv) exposed
the fields missing from the earlier dossiers. Generated source sheets and future archives
now retain EIN and separate physical/mailing street, city, state and ZIP fields as text.
Institution sheets add source-ID-labelled EIN and address summaries. Legacy coalesced
fields remain available, but should not replace the separate fields in identity research.
These additions leave the dated packets and all count/identity decisions unchanged; see
the [review-field guide](../../README.md#completing-a-museum-review).
The [staged publication locations](museum_address_review_2026-09-15/publication_locations.csv)
carry operator points for Mandeville, Smedley and Peters Creek with separate publication
fields and dated access wording. The pipeline/Parquet do not yet consume this table;
source coordinates and generated map links remain unchanged. The address packet also
preserves selected IRS rows, manifest snapshots and the public Smedley map marker.

## Reproduce without rebuilding

Run from the repository root in the restored R 4.4.2 environment:

```r
for (f in list.files("R", pattern = "[.]R$", full.names = TRUE)) source(f)
dn_score_labels("data/validation/resolution_labelling_2026-09-15.csv")

# Requires the saved automatic entities target and the original working label
# copy noted below. Checks archived decisions and before/after counts in memory.
source("data/validation/museum_old_jail_review_2026-09-15/reproduce.R")

# Requires live identity decisions and saved reviewed targets/Parquet exports
# to match the methodology checkpoint, in addition to replaying archived decisions.
source("data/validation/museum_methodology_2026-09-23/validate.R")
```

The methodology, leaders and Union County validators check the saved state current at their
checkpoint as well as their archives. The leaders and Union County validators' live
comparisons now fail by design, because later decisions and the headline code changed that
state; their archived replays remain valid.
Keep the dated validator unchanged and record later verification in a new packet.

Both packet checks also verify protected-file hashes, including the original
`data/processed/resolution_labelling.csv`. That working copy is ignored by Git; on
another machine, restore it from the authoritative label archive only if the working
path is absent. Preserve any newer completed labels separately before replacing a
different working copy. Label scoring alone needs only the tracked archive.

These commands do not rebuild targets or rewrite labels. A full `tar_make()` or rebuild of
`labelling_sheet` can overwrite the working labels in `data/processed/`; archive any new
human decisions first. Before exporting selected headlines, explicitly call
`dn_assert_museum_publication_ready()` and complete the factual checks described in
[README.md](../../README.md#completing-a-museum-review). The pipeline does not call that
helper automatically.
