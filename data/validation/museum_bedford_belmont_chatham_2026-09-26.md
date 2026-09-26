# Bedford, Belmont and Chatham museum review — September 26, 2026

This checkpoint applies supported factual corrections to 21 starting exact-name
candidates and related museum records. It does not certify a national winner,
dataset-wide matching accuracy or visitor-ready map coordinates.

## Validated result

| Measure | Before | After |
|---|---:|---:|
| Preserved source rows | 60,002 | 60,002 |
| Counted source rows | 57,136 | 57,129 |
| Counted institutions | 52,437 | 52,429 |
| Eligible for L2 analysis | 52,305 | 52,297 |
| Guarded identity rows / cases | 351 / 147 | 364 / 154 |
| Complete factual reviews, including exclusions | 146 | 154 |
| Sourced not-museum exclusions | 23 | 24 |
| Preferred-name overrides | 91 | 95 |
| Isolated source conflicts | 30 | 31 |

All 340 assertions pass, with zero failures, warnings or skips. All 27 saved-output
and integrity checks pass. The 1,467 protected earlier evidence files and human
labels are unchanged. The automatic baseline, baseline multisite queue, source
fields and coordinates, and 0.85 matching threshold are unchanged. Reviewed
Parquet and the source-level identity audit match the guarded replay.

## Factual decisions

The batch adds 13 identity rows in seven cases, 16 factual decisions and four
public names. Eight reviews are complete and eight remain explicitly pending.
The bare-name non-chain groups change from seven each to Bedford three, Belmont
two and Chatham four.

- New York Bedford Museum receives its public name and society affiliation,
  supported by the operator's two separate museums. Its office/store at 612 Old
  Post Road is excluded using the operator's positive description. Neither a
  second museum source row nor an arbitrary office-to-branch merger is invented.
- Massachusetts Bedford's documented move reconciles its old and current
  addresses. Job Lane Farm Museum's separately elected Friends board is preserved
  as a different operator. New Hampshire Bedford is one integrated museum campus.
  Virginia's present Wharton House museum scope remains pending.
- California Belmont's park-address and museum-address records reconcile, with
  current governance still pending. North Carolina's museum and mailbox reconcile
  under its elected society board. Massachusetts Claflin Room receives its public
  name and shared affiliation with the society's offsite Wellington Station exhibits.
- New Hampshire Belmont's IMLS row mixes local legal/mail identity with the North
  Carolina physical address and website. It is separately uncounted and supplies
  no aliases. It is not a not-museum decision. Dayton Belmont's museum scope remains
  pending.
- Connecticut Chatham's officer mailbox reconciles with the museum/schoolhouse
  campus through an official state directory. Massachusetts society and museum
  descriptions reconcile to Atwood Museum. The two New Hampshire Chatham addresses
  remain separate pending a primary bridge. New Jersey's permanent museum scope
  and Ohio's old address/campus relationship remain pending.

Precise source keys and primary links are in [evidence.csv](museum_bedford_belmont_chatham_2026-09-26/evidence.csv).
All 21 starting candidates have a [recorded disposition](museum_bedford_belmont_chatham_2026-09-26/candidate_dispositions.csv).
The [eight human-review actions](museum_bedford_belmont_chatham_2026-09-26/human_review.csv) state what evidence is
missing; they are not completion claims. The broad 886-row context includes
unrelated institutions and does not imply all 886 received factual review.

## Evidence and limitations

Public downloads attempted 47 sources and cached 42. Five failures
remain recorded: a 404, a timeout, two expired-certificate errors and an HTTP 522.
No certificate protections were disabled. [Web observations](museum_bedford_belmont_chatham_2026-09-26/web_observations.json)
distinguish indexed or directly inspected pages from cached original bytes.
IRS contact rows support identity, not by themselves museum scope or governance.

Visually checked Bedford's February 2022 move newsletter pages 1–2, Job Lane
bylaws page 3, Connecticut Register PDF page 747 (printed 737), and New Hampshire
registry page 56. The registry original was updated September 21, 2026; its data
supersede stale indexed text. Minor font substitution did not obscure the evidence.
The newsletter text extraction has an encoding defect; the rendered pages were
read directly to verify the move.

The related context also exposed possible unrelated quality leads: New Bedford
Whaling Museum and Fishing Heritage Center sharing a baseline entity, and Chatham
Railroad Museum appearing at two Massachusetts addresses. Neither is adjudicated
here; preserve them for a separate scoped audit. No unsupported change is applied.

Old Jail Museum remains the provisional non-chain leader at eight, with four
reviews pending and an explicit failed publication gate. Continue the remaining
seven-count groups and earlier/M2 queues. Local post/explorer artifacts retain the
older Clinton/Madison/Monroe checkpoint until a later refresh. Independent church
labels and publishing destination remain outstanding.

Cloud spending remains **USD 0**, below the USD 5 cap. No outreach, external
publication or paid service was used.
