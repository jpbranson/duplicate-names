---
type: Reference
title: "Museum count history, 2026-09-15 to 2026-09-26"
description: "How counted and eligible museum institutions moved through each correction checkpoint, with the narrative of each batch."
tags: [museums, history, counts]
sequence: 9
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: readme
    resource: 7416eef:README.md
    title: "README.md Current status, as of commit 7416eef (moved here verbatim)"
---

Moved verbatim from the README's status section as of commit `7416eef` (2026-09-26), so
"current" and "latest" below mean that date. The [status report](status.md) holds the live
state.

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
| After Union County review | 57,305 | 52,597 | 52,465 |
| After provisional leaders review | 57,293 | 52,588 | 52,456 |
| After chain separation and not-a-museum decisions (September 23) | 57,292 | 52,584 | 52,452 |
| After M2 leading groups (September 26; latest, see the [validation index](../evidence/index.md) for intermediate batches) | 57,083 | 52,387 | 52,255 |

These are provisional counts; remaining source checks precede publication.

All **300 candidate pairs** have independent human labels. At the retained
**0.85** threshold, sample precision is **99.17%** and recall is **93.70%**
(119 true merges, 1 false merge, 8 missed merges, 172 true separations).
These are unweighted results from five equally sampled similarity bands within
150 m; they do not establish dataset-wide accuracy or validate final clusters.
See the [validation report](../evidence/museums/resolution_validation_2026-09-15.md).

The [initial Phase 2 report](../evidence/museums/museum_analysis_2026-09-15.md) records the
analysis implementation; the [identity report](../evidence/museums/museum_identity_review_2026-09-15.md)
preserves the first identity checkpoint. The [Old Jail review](../evidence/museums/museum_old_jail_review_2026-09-15.md)
and [Union County review](../evidence/museums/museum_union_county_review_2026-09-17.md) preserve
preceding checkpoints, as does the [provisional leaders review](../evidence/museums/museum_leaders_review_2026-09-23.md);
the [Cass/Chester/Crawford checkpoint](../evidence/museums/museum_cass_chester_crawford_2026-09-26.md) preserves an earlier September 26 state, and the [M2 leading-group checkpoint](../evidence/museums/museum_m2_leaders_2026-09-26.md) has the latest validated counts and remaining cases.
M1/M2 now count one canonical L2 name per non-chain entity; the old helper counted source
rows and aliases. Chain locations are reported beside the headline, and a sourced
`not_museum` decision removes records that describe no museum. Category-only names are
held pending evidence, known brand affiliations have sourced rules, unknown affiliation
stays unknown, and M3 uses explicit topic extraction with an IMLS comparison.

`museum_review_files` writes the ranking, top-20 institution/source sheets (including
cutoff ties and leading M2 candidates), category queue, chain summary and overlap,
not-a-museum review, and nearby-pair diagnostics to `data/processed/museum_review/`. Preserve completed decisions in the tracked
`data/validation/museum_decisions.csv`, keyed by source record and expected name.
Use the generated sheets for current candidates. Each dated packet's reviewed-institution
file and follow-up queue preserve cases that merged into differently named institutions;
see the [latest queue](../../data/validation/museum_m2_leaders_2026-09-26/human_review.csv) (28 open actions). Earlier packets retain unresolved cases from their own batches. Check `museum_analysis` for current IDs when revisiting any dated packet.
No headline count is certified by these automated analyses.

The [source-verification report](../evidence/museums/museum_source_review_2026-09-15.md)
records checks of 51 source records, including all 13 University Art Gallery and all
13 Museum of Illusions candidates. Official-source research can be completed by an
assistant; it is separate from the independent human labels used to measure matching
accuracy. That pass released four additional gallery category holds, recorded four
historical-name holdouts, and established 11 location-specific brand affiliations.

The subsequent [identity-reconciliation report](../evidence/museums/museum_identity_review_2026-09-15.md)
records 25 source rows reconciled from 24 baseline entities into nine institutions.
`entities` retains the automatic baseline. At that checkpoint, `museum_records` had
**52,621 counted entities**, with **52,489 eligible for name analysis**. Source rows and
original coordinates remain intact, with a before/after audit. These factual corrections
do not change the 0.85 algorithm or establish new matching-accuracy estimates.
Three historical gallery names now survive as aliases of current institutions. The
remaining category queue has five confirmed names, one historical-name holdout (NMSU),
and 131 pending decisions.

The [focused follow-up](../evidence/museums/museum_focused_review_2026-09-15.md) consolidates
the clean LeMoyne House records and isolates two contradictory IMLS rows. The later
[address follow-up](../evidence/museums/museum_address_review_2026-09-15.md) reconciles Chipley's
mailing record and the Peters Creek house/society records. The September 15
[Old Jail review](../evidence/museums/museum_old_jail_review_2026-09-15.md) examines all 15
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

The September 17 [Union County batch](../evidence/museums/museum_union_county_review_2026-09-17.md)
reviews all 14 starting candidates. Six corrections cover 15 source rows, reducing
the exact-name count to **7**, counted institutions to **52,597** and eligible
institutions to **52,465**. Creston's Historical Village has a complete factual review
and supported independent operation; all seven remaining exact-name institutions stay pending.
The identity input now covers **71 rows in 28 cases**. **195 assertions and 23
integrity checks passed**, including preservation of the baseline, original source
fields, labels and 125 protected files.

The September 23 [provisional leaders review](../evidence/museums/museum_leaders_review_2026-09-23.md) researches
all 26 Museum of Illusions and Washington County Historical Society candidates. Eight cases
cover 19 source rows, one a new isolated source conflict: society records join their named
museums in Indiana, Maryland, North Carolina, Oklahoma and Minnesota, and Hollywood's
Museum of Illusions joins its WonderWalk venue. Washington County falls from 13 to **7**,
Museum of Illusions from 13 to **12**, counted institutions to **52,588** and eligible
institutions to **52,456**. Sixteen institutions now have complete factual reviews.
The identity input covers **90 rows in 36 cases**. **195 assertions and 25 integrity
checks passed**, including 168 protected files. Four names now tie at 12; three are
single-brand chains, and 14 further Museum of Illusions locations carry city-suffixed
names. No leading name is publication ready.

The subsequent [methodology checkpoint](../evidence/museums/museum_methodology_2026-09-23.md) separates chains from the
headline: M1 and M2 count only non-chain institutions, while `museum_chains` and
`museum_chain_overlap` report chain locations and the names they share with other
institutions (Old Jail Museum, Madame Tussaud's Wax Museum, Museum of Illusions). The
official Museum of Illusions directory's 14 city-suffixed locations are affiliated, giving
the network 25 locations under 15 L2 names; Atlanta's duplicate record is reconciled.
Three sourced `not_museum` decisions (Fort Edward, St. George, Marietta) leave the count.
Counted institutions fall to **52,584** and eligible institutions to **52,452**;
Franklin, Greene and Jackson County Historical Society and Old Jail Museum lead at **11**.
**217 assertions and 23 integrity checks passed**, including 212 protected files.

At that checkpoint the regenerated review sheets contained 457 candidate institutions,
560 source rows and 149 nearby pairs. The live sheets (M2 checkpoint) contain **432
candidate institutions, 557 source rows and 84 nearby pairs**, with a top-20 cutoff of six.
The original dated packet's 470 institutions, 551 rows and 159 pairs describe an earlier
checkpoint. Use the
[validation index](../evidence/index.md) to distinguish live decision inputs,
historical evidence and the latest follow-up queue.

The IMLS dossiers now include EIN and separate physical/mailing addresses, with source IDs
attached to the institution summaries. The earlier dossier-only rebuild refreshed three targets;
192 assertions and 23 integration checks passed, with counts and decisions unchanged.
See the [review-field guide](../playbooks/complete-museum-review.md) before continuing source checks.
