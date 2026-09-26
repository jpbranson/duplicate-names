# Depot and Wayne County leader review, September 26, 2026

This packet starts with 20 provisional L2 candidates (10 per name), 310 related
baseline rows and 213 available Overture context rows. The snapshot protects 553
existing evidence files. No source review here is an independent matching label.
Sources are listed in sources.json and cache_status.csv; failed retrievals remain
explicit. Raw source names, IDs and coordinates must be preserved.

## Wayne County initial findings (decisions not yet applied)

- Piedmont, Missouri: the society's own site identifies Luna Museum at 108 West
  Elm and explicitly gives PO Box 222 for membership payments. These match the
  Overture physical address and IMLS mailing record. Identity consolidation and a
  public-name correction are supported; current governance needs further checking.
- Corydon, Iowa: Prairie Trails Museum gives 515 East Jefferson and PO Box 104.
  Both IMLS records share EIN 421049099; one names Prairie Trails and one the
  society. Two Overture records sit on the same museum campus. Four records likely
  represent one institution; legal/operator context needs a final check. The
  adjacent Heritage Barn is described as museum exhibits, not a separate operator.
- Lyons, New York: Museum of Wayne County History at 21 Butternut is operated by
  the Wayne County Historical Society. The operator names its 2026 board and its
  nonprofit status. The IMLS society and Overture museum records share this
  address. The jail and carriage-house exhibits are parts of one campus.
- Monticello, Kentucky: the operator links PO Box 320 to the museum at 65 North
  Main and names William Crenshaw Kennedy, Jr. Memorial Museum. The IMLS society
  record EIN 611020324 matches the PO box. A second IMLS row (8402100284) has the
  Monticello physical/mail context but an unrelated Michael J Quill Irish Cultural
  and Sports Centre legal name/EIN 222848395. Do not donate that mixed row's aliases
  to an accepted museum. Confirm the discrepancy with primary context first.
- Fairfield, Illinois: the operator lists Early History Museum (300 SE Second)
  and Hanna House Museum (Center Street) as distinct museums. The generic society
  cluster is at the first address. Common ownership supports affiliation, not
  merging distinct museums. Access hours and Hanna street number differ between
  operator/municipal sources and need care in any visitor export.
- Honesdale, Pennsylvania: the operator links the main museum at 810 Main to PO
  Box 446, and lists several separate museums/sites under the same society.
  Record the common operator, retaining separate visitor institutions. The main
  museum page uses Wayne County Historical Society Museum as a public name.
- Wayne, Nebraska: the city describes the Ley mansion museum; IMLS supplies
  Seventh and Lincoln/PO Box 83. The Overture museum address and operator site
  should be compared before merging the displaced IMLS point.
- Waynesboro, Tennessee: society-to-museum identity remains unresolved. A PO box,
  missing search result or tax status is not evidence of not_museum.

## Depot initial findings

Overture context corrects the first coordinate-only lead: c46a0fda is **Arcadia,
Louisiana**, not Ruston. The ten candidate places are Arcadia LA, Wakefield NE,
Ironwood MI, Stratford TX, Two Harbors MN, Enterprise AL, Oroville WA, Fort Payne
AL, Henderson TX, and Mammoth Spring AR. Wakefield's operator describes its Train
Depot museum at 101 East First. Remaining operator reviews are in progress.

## Resume

Do not rerun prepare.R. Acquisition completed with 213 context rows. Complete
source checks, apply guarded identity/name/affiliation decisions in a separate
one-time script, then refresh selected museum targets and validate the 553-file
preservation manifest. Existing church/dashboard evidence packets are frozen;
any rebuilt publication payload needs a new evidence output directory.
