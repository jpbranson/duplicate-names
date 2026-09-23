# duplicate-names

Analysis pipeline behind a series of blog posts on duplicated institutional
names in the United States: museums that claim to be *the* one, and churches
that solved the same problem by numbering themselves.

Start with **[DESIGN.md](DESIGN.md)** — questions, data sources, metric
definitions, decisions, and the phase plan. **[HANDOFF.md](HANDOFF.md)** is the
fastest way to resume work: current state, the next task, and the traps. Analogous
namespaces worth a future post are tracked in **[LEADS.md](LEADS.md)**.

## Setup

Use **R 4.4**, preferably the lockfile version **4.4.2**, with `renv`. From the
project root:

```r
renv::restore()      # restore the pinned dependencies
```

This is an R analysis project, not an R package. Keep `DESCRIPTION` as
`Type: Project` without a `Package:` field.

## Current status — 2026-09-17

**Phase 2 tooling and focused source/identity passes are complete;
remaining headline checks precede the museum post.** The pipeline uses Overture Places release
`2026-08-19.0` and the IMLS 2018 Museum Universe Data File. All **60,002 source rows**
are retained. Current saved outputs distinguish the automatic baseline from curated
corrections:

| Stage | Counted source records | Counted entities | Eligible for name analysis |
|---|---:|---:|---:|
| Automatic baseline (`entities`) | 57,348 | 52,636 | Category policy applied downstream |
| After nine identity corrections (`museum_records` → `museum_analysis`) | 57,332 | 52,621 | 52,489 |
| After focused follow-up and two source-conflict holds | 57,329 | 52,619 | 52,487 |
| After address follow-up | 57,327 | 52,617 | 52,485 |
| After Old Jail review | 57,313 | 52,605 | 52,473 |
| After Union County review (current) | 57,305 | 52,597 | 52,465 |

These are provisional counts; remaining source checks precede publication.

All **300 candidate pairs** have independent human labels. At the retained
**0.85** threshold, sample precision is **99.17%** and recall is **93.70%**
(119 true merges, 1 false merge, 8 missed merges, 172 true separations).
These are unweighted results from five equally sampled similarity bands within
150 m; they do not establish dataset-wide accuracy or validate final clusters.
See the [validation report](data/validation/resolution_validation_2026-09-15.md).

The [initial Phase 2 report](data/validation/museum_analysis_2026-09-15.md) records the
analysis implementation; the [identity report](data/validation/museum_identity_review_2026-09-15.md)
preserves the first identity checkpoint. The [Old Jail review](data/validation/museum_old_jail_review_2026-09-15.md)
preserves the preceding checkpoint; the [Union County review](data/validation/museum_union_county_review_2026-09-17.md)
has the latest counts and remaining cases. M1/M2 now count one canonical L2 name
per entity; the old helper counted source rows and aliases. Category-only names are
held pending evidence, known brand affiliations have sourced rules, unknown affiliation
stays unknown, and M3 uses explicit topic extraction with an IMLS comparison.

`museum_review_files` writes the ranking, top-20 institution/source sheets (including
cutoff ties and leading M2 candidates), category queue, and nearby-pair diagnostics to
`data/processed/museum_review/`. Preserve completed decisions in the tracked
`data/validation/museum_decisions.csv`, keyed by source record and expected name.
Use the generated sheets for current candidates. Union County's exact-name group is
now below the top-20 cutoff; its
[reviewed institutions](data/validation/museum_union_county_review_2026-09-17/reviewed_institutions_after.csv)
and [follow-up queue](data/validation/museum_union_county_review_2026-09-17/follow_up.csv)
preserve those cases. Check `museum_analysis` for current IDs when revisiting any dated packet.
No headline count is certified by these automated analyses.

The [source-verification report](data/validation/museum_source_review_2026-09-15.md)
records checks of 51 source records, including all 13 University Art Gallery and all
13 Museum of Illusions candidates. Official-source research can be completed by an
assistant; it is separate from the independent human labels used to measure matching
accuracy. That pass released four additional gallery category holds, recorded four
historical-name holdouts, and established 11 location-specific brand affiliations.

The subsequent [identity-reconciliation report](data/validation/museum_identity_review_2026-09-15.md)
records 25 source rows reconciled from 24 baseline entities into nine institutions.
`entities` retains the automatic baseline. At that checkpoint, `museum_records` had
**52,621 counted entities**, with **52,489 eligible for name analysis**. Source rows and
original coordinates remain intact, with a before/after audit. These factual corrections
do not change the 0.85 algorithm or establish new matching-accuracy estimates.
Three historical gallery names now survive as aliases of current institutions. The
remaining category queue has five confirmed names, one historical-name holdout (NMSU),
and 131 pending decisions.

The [focused follow-up](data/validation/museum_focused_review_2026-09-15.md) consolidates
the clean LeMoyne House records and isolates two contradictory IMLS rows. The later
[address follow-up](data/validation/museum_address_review_2026-09-15.md) reconciles Chipley's
mailing record and the Peters Creek house/society records. The September 15
[Old Jail review](data/validation/museum_old_jail_review_2026-09-15.md) examines all 15
starting candidates, consolidates related museum/society/mail records and isolates two
mixed Dubuque rows. That checkpoint has **52,605 counted entities** and **52,473 eligible**.
Old Jail Museum falls to 12; Union County Historical Society then led provisionally at 14.
Washington County Historical Society stays at 13. The identity input then covered
**56 source rows in 22 cases**, including four isolated source conflicts.

At the Old Jail checkpoint, Albion and Jim Thorpe received complete factual reviews;
St. Augustine has a sourced Historic Tours of America affiliation. Ten Old Jail reviews
remain pending, so its publication gate still rejects certification. **192 assertions and 23 integrity checks
passed at that checkpoint.** Bankhead and Lafayette Street still need museum evidence.
Operator points for Mandeville, Smedley and Peters Creek remain staged for publication;
source coordinates are unchanged.

The September 17 [Union County batch](data/validation/museum_union_county_review_2026-09-17.md)
reviews all 14 starting candidates. Six corrections cover 15 source rows, reducing
the exact-name count to **7**, counted institutions to **52,597** and eligible
institutions to **52,465**. Creston's Historical Village has a complete factual review
and supported independent operation; all seven remaining exact-name institutions stay pending.
The identity input now covers **71 rows in 28 cases**. **195 assertions and 23
integrity checks passed**, including preservation of the baseline, original source
fields, labels and 125 protected files. Neither provisional leader at 13 (Museum of
Illusions and Washington County Historical Society) is publication ready.

The regenerated review sheets contain **435 candidate institutions, 535 source rows
and 143 nearby pairs**. The original dated packet's 470 institutions, 551 rows and
159 pairs describe an earlier checkpoint. Use the
[validation index](data/validation/README.md) to distinguish live decision inputs,
historical evidence and the latest follow-up queue.

The IMLS dossiers now include EIN and separate physical/mailing addresses, with source IDs
attached to the institution summaries. The earlier dossier-only rebuild refreshed three targets;
192 assertions and 23 integration checks passed, with counts and decisions unchanged.
See the [review-field guide](#completing-a-museum-review) before continuing source checks.

Church acquisition is queued for Phase 1b, after the museum post. The dashboard
comes after the first two posts. See [HANDOFF.md](HANDOFF.md) for the work queue.

## Running

For the current museum review, build these targets without regenerating the human-label sheet:

```r
targets::tar_make(names = c(museum_review_files, museum_identity_audit_file,
                            museum_records_file, dup_museums,
                            multisite_review, entities_file))
targets::tar_visnetwork()    # see the DAG
source("tests/testthat.R")  # source project functions and run tests
```

The pipeline acquires and normalizes museums, resolves the automatic baseline, applies
curated identity and naming/affiliation decisions, then computes metrics and review sheets.
`data/processed/entities.parquet` and `multisite_review` retain the automatic baseline;
`data/processed/museum_records.parquet` contains the reviewed source records.
`museum_identity_audit_file` writes `data/processed/museum_review/identity_audit.csv`.
The audit and reviewed Parquet are separate export targets, so building
`museum_review_files` alone does not refresh them. Stage outputs are checked against
`R/schema.R`. Cold runs download public datasets; cached inputs speed up later runs.

**Preserve human labels before a full `targets::tar_make()` or any rebuild of
`labelling_sheet`.** That target
rewrites `data/processed/resolution_labelling.csv`. The completed September 15
labels are archived in `data/validation/`, outside the generated directories.
Score that archive without rebuilding the pipeline:

```r
for (f in list.files("R", pattern = "[.]R$", full.names = TRUE)) source(f)
dn_score_labels("data/validation/resolution_labelling_2026-09-15.csv")
```

After the selective build above, run the archive helper from a terminal at the repository
root, supplying a new review date:

```sh
Rscript scripts/archive_museum_review.R YYYY-MM-DD
```

It reads saved targets and archives the leading rankings (including cutoff ties),
review sheets and baseline multi-site queue into `data/validation/museum_review_YYYY-MM-DD/`.
It neither builds targets nor copies the entire generated export directory, and it refuses
an existing destination. Its checksums identify the manifest, chain rules, naming decisions
and archived labels; the helper does not copy those inputs. It does **not** archive
identity decisions or the identity audit, or include identity decisions in its checksums.
For an identity-correction checkpoint, also preserve those inputs, before/after records,
evidence and hashes, following the
[identity packet](data/validation/museum_identity_review_2026-09-15/) and
[focused packet](data/validation/museum_focused_review_2026-09-15/) or the latest
[Union County packet](data/validation/museum_union_county_review_2026-09-17/). Existing dated
packets and completed human labels are historical evidence, not generated scratch files.

### Completing a museum review

Apply identity membership in `museum_identity_decisions.csv` before assigning naming,
category and affiliation decisions in `museum_decisions.csv`. The identity file must list
every member of each affected baseline cluster. Naming decisions address one resulting
entity through a source key and exact expected name; after a reconciliation, replace any
former-name hold with a decision appropriate to the current name and archive the old input.
The generated dossiers now retain IMLS EIN and separate physical/mailing addresses.
The old coalesced fields remain for compatibility; use the separate fields for identity
research. All identifiers and ZIP codes are read as text to preserve leading zeros.

| Review fields | Source and meaning |
|---|---|
| `imls_ein` | Original IMLS `EIN`; a research clue, not an automatic identity rule |
| `imls_physical_street/city/state/zip/zip5` | Original `PHSTREET`, `PHCITY`, `PHSTATE`, `PHZIP`, `PHZIP5`; missing fields stay missing |
| `imls_mailing_street/city/state/zip/zip5` | Original `ADSTREET`, `ADCITY`, `ADSTATE`, `ADZIP`, `ADZIP5` |
| `imls_physical_address`, `imls_mailing_address` | Readable addresses formatted per original row before repeated MIDs are combined |
| `imls_street`, `imls_city`, `imls_state` | Legacy per-field physical-to-mailing fallback; these can mix address types |

`source_records.csv` and `multisite_records.csv` include all these fields. The institution
sheet adds `imls_ein_2018`, `imls_physical_address_2018` and `imls_mailing_address_2018`,
with each value tied to its IMLS source ID. Repeated archive values are separated by ` | `;
they are alternatives for review, not evidence of multiple physical sites. Future archives
retain the expanded fields. Earlier dated packets remain unchanged.
This is 2018 source context, not verification of current identity or visitor access.

Before exporting chosen headlines, call
`dn_assert_museum_publication_ready(analysis, name_values)` with the current
`museum_analysis` table and the selected L2 names. This helper is **not called by the
pipeline automatically**. It checks recorded eligibility, review and affiliation statuses;
it cannot verify source evidence, the meaning of an M2 scope claim, visitor access or
map accuracy. Complete those checks as relevant to the post.

The generated `lon`, `lat` and `map_url` still describe selected source points.
The [staged location table](data/validation/museum_address_review_2026-09-15/publication_locations.csv)
has separate `publication_lon`/`publication_lat` and dated access wording for Mandeville,
Smedley and Peters Creek. It is not yet consumed by the pipeline or Parquet exports.
Apply those fields during publication export and refresh access wording, preserving source
coordinates and evidence. See the [current queue](data/validation/museum_union_county_review_2026-09-17/follow_up.csv)
for the remaining source checks and the
[address queue](data/validation/museum_address_review_2026-09-15/follow_up.csv) for location details.

## Layout

| Path | What |
|---|---|
| `_targets.R` | Pipeline DAG |
| `R/schema.R` | Stage contracts, validation and source binding. Start here. |
| `R/src_*.R` | Implemented Overture/IMLS adapters; queued source stubs in `src_others.R` |
| `R/normalize.R` | The name ladder — decides every headline number |
| `R/gazetteer.R` | Place names and exceptions for L3 geography stripping |
| `R/resolve.R` | Cross-source entity resolution |
| `R/validate_resolution.R` | Candidate-pair sampling and human-label scoring |
| `R/metrics.R` | Pre-registered metrics; M1/M2 use canonical entity names and L2 |
| `R/museums.R` | Category handling, affiliations, subjects, review queues and publication gate |
| `R/museum_review_context.R` | IMLS EIN, separate physical/mailing addresses and legacy context for review |
| `R/museum_identity.R` | Guarded source-specific corrections and before/after identity audit |
| `R/config_blog.R` | Every blog-dependent setting, in one place |
| `R/theme_dupnames.R` | ggplot2 theme, palette, scales |
| `R/embed.R` | Builds and deploys self-contained map embeds |
| `posts/` | Shared setup and a template for future Hugo page bundles |
| `data/raw/MANIFEST.json` | Museum input/query provenance; Census gazetteer downloads are not yet manifest-tracked |
| `data/processed/` | Baseline/reviewed Parquet, review sheets, identity audit and labelling sheet; gitignored |
| [`data/validation/`](data/validation/README.md) | Human labels, sourced decisions, evidence packets and dated reports; index distinguishes live inputs from archives |
| `scripts/archive_museum_review.R` | General review-packet archive helper; identity artifacts need separate preservation |
| `tests/testthat/data/raw/` | Immutable IMLS ZIP fixture and provenance; adapter caches are ignored |

## Two things worth knowing before changing anything

**The normalizer decides the findings.** Duplicate counts are an artifact of
how aggressively names are collapsed, so `R/normalize.R` is tested first and
`tests/testthat/test-normalize.R` is a gold set, not a smoke test. Never edit an
expectation to make a test pass.

**Museum name headlines use L2 (`name_expanded`).** The L3 gazetteer step is
implemented, but stripping geography often removes part of a museum's identity.
Use L3 (`name_core`) for geography-stripped comparisons and as input to the
subject analysis; churches will use L3 for their name counts. M2's former L3
implementation mismatch has been corrected. The resolved-record table retains all
source rows; `museum_analysis` is the one-row-per-entity analysis table.

## Blog

Posts will be drafted here and handed to a separate R blogdown repo as a payload:
`index.Rmd` plus the small aggregated files it reads. The blog repo never needs
`duckdb`, `sf`, or `arrow` to build. Set `DUPNAMES_BLOG_DIR` to point at it; all
other blog settings live in `R/config_blog.R` (see DESIGN.md §7.3).
The current template still sources shared helpers from this analysis checkout;
packaging those helpers with the post and verifying an independent knit remain
part of Phase 2.

## Data licensing

The current museum pipeline uses Overture and IMLS. The planned church extension
adds GNIS and HIFLD, with OpenStreetMap reserved for internal enrichment and
validation under the project's licensing plan. Review licensing and attribution
before releasing tables or figures that depend on OSM contributions. See
DESIGN.md §7; the published dataset's destination is still undecided.
