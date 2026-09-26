# Madison, Marion County and Milton museum review — September 26, 2026

This checkpoint applies supported factual corrections after reviewing 24 starting
exact-name candidates and their related records. It does **not** certify a national
winner, dataset-wide matching accuracy, or publication-ready map points.

## Validated result

| Measure | Before | After |
|---|---:|---:|
| Preserved source rows | 60,002 | 60,002 |
| Counted source rows | 57,156 | 57,136 |
| Counted institutions | 52,455 | 52,437 |
| Eligible for L2 analysis | 52,323 | 52,305 |
| Guarded identity rows / cases | 319 / 134 | 351 / 147 |
| Complete factual reviews, including exclusions | 132 | 146 |
| Sourced not-museum exclusions | 22 | 23 |
| Preferred-name overrides | 80 | 91 |
| Isolated source conflicts | 29 | 30 |

All 340 assertions pass, with zero failures, warnings or skips. All 27 saved-output
and integrity checks pass. The 1,351 protected earlier evidence files and human
labels are unchanged. Baseline entities, baseline multi-site queue, source fields,
coordinates and the 0.85 matching threshold are unchanged. Reviewed Parquet and
the source-level identity audit match the guarded replay.

## Scope and decisions

The batch adds 32 identity rows in 13 cases, 22 factual decisions and 11 public
names. Fourteen reviews are complete; eight are explicitly pending. The three
bare-name non-chain groups fall from eight each to Madison one, Marion County two,
and Milton zero. These are corrections to source identities and names, not claims
that the places no longer exist.

- New Hampshire Madison records reconcile to the public museum. Connecticut keeps
  its two separate museums under the same society. Louisiana's society mailbox
  reconciles to Hermione Museum.
- New Jersey's research office is excluded using its current operator description
  and explicit future museum plans. New York receives its full public name but
  remains pending. The older Ohio address cluster remains separate pending a
  specific historical address bridge.
- Ohio Heritage Hall is affiliated with its society's other operated sites. The
  co-located Popcorn Museum remains a separate institution with unresolved
  affiliation. Iowa's single historical village receives its public name.
- Oregon's documented merger reconciles the predecessor records to Willamette
  Heritage Center. Georgia's historical operator mailbox and transfer history
  reconcile to university-affiliated Pasaquan. Alabama, Missouri and current
  Mississippi operator scope remain pending.
- Milton's Pennsylvania, Vermont, Wisconsin and Massachusetts museum records are
  reconciled. Delaware's institution receives its public museum name. The mixed
  Massachusetts IMLS row remains separately uncounted, supplying no aliases to
  either state's accepted museum.

Per-case primary links, precise rationale and source keys are in
[evidence.csv](museum_madison_marion_milton_2026-09-26/evidence.csv).
All 24 original candidates have a
[recorded disposition](museum_madison_marion_milton_2026-09-26/candidate_dispositions.csv).
The [eight follow-ups](museum_madison_marion_milton_2026-09-26/human_review.csv)
describe exactly what evidence is still needed. A similar Iowa 210 Union Street
field is retained as a separate, unreviewed source-quality lead.

## Evidence and limits

The snapshot preserves 606 related baseline rows; the broad name search also
includes Hamilton strings and does not imply that all 606 were reviewed. Public
downloads attempted 64 sources, caching 56; eight failures are recorded, including
403/404, timeout, certificate and HTTP/2 errors. No certificate protection was
disabled. [Web observations](museum_madison_marion_milton_2026-09-26/web_observations.json)
clearly distinguish inspected web text from uncached native bytes. IRS contact
records are identity bridges, not proof by themselves of museum scope or
independent governance.

Louisiana guide page 11, New York trail page 2 and New Hampshire annual report
page 116 were visually checked. Font substitutions did not obscure the evidence.
Publication still requires current access and sourced visitor coordinates, notably
for mailing or discrepant points. All proposed changes passed the dry run before
the one-time application; no identity guard was changed.

Old Jail Museum remains the provisional non-chain leader at eight, with four
reviews pending; its explicit publication gate fails. Continue the seven-count
groups, beginning Bedford, Belmont and Chatham Historical Society, and preserve
earlier unresolved and M2 queues. Post and explorer artifacts still contain the
older Clinton/Madison/Monroe checkpoint and need a later refresh. Independent
church labels and the publishing destination remain outstanding.

Cloud spending remains **USD 0**, below the USD 5 cap. No outreach, external
publication or paid service was used.
