# Handoff

**Last session:** 2026-09-18 documentation audit · **Phase:** 2 Union County review batch complete; headline review ongoing
**Repo:** https://github.com/jpbranson/duplicate-names

Read [DESIGN.md](DESIGN.md) for the plan and the numbered decisions, [LEADS.md](LEADS.md)
for future-post material, [README.md](README.md) for layout. This file is only what you
need to pick the work back up on another machine.

---

## 1. Getting running on a new machine

```bash
git clone https://github.com/jpbranson/duplicate-names.git
cd duplicate-names
```

```r
renv::restore()      # 137 packages, pinned
```

**Pin R to 4.4.** The lockfile records 4.4.2. On the previous machine R 4.6.1 was
installed but had an empty library, so a newer R will not "just work" — it will try to
rebuild everything.

For the current museum review (preserves the completed working label sheet):

```r
targets::tar_make(names = c(museum_review_files, museum_identity_audit_file,
                            museum_records_file, dup_museums,
                            multisite_review, entities_file))
source("tests/testthat.R")              # source functions, then run tests
```

Before a full `targets::tar_make()`, archive any new human labels: `labelling_sheet`
rewrites the working CSV. See [README.md](README.md#running) for scoring and archiving.

### What is NOT in the repo

`data/raw/` and `data/processed/` are gitignored. The pipeline rebuilds its generated
analysis outputs when needed — the earlier cold run took **~5 minutes**, almost all
of it the Overture S3 query and tigris gazetteer download. These inputs need no
credentials: Overture's S3 bucket is public and reads anonymously.

`data/raw/MANIFEST.json` **is** tracked, with provenance and checksums for the museum
inputs and the identity-context query. The Census 2023 gazetteer is cached separately
and is not yet recorded in the manifest. The 38-row Overture identity-context query was
research outside the pipeline; `tar_make()` does not recreate it. Its
[tracked copy](data/validation/museum_identity_review_2026-09-15/overture_context.csv)
and the manifest's SQL preserve that evidence.
The address follow-up also records the public IRS Florida/Arkansas/Pennsylvania files
and operator pages in the manifest. These research caches are outside the pipeline;
selected IRS rows and the extracted Smedley marker are tracked in the address packet.
The Old Jail packet adds a 41-row Overture context query and 19 cached operator/government
pages. Its tracked context and manifest SQL preserve the query; it is also outside the pipeline.
The Union County packet adds a 21-row Overture context query and 30 cached public documents.
Its tracked extracts, evidence ledger and manifest snapshot preserve that later research;
`tar_make()` does not recreate these acquisitions either.

Human labels are preserved separately in `data/validation/`, outside the ignored,
rebuildable directories. The archived CSV cannot be recreated by `tar_make()`.

---

## 2. Where things stand

Museums only. Churches (Phase 1b) are queued, not cancelled — see §6.

| | |
|---|---|
| Sources | Overture `2026-08-19.0` (29,894 US museums) + IMLS MUDF 2018 (30,108) |
| Baseline records | 60,002 → **57,348 counted** |
| Baseline entities | **52,636** counted |
| After curated identity corrections and source-conflict holds | **52,597** counted; **52,465** eligible for name analysis |
| Baseline excluded source records | 2,306 non-primary site · 331 permanently closed · 17 no name |
| Baseline counted entities with an alternate name | 6,181 |

Automatic resolution runs successfully; the output remains provisional. The International
Cryptozoology Museum is one entity at Bangor, with all three Portland records retained and
flagged `non_primary_site`.

The initial September 15 Phase 2 build corrected the metrics without changing baseline
assignments or flags: the previous duplicate helper counted source rows and aliases,
despite naming the result entities. `museum_analysis` selects one canonical row per
institution; M1/M2 then apply counting and name-analysis eligibility.

The later identity pass adds `museum_records` as an explicit correction layer over the
unchanged automatic `entities` baseline. Nine sourced cases reconcile 25 rows from 24
baseline entities into nine institutions. Both Parquet exports are available; use
`data/processed/museum_records.parquet` for the reviewed museum data, with
`data/processed/museum_review/identity_audit.csv` for before/after IDs and flags.
The subsequent [focused pass](data/validation/museum_focused_review_2026-09-15.md)
consolidates the clean LeMoyne House records and isolates two conflicting IMLS rows.
The [address follow-up](data/validation/museum_address_review_2026-09-15.md) also reconciles
Chipley's mailing record and Peters Creek's house/society pair. The
[Old Jail pass](data/validation/museum_old_jail_review_2026-09-15.md) adds eight accepted
identity cases and two Dubuque holdouts. At that checkpoint all 60,002 source rows remained,
with 57,313 counted source rows.
Source names and coordinates remain unchanged. The baseline multi-site queue is not
recomputed from this reviewed layer.

The [Union County pass](data/validation/museum_union_county_review_2026-09-17.md)
adds six cases covering 15 source rows, reducing counted institutions by eight.
All 60,002 source rows remain; **57,305** are counted after the latest corrections.
Union County Historical Society falls from 14 to **7** provisional exact-name institutions.
The live identity input now covers **71 source rows in 28 cases**: 26 canonical
institutions and four isolated conflicting rows. The current generated review contains
**435 institutions, 535 source rows and 143 nearby pairs**; the initial dated packet's
470/551/159 counts describe its earlier state. Albion, Jim Thorpe and Creston's
Historical Village have complete `verified` factual reviews; ten Old Jail reviews
and all seven remaining Union County exact-name institutions remain pending. See the
[validation index](data/validation/README.md) for the live inputs,
archived checkpoints and read-only reproduction commands.

---

## 3. Next work: finish the museum source checks

**Manual labelling and scoring are complete.** All 300 pairs have human labels:
127 same institution, 173 different, no blanks. The supplied `TRUE`/`FALSE` values are
read correctly by the existing scorer.

At the current **0.85** threshold: **119 true merges, 1 false merge, 8 missed merges,
172 true separations**. Precision is **99.17%**, recall **93.70%**, and sample error
**3.00%**. The scorer's F1 sweep selects **0.85**, so retain the current threshold.

The byte-for-byte archive is
[`data/validation/resolution_labelling_2026-09-15.csv`](data/validation/resolution_labelling_2026-09-15.csv).
The [validation report](data/validation/resolution_validation_2026-09-15.md) contains
the disagreements, threshold comparison, and scope limits. To reproduce:

```r
for (f in list.files("R", pattern = "[.]R$", full.names = TRUE)) source(f)
dn_score_labels("data/validation/resolution_labelling_2026-09-15.csv")
```

The measured-validation milestone is met. These are unweighted results on 60 pairs per
similarity band within 150 m, not a dataset-wide error rate or an evaluation of final
entity clusters. Multi-site merging and matches outside the candidate radius remain
unvalidated by this sample. Preserve human labels independently of matching changes.

**Current review checkpoint:** [Union County report](data/validation/museum_union_county_review_2026-09-17.md),
its updated ranking and dispositions for all 14 starting candidates. Six supported
identity corrections reconcile Georgia, Tennessee, Illinois, Florida, Iowa and New Mexico.
The [Old Jail report](data/validation/museum_old_jail_review_2026-09-15.md) preserves the
preceding ranking and evidence for all 15 of that group's starting candidates.
The [address follow-up](data/validation/museum_address_review_2026-09-15.md) retains
the earlier six-case evidence and staged map points. The
[first identity report](data/validation/museum_identity_review_2026-09-15.md),
[initial Phase 2 report](data/validation/museum_analysis_2026-09-15.md) and
[source pass](data/validation/museum_source_review_2026-09-15.md) preserve earlier states.
Use regenerated review sheets for current candidates. Union County's exact-name group
is now below the top-20 cutoff; its
[reviewed institutions](data/validation/museum_union_county_review_2026-09-17/reviewed_institutions_after.csv)
and follow-up queue preserve those cases. Check `museum_analysis` for current IDs when
revisiting dated evidence. Fresh diagnostic pair labels remain blank.

Implemented: category-only holdouts with sourced exceptions, evidence-backed brand
rules and explicit unknown affiliation, name-derived subjects with an IMLS diagnostic,
canonical-entity M1/M2 at L2, and top-20 review exports including cutoff ties, leading
M2 candidates, and the seed case. Tracked inputs are `museum_chain_rules.csv`,
`museum_decisions.csv` and `museum_identity_decisions.csv` in `data/validation/`;
generated review outputs are under
`data/processed/museum_review/`.

**Next: continue the remaining top-20 and unresolved Old Jail checks, using the
[new follow-up queue](data/validation/museum_union_county_review_2026-09-17/follow_up.csv)
for Union County's remaining evidence gaps.** The Union County batch is complete,
but its seven remaining exact-name institutions still fail the publication gate.
Oregon's mixed identity context, Monroe's unconfirmed museum status, Liberty's rural
addresses and Lewisburg's library/gallery/Packwood scope require further evidence.
Georgia, Illinois and Tennessee retain preferred-name questions. Museum of Illusions
and Washington County Historical Society now share the provisional lead at 13.
The [Old Jail report](data/validation/museum_old_jail_review_2026-09-15.md) documents the
preceding corrections and its remaining evidence gaps. National Electronics Museum now
counts once; National Vietnam War Museum has two remaining candidates (one is an
unresolved Bankhead Drive record); Washington County Historical Society falls from
19 to 16 in the first identity pass, 14 after the focused corrections and 13 after
the Chipley mailing consolidation. Old Jail Museum now falls from 15 to 12 after
Winchester consolidation and the two Dubuque holds. Union County Historical Society's
former lead of 14 fell to 7 after the September 17 batch. No headline is certified yet. Pennsylvania's
mixed Barrow row and mislabeled Venetia mailbox are isolated as source conflicts;
the latter's EIN/address identify Peters Creek Historical Society, not the LeMoyne
operator. The accepted Peters Creek house/society pair now counts once, while the
mixed IMLS row remains isolated. Bankhead and Lafayette Street still need dated museum
evidence. The broader top-20 identity/name/category/affiliation checks remain unfinished.
Old Jail follow-ups include shared local operators, Smethport's preferred name, generic
operator/campus records, older society addresses and visitor points. St. Augustine is
affiliated with Historic Tours of America; do not infer independence from unknown values.
Operator points for Mandeville, Smedley and Peters Creek are staged in the address packet's
`publication_locations.csv`, with separate publication fields and dated access wording.
The pipeline and Parquet do not yet consume these overrides. Wire them into publication
export and recheck access; Mandeville still lists an open-ended indoor closure.
The dossier improvement is now
implemented: generated source sheets and future archives retain IMLS EIN and separate
physical/mailing address fields, including ZIP codes as text. Institution summaries
tie EIN and address values to their IMLS source IDs. Use these expanded fields to
continue the focused cases; the old coalesced address fields remain only for compatibility.

The preceding [source-verification report](data/validation/museum_source_review_2026-09-15.md)
records 51 checked source rows across 46 baseline entity IDs at that checkpoint. The pass covers all 13
University Art Gallery candidates, all 13 Museum of Illusions candidates, National
Electronics Museum, National Vietnam War Museum (plus the Florida Smedley alias),
the Cryptozoology seed, and four Washington County society case groups.

That first pass applied four additional gallery category releases (five total confirmed names), four
explicit historical-name holdouts, and 11 location-specific MOI affiliations. The later
identity pass incorporates the Baylor, Stony Brook and UCSD former names as aliases of
their current institutions, leaving one explicit historical-name holdout (NMSU).
Georgia's Brown House and Old Jail remain separate museums despite their shared operator.

Official-source research and supported factual decisions are work an assistant can do.
They do not require blanket independent human approval. Independent human labels are
needed to evaluate matching accuracy; the assistant's evidence ledger is not such a
label set. Curated cluster decisions changed; the algorithm and independent labels did not. For M2,
also check whether the scope word actually asserts singularity.

After that review, explicitly run `dn_assert_museum_publication_ready()` for the selected
L2 headlines. This helper is not invoked automatically by the pipeline; it checks recorded
statuses and does not certify evidence, M2 scope semantics or visitor-map details.
Then export the small post payloads, build figures and the rank table,
package the post helpers, and draft/knit the museum post independently of this checkout.
The full Phase 2 publication exit criterion has **not** been met.

Use the nine labelled disagreements as diagnostic evidence; preserve the labels and
evaluate matching changes on fresh independent labels. The post must knit from its bundle
without the analysis checkout; the current template still needs its shared helpers packaged.

`labelling_sheet` still rewrites `data/processed/resolution_labelling.csv` when rebuilt.
Use the archived labels for scoring after a rebuild; the generated sheet is not the
authoritative copy of this completed review.

---

## 4. Open analysis and resolution questions

**1. Jaro-Winkler over-scores shared place prefixes.** `springfield museum` vs
`springfield society` scores ~0.90 on the shared prefix alone, above the merge threshold.
The realistic failure is `Springfield Art Museum` vs `Springfield Science Museum` at the
same address — genuinely different museums that the current measure may merge. This is
the most likely over-merge in the pipeline.

The labelled sample contains one false merge: `Trinidad History Museum` versus
`TRINIDAD HISTORICAL SOCIETY` (P0181, similarity 0.945). The sample supports keeping
0.85 overall; it does not establish that shared prefixes or museum/society substitutions
are always safe. The existing test documents the prefix risk.

**2. Cross-source merging may still be too weak.** The automatic baseline has 52,636 entities from
57,348 counted records, but no independently verified national total. The sample has eight
missed matches, but lowering the threshold to 0.80 produces 31 false merges for only two
additional true merges. Investigate aliases and abbreviations before lowering it.

**3. Category-only names remain reviewable holdouts.** `art gallery` (37) and
`planetarium` (14) are preserved in the unfiltered ranking. Cal Poly confirms that
University Art Gallery can be an actual name; UC San Diego documents it as a former name.
Neither fact supports blanket exclusion or blanket inclusion of all such records.

**4. 249 entities in the baseline multi-site review queue** (`targets::tar_read(multisite_review)`),
top spread 598 km. Each is either a relocation, a genuine multi-site institution, or two
unrelated museums wrongly merged. Names and coordinates alone cannot separate them.

**5. Incomplete for post 1:** subject extraction is deliberately partial, with unknowns
retained; discipline compatibility is not an accuracy score. Sourced brand rules replace
the operator shortcut, but most individual locations remain unverified. Museum of Illusions
now has 11 location-specific global-network affiliations; Hollywood and Miami still have
unresolved affiliation. Brand affiliation does not establish common legal ownership.

**6. M2 is now L2, with unknowns reported separately.** Its candidates expose unresolved
duplicates and relocations beyond 150 m (for example the Texas Bankhead Drive record).
Lexical words such as American can also describe a subject rather than a singular claim.

The National Electronics case is now reconciled, including its Historical Electronics
alias. The museum's home page announces relocation to Middle River and dates Hunt Valley
tour closure to January 30, 2026; the older hours page still lists Hunt Valley. Retain
the institution, but do not describe it as open for visits during this transition.

---

## 5. Things that will bite you

- **Overture's `sources[].update_time` must exclude `provider = 'overture'`.** Overture's
  own entries are stamped with the release date, which pins every row to the same day and
  destroys the freshness signal. This is already handled in `R/src_overture.R` — do not
  "simplify" it.
- **`operating_status` does not catch stale records.** Overture still marks old Portland
  Cryptozoology Museum records "open". The official site dates the new Bangor home to
  June 1, 2026; 2016 was the move to Thompson's Point within Portland, not to Bangor.
  The official visit page also lists 585 Hammond Street, Bangor as closed. The
  selected Bangor coordinate was checked against the official 490 Broadway map link:
  it is 5.9 m from the linked destination. This is a source check, not a field survey.
- **IMLS CSVs are Windows-1252.** Handled in `R/src_imls.R`. Read as UTF-8 they corrupt 42
  names and those museums silently fail to match.
- **IMLS is a 2018 snapshot** and will never update. It is evidence a museum existed in
  2018, never that one exists now. Its `source_update_time` says so honestly.
- **L3 (`name_core`) is the wrong default for museums.** Stripping place names suits
  churches; for museums the place is usually the identity. Museum headlines use **L2
  (`name_expanded`)**. L3 supports geography-stripped comparisons and the bounded M3
  subject analysis; it is not a substitute for subject extraction. Do not "fix" the
  museum headline metric to use L3.
- **`DESCRIPTION` must keep `Type: Project` and no `Package:` field**, or renv reclassifies
  the project as an R package and relocates the library out of `renv/library`, orphaning
  every installed package.
- **Distances use `sf` on s2 geometry.** Never project to a national CRS and measure
  Euclidean distance.
- Windows has no `tippecanoe`. Not needed at this scale — plain GeoJSON is fine.

---

## 6. Phase 1b — churches, when the time comes

Queued, not cancelled (DESIGN.md §9 decision 5). The stubs are in `R/src_others.R` with
their notes intact, and `_targets.R` carries the wiring in a comment block at the bottom.
The schema is already church-shaped (`denomination`, `religion`, `ordinal`, `place_geoid`),
so 1b extends the pipeline rather than reopening it.

Still owed: GNIS 2021 Church archive, HIFLD, OSM (for the `denomination` tag C4 needs),
Overture religious categories, and the `tigris` Census-places denominator for C2.

**Do not assume the normalizer generalizes.** Matching validation covers museum source
data; church-specific blind spots remain possible. Re-run and extend the existing gold
set with church cases *added*.
Two known gaps that only matter for churches:

- Compound ordinals (`Twenty Third`) return `NA`. C3's headline is the *highest* observed
  ordinal and the highest ones are compound, so this biases that number downward. There is
  a test documenting the gap.
- L3 stripping is *right* for churches and wrong for museums — the opposite of the museum
  default above.

---

## 7. Session log

2026-09-18 documentation audit: checked all 15 project Markdown/R Markdown files
against the latest Union County packet, saved targets and code. Updated stale current
counts and latest-report links in DESIGN and LEADS; clarified research-cache provenance,
historical checkpoints, access to reviewed cases below the top-20 cutoff and the current-state
requirements of the Union County validator. All 210 local links, 14 R documentation
blocks and six selective-build target names passed checks. The read-only Union County
replay passed all 23 integrity checks; review sizes, category decisions, provisional
leaders, publication holds and original 0.85 label scores match the documentation.
All 227 protected project and generated files are unchanged, including dated evidence,
decision inputs, human labels and code. No pipeline rebuild or new factual decisions.
Next analysis work remains the top-20 reviews and unresolved cases in the latest follow-up queue.

2026-09-17 Union County review: all 14 starting candidates researched; six sourced
identity cases reconcile 15 source rows into six institutions, reducing counted
institutions by eight to 52,597 (52,465 eligible). Exact-name count falls 14 to 7;
Creston's Historical Village is verified independent, while the remaining exact-name
group stays pending. Queried 21 Overture context rows and cached 30 public documents;
one city-page cache attempt returned 404. R 4.4.2: 195 assertions and 23 integrity
checks passed, including unchanged baseline/multisite targets, source fields and 125
protected files. Review sheets, both Parquet exports and the identity audit are current.
The [packet](data/validation/museum_union_county_review_2026-09-17.md) preserves decisions,
candidate dispositions, evidence, counts and follow-ups. Stopped after this batch for
the user's requested check-in; no publication or next-group research started.

2026-09-16 repository cleanup: removed two unreferenced test Parquet caches and
package-only `.Rbuildignore`; retained the IMLS ZIP fixture and its provenance.
Moved source binding into `R/schema.R`, reused the entity schema for empty resolution,
and removed an unused manifest lookup, resolver bookkeeping and an unreachable guard.
Removed five unused direct dependency declarations; only `tarchetypes` left the lockfile
(137 packages remain), and the directly used `units` is now explicit. Planned church
and publishing tools, legacy review fields and the unused `stale_before` argument remain.
R 4.4.2: 195 assertions passed; all 29 targets built from cached inputs in an isolated
workspace. With the original `C` collation, all target values and 14 exported files
match the saved baseline exactly; all 129 protected files remain unchanged. The blog
template renders, the archive CLI writes its 11 files and refuses overwrites,
dependency checks pass, and 180 local links/13 R blocks validate.
Alias ordering depends on collation; pinning that behavior is separate reproducibility
work. The analysis queue is unchanged: Union County's 14 candidates and pending reviews.

2026-09-15 pre-commit documentation audit: reviewed all 14 project Markdown/R Markdown
files against code, saved targets and the dated evidence. Corrected the current queue,
verified-review status, Washington County count history and research-provenance coverage;
documented the packet replay's working-label prerequisite. All 180 local links, 13 R
documentation blocks and six selective-build target names passed checks. R 4.4.2:
192 assertions passed with no test failures, warnings or skips. Replayed the Old Jail
counts and all 92 protected-file checks, confirmed current review sizes and reproduced
the original 0.85 label scores. Extended Git's byte-preservation rules to nested evidence
packets and the manifest; all 128 staged evidence/manifest files retain their SHA-256
after a fresh index checkout. Historical packets
and labels remain unchanged; no pipeline rebuild or new factual decisions.
Next analysis task remains Union County's 14 candidates and the unresolved review queue.

2026-09-15 Old Jail review: examined all 15 leading-name candidates, recovered 41 pinned
Overture context rows, and applied 23 explicit members in nine cases. Eight canonical
institutions plus two new Dubuque source-conflict holds reduce counted institutions by
12 to 52,605 (52,473 name-eligible); Old Jail falls from 15 to 12. Union County Historical
Society leads provisionally at 14. Albion and Jim Thorpe receive complete factual reviews;
St. Augustine receives sourced HTA affiliation. The Old Jail publication gate still rejects
pending reviews. R 4.4.2: 192 assertions and 23 integrity checks passed; 15 targets rebuilt,
13 skipped. All 92 protected files, baseline and original source fields are unchanged;
20 new provenance hashes match. Updated docs and the
[report/queue](data/validation/museum_old_jail_review_2026-09-15.md). Next: Union County's
14 candidates and remaining name/affiliation/identity questions; map export stays later.

2026-09-15 address follow-up: the expanded dossiers and primary IRS files link Chipley's
mailing record to its museum. Operator pages/GPS reconcile the Peters Creek house/society
pair; both contradictory IMLS rows remain isolated. Four accepted source rows now count
as two institutions. Counts: 52,617 counted, 52,485 eligible; Washington County Historical
Society 13. Smedley's public map marker is recovered; publication coordinates and dated
access wording for it, Mandeville and Peters Creek are staged separately. Bankhead and
Lafayette Street remain unresolved. R 4.4.2: 192 assertions and 18 integrity checks passed;
15 targets rebuilt, 13 skipped; only `labelling_sheet` outdated. All 63 protected files,
baseline data, original source fields and unaffected records are unchanged. Updated
project docs and the [report/queue](data/validation/museum_address_review_2026-09-15.md).
Next: finish broader top-20 factual review and remaining identity evidence, then wire
staged points into publication export with refreshed access checks.

2026-09-15 IMLS dossier expansion: added EIN and separate physical/mailing street,
city, state and ZIP fields to the review context, plus readable addresses assembled
before repeated source IDs are combined. Institution sheets show source-ID-labelled
EIN/address summaries; source and multi-site sheets retain all context fields. The
archive helper now preserves these additions. Counts, memberships, earlier review
columns and coordinates are unchanged: 52,619 counted institutions and 52,487 eligible.
R 4.4.2: 192 assertions passed, no test failures, warnings or skips; 23 integration
checks passed, including an isolated run of the archive CLI. Three targets rebuilt,
25 skipped; only `labelling_sheet` remains outdated. All 64 protected-file hashes
match, including both human-label files, decision inputs, earlier evidence packets,
identity audit and Parquet exports. No new source adjudications or accuracy claims.
Next: use the expanded dossiers to continue the focused source checks in §3.

2026-09-15 documentation follow-up: synchronized the leads and older report links with
the focused checkpoint; added a validation-file index and clarified archive scope,
publication checks, IMLS context limits and source versus publication coordinates.
Read saved targets and replayed the archived before/after counts under R 4.4.2;
reproduced the 0.85 label scores. Checked 140 local links, parsed all 13 R documentation
blocks and confirmed the six selective-build target names. All 50 non-documentation
hashes in the focused checkpoint match. No pipeline rebuild or analysis/label changes.

2026-09-15 focused follow-up: researched all six queued cases. Original IMLS tax IDs
and address fields exposed two contradictory Pennsylvania records; isolated those
rows and consolidated the clean LeMoyne records. Counts: 52,619 counted entities,
52,487 eligible; Washington County Historical Society 14. Confirmed Mandeville's
operator map destination, with export/access work still pending. Tests: 161 assertions;
15 integration checks; selective rebuild completed 15 targets. Baseline, source fields,
unaffected records, earlier packets and both human-label files unchanged. See the
[report and remaining queue](data/validation/museum_focused_review_2026-09-15.md).

2026-09-15 documentation audit: checked all project Markdown and post-template guidance
against code, saved targets and dated evidence. Clarified baseline versus reviewed counts,
current category holds, review terminology, complete selective-build commands and archive
limitations. Reproduced the original label scores and verified all 23 latest-packet hashes;
checked 84 local links and the selective commands against the target graph. No pipeline
rebuild, label changes or new matching validation. Earlier reports retain
checkpoint results with follow-up links; the next task remains the outstanding source checks.

2026-09-15 identity reconciliation: fetched address/website provenance for 38 records
from the same pinned Overture release and added nine explicit identity cases. Preserved
the automatic baseline, source fields and all human labels; exported the correction
audit and reviewed Parquet. Updated historical-name decisions to follow current names.
Tests: 139 passing assertions; selective rebuild and baseline/label invariance checks.

2026-09-15 source verification: checked 51 source rows, applied 11 location-specific
affiliations and four additional category releases, and distinguished four former names.
Documented priority relocation/address cases and confirmed the seed's selected map point.
Clarified that source research is assistant work, while independent human labels remain
necessary for matching-accuracy evaluation. Tests and a selective rebuild verify the changes.

2026-09-15 Phase 2: implemented canonical-entity counting, category review, sourced
affiliation rules, subject extraction/IMLS diagnostics and L2 M2; wired review targets and
prepared a dated review packet. Rebuilt from cached sources and confirmed unchanged
entity/site assignments, baseline counting flags, archived labels and 0.85 scores.
Source research corrected the Cryptozoology Museum relocation history and identified
publication-blocking identity/affiliation questions. Factual review precedes the post.

2026-09-15: Scored all 300 user-labelled pairs under R 4.4.2, verified stored scores and
merge decisions against the current normalizer and similarity function, archived the
unchanged labels, and recorded validation results. No pipeline rebuild or threshold change.

2026-09-15 documentation update: synchronized README, design, handoff, repository
guidelines, leads, validation report, and post-template guidance. Recorded the Phase 2
review deliverable, the M2/L2 mismatch, and the remaining standalone-post packaging work.
Reproduced the archived-label scores and checked saved targets without rebuilding them;
corrected the documented non-primary-site exclusion count from 2,305 to 2,306.

| Commit | What |
|---|---|
| `81f28f0` | Phase 0 scaffold: targets DAG, schema contract, normalizer, manifest, blogdown helpers |
| `108cf43` | Overture + IMLS sources implemented, real data pulled |
| `8121d9e` | Gazetteer, two-layer entity resolution, counting policy |
| `54b00fb` | Fuzzy cross-source matching, labelling harness, IMLS encoding fix |
| `2fefd93` | Society-under-museum merge, `alt_names`, handoff docs |
