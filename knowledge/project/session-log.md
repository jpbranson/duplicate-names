---
type: Work Log
title: "Session log before the mission (2026-09-07 to 2026-09-26)"
description: "Per-session summaries from the handoff, newest first, covering Phase 0 through the 2026-09-23 reviews, plus the early commit table."
tags: [history]
sequence: 10
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: handoff
    resource: 7416eef:HANDOFF.md
    title: "HANDOFF.md §7 Session log, as of commit 7416eef (moved here verbatim)"
---

2026-09-25/26 authorized mission: see the [flight log](flight-log.md) for every checkpoint.
Museum batches through the [M2 checkpoint](../evidence/museums/museum_m2_leaders_2026-09-26.md)
(52,387 counted / 52,255 eligible, 174 complete reviews); the church pipeline, C1-C4 outputs
and [ordinal/scope checkpoint](../evidence/churches/church_ordinal_review_2026-09-26.md) (442,832
eligible); explorer and both drafts refreshed locally, unpublished. The church scope
follow-up proposal awaits approval. Nothing is committed since `7bd56b3`.

2026-09-23 chain separation and not-a-museum exclusion (user decisions): headline M1/M2 now
count only non-chain institutions; new `museum_chains` and `museum_chain_overlap` targets
and review exports report chains and the names they share. Added the `not_museum` category
decision (uncounted in `museum_analysis`, rows kept in `museum_records`) with tests. Parsed the
official Museum of Illusions directory's map links: 13 city-suffixed records within 53 m,
New Orleans' address matches despite a 414 m point, and Atlanta's two records reconcile
to one. Three sourced not-a-museum decisions (Fort Edward, St. George, Marietta). Counted
institutions 52,584 (52,452 eligible); leaders now Franklin, Greene, Jackson County
Historical Society and Old Jail at 11. R 4.4.2: 217 assertions and 23 integrity checks
passed, including 212 protected files and an unchanged automatic baseline.

2026-09-23 provisional leaders review: committed the Union County batch (`373deae`), then
researched all 26 Museum of Illusions and Washington County Historical Society candidates.
Eight sourced identity cases cover 19 rows: society records join Stevens Memorial Museum,
Miller House Museum, Port o' Plymouth Museum, Dewey Hotel Museum and the Washington County
Heritage Center; Marietta's two society rows combine; Hollywood's Museum of Illusions joins
its WonderWalk/World of Illusions venue; a mislabeled Arkansas association row is isolated.
Counted institutions fall by nine to 52,588 (52,456 eligible); Washington County 13 to 7,
Museum of Illusions 13 to 12. Thirteen new verified reviews, including all 11 network
locations. Found that 14 more network locations sit under city-suffixed names, which raises
a headline methodology question for chains. Two Overture context queries and 46 cached
documents; two cache attempts failed. R 4.4.2: 195 assertions and 25 integrity checks passed,
including 168 protected files, 48 acquisition hashes and an unchanged automatic baseline.
The manifest update re-ran upstream targets with identical results. Research agents gathered
leads; the decisive statements were rechecked directly. No publication.

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
The [packet](../evidence/museums/museum_union_county_review_2026-09-17.md) preserves decisions,
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
[report/queue](../evidence/museums/museum_old_jail_review_2026-09-15.md). Next: Union County's
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
project docs and the [report/queue](../evidence/museums/museum_address_review_2026-09-15.md).
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
Next: use the expanded dossiers to continue the focused source checks in the [2026-09-23 handoff](handoff-2026-09-23.md).

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
[report and remaining queue](../evidence/museums/museum_focused_review_2026-09-15.md).

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
