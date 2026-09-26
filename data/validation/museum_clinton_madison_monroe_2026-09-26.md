# Clinton, Madison and Monroe County source review — September 26, 2026

This packet reviews the 27 candidates in the three remaining nine-member L2
county-society groups. It applies supported factual corrections, preserves
unresolved records, and does not certify a national M1 or M2 winner.

## Validated checkpoint

| Measure | Before | After |
|---|---:|---:|
| Original source rows | 60,002 | 60,002 |
| Counted source rows | 57,216 | 57,202 |
| Counted institutions | 52,506 | 52,493 |
| Eligible institutions | 52,374 | 52,361 |
| Guarded identity rows / cases | 220 / 86 | 243 / 98 |
| Complete factual reviews | 85 | 101 |
| `not_museum` decisions | 16 | 18 |
| Preferred public names | 41 | 55 |
| Isolated source conflicts | 11 | 19 |

Selective museum review, identity-audit and Parquet targets rebuilt successfully.
All **322 test assertions and 20 integrity checks passed**. The **861 protected
earlier evidence and human-label files** are unchanged. The automatic baseline,
baseline multisite queue, original source/normalized fields, source coordinates,
0.85 matching threshold and every prior factual decision are preserved.

The batch adds 23 explicit identity rows in 12 cases, 31 factual decisions and
14 public-name overrides. Sixteen additional factual reviews are complete;
**15 reviews remain pending**, including eight source-conflict holds. These are
factual source reviews, not independent matching-accuracy labels.

## Effects on the selected names

| L2 name | Before, non-chain | After, non-chain |
|---|---:|---:|
| Clinton County Historical Society | 9 | 0 |
| Madison County Historical Society | 9 | 0 |
| Monroe County Historical Society | 9 | 3 |

A zero here means no remaining eligible, non-chain institution retains that exact
L2 name after this review. It does not mean the underlying museums do not exist.
Reviewed institutions with more specific public names remain in the analysis.
The three remaining Monroe candidates are unresolved Tennessee, Wisconsin and
Missouri society records. Other unreviewed name groups now lead at eight each.
The explicit publication gate rejects the next leader; national review is open.

## Decisions and their evidence

- **Clinton:** Frankfort, Clinton (Iowa) and Plattsburg mailing records are
  consolidated with their current museums. Plattsburg's exact EIN connects its
  older mailing address to the current 308 South Birch address in the cached IRS
  file. Public names include Heisey House Museum, Clinton County Historical
  Society Museum, Clinton County Historical Society & Museum and Riley-Carmack
  Museum. Pennsylvania's Heisey museum shares an operator with the separately
  located Barton Street School museum; that affiliation is recorded.
- **Clinton source conflicts:** Illinois and Michigan IMLS rows contain
  Pennsylvania's 362 East Water Street. One Ohio row has Michigan's 106 Maple
  Street. Another Ohio row mixes an Iowa EIN, Pennsylvania locality/mailing
  address and Ohio museum street/domain. All four are isolated with separate
  uncounted IDs. The clean Michigan and Ohio museum records remain accepted.
- **Madison:** Current museum names are applied in New York, Iowa, Indiana,
  Ohio and Virginia. London's museum and society mailing record are consolidated.
  Cottage Lawn's house, library and agricultural barn are one property; Winterset's
  historical complex is one campus. Virginia's Madison Museum and Mountain Museum
  have a documented common operator. The clean Virginia parent record remains
  pending because its attribution to one museum is not established.
- **Madison source conflicts:** An Iowa record uses the New York museum's domain.
  A New York-addressed record has Virginia's EIN and point. These are isolated;
  neither supplies aliases to an accepted institution in another state.
- **Kentucky society:** Its own account establishes meetings, publishing,
  research referrals and preservation work, and transfer of its battlefield
  property to the county. This organization record is excluded as `not_museum`.
  The separately operated battlefield museum and university collections remain
  distinct. The decision is not based on a failed search or a mailbox.
- **Monroe:** Forsyth and Union museum/mailing records are consolidated. Waterloo's
  record receives the public name Bellefontaine House. An Albia record with a
  Portuguese sports-publication domain and a Forsyth record with Wisconsin's
  museum domain are isolated; clean local records remain. Forsyth's depot museum,
  archives and adjacent interpretive/meeting buildings are treated as one campus.
- **Ohio office:** The president's account distinguishes the society's senior-center
  office/records room from the Parry museum at 217 Eastern Avenue. The office is
  excluded as an additional museum. The Parry museum remains separately counted,
  with current operation and access review pending.
- **Unresolved parent roles:** Wisconsin's society is explicitly distinct from the
  county-run Local History Room, but its Brackett School role needs further work.
  Missouri's society identifies both a courthouse museum and Nancy Stone Research
  Center; its generic IMLS row remains pending. Tennessee's legacy society listing
  does not establish a current public museum or an affirmative non-museum role.

Exact memberships, URLs and evidence notes are in
[decisions_spec.json](museum_clinton_madison_monroe_2026-09-26/decisions_spec.json).
[candidate_dispositions.csv](museum_clinton_madison_monroe_2026-09-26/candidate_dispositions.csv)
accounts for all 27 starting candidates. The original source rows and source-level
[identity audit](museum_clinton_madison_monroe_2026-09-26/identity_audit_after.csv)
remain available.

## Unfinished work

[human_review.csv](museum_clinton_madison_monroe_2026-09-26/human_review.csv)
records all 15 pending items with concrete next actions.
Source-conflict holds require evidence resolving their original lineage, not an
unsupported reassignment. West Virginia's operator website was inaccessible;
its current governance, property scope, access and visitor point remain open.
Unresolved cases are retained, and no outreach has been sent.

Visitor map points still require separate publication export and access checks.
Recorded verification and publication-gate status do not prove map accuracy,
M2 scope-word meaning or dataset-wide/final-cluster matching accuracy. Earlier
county, Old Jail, affiliation and M2 queues are still incomplete.

## Reproducibility and failures

The one-time snapshot protected prior artifacts before any decisions changed.
All 87 requested Overture context rows were acquired from the pinned release,
with query provenance. A full-baseline name crosscheck found no additional
relevant separately named Bellefontaine, Cottage Lawn, Bevington or Kemper house
records to merge; unrelated similarly named museums were left alone.

Of 59 source-cache attempts, 55 succeeded. The first Madison Ohio contact URL
returned 404; the actual linked URL was subsequently cached. Wisconsin's obsolete
society URL returned 404, while current museum and state sources were cached.
The West Virginia operator and Georgia operator homepage timed out; current
destination/partner evidence was saved where available. Failures are retained
in `cache_status.csv`; TLS/authentication checks were never bypassed.

The first diagnostic name-crosscheck print used a data-frame-incompatible argument;
the corrected read completed. The first dry run rejected the draft role `mailing`;
it was corrected to the supported `mailing_address` role. Neither failure changed
live inputs. The corrected dry run passed, and `apply.R --apply` ran once.
`applied.json` is the completion marker: **do not rerun prepare or apply**.

`build_validate.log`, `integrity_checks.csv` and `counts.csv` record validation.
The source cache and `MANIFEST.json` retain download checksums; selected IRS rows
reference their earlier cached files. Cloud resource spending remains **USD 0**,
strictly below the user's USD 5 cap.

The local post and explorer refresh passed the documented
[artifact checks](museum_clinton_madison_monroe_2026-09-26/artifact_QA.md).
The actual CSV filesystem-save check remains unverified. Publication and
deployment remain incomplete.
