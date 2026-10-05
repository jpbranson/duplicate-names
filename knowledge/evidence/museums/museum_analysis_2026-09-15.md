---
type: Evidence Packet
title: Initial Phase 2 museum analysis
description: First canonical L2 checkpoint with category holds, sourced affiliation rules and a 21-name review packet; 52,636 baseline counted entities and 52,497 provisionally eligible.
resource: ../../../data/validation/museum_analysis_2026-09-15.md
tags: [museums, checkpoint, category-names, chains, leaders]
status: deprecated
superseded_by: museum_source_review_2026-09-15.md
checkpoint: 2026-09-15
sequence: 2
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: report
    resource: ../../../data/validation/museum_analysis_2026-09-15.md
    title: Phase 2 museum analysis review checkpoint report
  - id: packet
    resource: ../../../data/validation/museum_review_2026-09-15/
    title: Initial museum review packet (rankings, institutions, source records, pairs)
---

# Scope

The first Phase 2 checkpoint: M1/M2 count one canonical L2 name per entity, category-only
names are held for review, affiliation requires a sourced rule or explicit decision, and M3
extracts a bounded set of topics. The dated packet saves the leading-name review
sheets.[^report] Preceded by [resolution validation](resolution_validation_2026-09-15.md). Superseded by the
[first source pass](museum_source_review_2026-09-15.md); a later checkpoint replaced its
counts, but the packet remains valid historical evidence.

# Outcome

| Measure | Value |
|---|---:|
| Counted source records | 57,348 |
| Baseline counted entities | 52,636 |
| Provisionally eligible after category holds | 52,497 |
| Flagged category-only counted entities / still pending | 140 / 139 |
| Names retained in the top-20 review (tie at nine) | 21 |

- Canonical counting corrects the metric: Washington County Historical Society had 27 source
  rows under that label, but 19 canonical entities. No matching threshold, entity/site
  assignment or baseline counting flag changed.[^report]
- Provisional L2 leaders: Washington County Historical Society (19), Old Jail Museum (15),
  Union County Historical Society (14) and Museum of Illusions (13). Every entry requires
  identity/count review.[^report]
- [Category holds](../../methodology/category-only-names.md) use an explicit exact-name
  vocabulary. Cal Poly's University Art Gallery hold was released; the Mandeville record
  stays on hold. No category record was automatically declared a placeholder.[^report]
- The initial [affiliation](../../methodology/chain-detection.md) lexicon covers Play Street
  Museum, Ripley's, Madame Tussauds and Museum of Ice Cream. Missing evidence is unknown,
  not independent.[^report]
- Priority research findings: Museum of Illusions needs location-level ownership review;
  National Electronics Museum is a relocation warning; National Vietnam War Museum needs
  geographic reconciliation; the M2 scope parser is lexical; the Cryptozoology seed
  chronology needed correction.[^report]
- Validation: under R 4.4.2 all 97 test assertions pass. Entity IDs, site IDs, baseline
  counted flags and exclusion reasons are identical across all 60,002 source records. Both
  label files are byte-identical and the 0.85 label score is unchanged.[^report]

# Open actions

Every overall review remained pending. The 159 nearby entity pairs carry **blank** independent
labels; they are diagnostic cases, not a representative accuracy sample.[^report] The report
says not to export post payloads or publish headlines until the factual institution review is
complete.[^report] No follow-up queue exists; the
[category review](../../../data/validation/museum_review_2026-09-15/category_review.csv)
and [M2 candidates](../../../data/validation/museum_review_2026-09-15/singularity_candidates.csv)
were the review sheets.[^packet]

# Files

- [Checkpoint report](../../../data/validation/museum_analysis_2026-09-15.md)
- [Packet directory](../../../data/validation/museum_review_2026-09-15/):
  [cleaned ranking](../../../data/validation/museum_review_2026-09-15/ranking.csv),
  [unfiltered ranking](../../../data/validation/museum_review_2026-09-15/ranking_before_category_review.csv),
  [470 candidate institutions](../../../data/validation/museum_review_2026-09-15/institutions.csv),
  [551 source records](../../../data/validation/museum_review_2026-09-15/source_records.csv),
  [nearby pairs](../../../data/validation/museum_review_2026-09-15/nearby_pairs.csv),
  [input checksums](../../../data/validation/museum_review_2026-09-15/input_checksums.csv)
- [Initial research notes](museum_research_2026-09-15.md) accompany this packet.
- The packet holds no scripts.

[^report]: Phase 2 museum analysis review checkpoint report
[^packet]: Initial museum review packet (rankings, institutions, source records, pairs)
