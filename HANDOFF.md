# Handoff

**Last session:** 2026-09-15 · **Phase:** 1a labels scored; Phase 2 museum analysis next
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
renv::restore()      # ~138 packages, pinned
```

**Pin R to 4.4.** The lockfile records 4.4.2. On the previous machine R 4.6.1 was
installed but had an empty library, so a newer R will not "just work" — it will try to
rebuild everything.

Then:

```r
targets::tar_make()                      # full pipeline, ~2.5 min warm
source("tests/testthat.R")              # source functions, then run tests
```

### What is NOT in the repo

`data/raw/` and `data/processed/` are gitignored. `tar_make()` rebuilds generated outputs
from scratch when needed — allow **~5 minutes** on a cold run, almost all of it the Overture S3 query and
the tigris gazetteer download. Nothing needs credentials: Overture's S3 bucket is public
and reads anonymously.

`data/raw/MANIFEST.json` **is** tracked, and it is what makes the rebuild reproducible —
URL, SHA-256, row count and fetch date for every download and every remote query.

Human labels are preserved separately in `data/validation/`, outside the ignored,
rebuildable directories. The archived CSV cannot be recreated by `tar_make()`.

---

## 2. Where things stand

Museums only. Churches (Phase 1b) are queued, not cancelled — see §6.

| | |
|---|---|
| Sources | Overture `2026-08-19.0` (29,894 US museums) + IMLS MUDF 2018 (30,108) |
| Records | 60,002 → **57,348 counted** |
| Entities | **52,636** counted |
| Excluded | 2,306 non-primary site · 331 permanently closed · 17 no name |
| With an alternate name | 6,181 |

Everything through resolution works. The seed case resolves correctly: the International
Cryptozoology Museum is one entity at Bangor, with all three Portland records retained and
flagged `non_primary_site`.

These are the saved September 7 pipeline counts. Scoring the human labels on September 15
did not rebuild the pipeline or change the matching threshold.

---

## 3. THE NEXT THING TO DO

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

**Next deliverable: a cleaned museum collision ranking and a top-20 review sheet.**
Work through Phase 2 in this order:

1. **Category-only names first.** Flag likely placeholders such as `art gallery` and
   `planetarium`, preserve the records, and record review decisions. A genuine institution
   can use a category as its name, so automatic blanket exclusion needs review.
2. **Extend franchise detection.** Use evidence of common ownership; keep inherited place
   names and productive naming templates separate from chains.
3. **Implement subject extraction** for M3, checking against IMLS discipline where useful.
4. **Align M1/M2 with L2 (`name_expanded`).** M1 already defaults to L2, but
   `metric_singularity_collisions()` still groups on `name_core`. Correct that mismatch
   before publishing the M2 ranking and wire the museum analyses into `_targets.R`.
5. **Verify the top 20 collisions and relevant multi-site cases.** The review sheet should
   identify the institutions behind each name and record evidence for counting decisions.
   Then export small payloads, build figures and the rank table, and draft the museum post.

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

**2. Cross-source merging may still be too weak.** The saved run has 52,636 entities from
57,348 counted records, but no independently verified national total. The sample has eight
missed matches, but lowering the threshold to 0.80 produces 31 false merges for only two
additional true merges. Investigate aliases and abbreviations before lowering it.

**3. Likely category-only placeholders affect the rankings.** `art gallery` (37) and
`planetarium` (14) appear in the saved September 7 results. The name alone does not prove
whether a mapper supplied a category or recorded actual signage. Define a reviewable rule
before using these as duplicate names; see LEADS.md, "Institutions whose name is just their
category."

**4. 249 entities in the multi-site review queue** (`targets::tar_read(multisite_review)`),
top spread 598 km. Each is either a relocation, a genuine multi-site institution, or two
unrelated museums wrongly merged. Names and coordinates alone cannot separate them.

**5. Incomplete for post 1:** `subject` is still unimplemented, and the franchise helper
currently treats any nonempty `operator` as a franchise. Overture populates that field
from brand metadata; the presence of an operator alone is not proof of a chain. Names such
as `museum of illusions` (13) and `ripley's` (9) in the saved results need affiliation
review so M4 can distinguish chains from independent collisions.

**6. M2 still uses L3.** The docs specify L2 museum headlines, but
`metric_singularity_collisions()` groups on `name_core` and is not yet a pipeline target.
Correct and test this in Phase 2; no analysis code changed in the documentation update.

---

## 5. Things that will bite you

- **Overture's `sources[].update_time` must exclude `provider = 'overture'`.** Overture's
  own entries are stamped with the release date, which pins every row to the same day and
  destroys the freshness signal. This is already handled in `R/src_overture.R` — do not
  "simplify" it.
- **`operating_status` does not catch stale records.** Overture still marks the Portland
  Cryptozoology Museum "open" a decade after it left. Freshness plus confidence is what
  actually works.
- **IMLS CSVs are Windows-1252.** Handled in `R/src_imls.R`. Read as UTF-8 they corrupt 42
  names and those museums silently fail to match.
- **IMLS is a 2018 snapshot** and will never update. It is evidence a museum existed in
  2018, never that one exists now. Its `source_update_time` says so honestly.
- **L3 (`name_core`) is the wrong default for museums.** Stripping place names suits
  churches; for museums the place is usually the identity. Museum headlines use **L2
  (`name_expanded`)**. L3 supports geography-stripped comparisons and the planned M3
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

**Do not assume the normalizer generalizes.** It has been tuned entirely on museum names
and will have museum-shaped blind spots. Re-run the gold set with church cases *added*.
Two known gaps that only matter for churches:

- Compound ordinals (`Twenty Third`) return `NA`. C3's headline is the *highest* observed
  ordinal and the highest ones are compound, so this biases that number downward. There is
  a test documenting the gap.
- L3 stripping is *right* for churches and wrong for museums — the opposite of the museum
  default above.

---

## 7. Session log

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
