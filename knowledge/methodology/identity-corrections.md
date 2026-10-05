---
type: Method
title: "Curated identity corrections"
description: "The guarded, auditable correction layer that turns the automatic entities baseline into museum_records, including source-conflict holds."
tags: [identity, museums]
sequence: 4
implemented_in: [../../R/museum_identity.R, ../../R/museum_review_context.R]
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: design
    resource: 7416eef:DESIGN.md
    title: "DESIGN.md §4.3.1, as of commit 7416eef (moved here verbatim)"
---

**Curated identity layer, September 15:** the automatic `entities` target remains an
auditable baseline. `museum_records` applies only explicit source memberships from
`museum_identity_decisions.csv`; it does not widen any matching rule. Each case names
one existing canonical record, all affected baseline-cluster members, physical site
groups, and source evidence. Guards check original names, entity IDs and coordinates.
Current-name and former-name aliases are retained; physical museums under the same
operator remain separate unless the evidence identifies the same museum.

Within a reviewed case, only the canonical source record counts. Other rows remain
with `reviewed_duplicate_record`, `reviewed_former_site`, `reviewed_mailing_address`
or `reviewed_mislocated_record`. Source names and coordinates are not overwritten;
misplaced/mail coordinates are not treated as additional physical sites. A source-level
audit carries the original and corrected entity/site IDs, names and counting flags.
Unreviewed rows keep the baseline policy. The first nine cases reconcile 24 baseline
entities into nine institutions. Tests validate this mechanism, not the correctness of
the assistant's factual judgments or overall matching accuracy. See the
[identity report](../evidence/museums/museum_identity_review_2026-09-15.md).

The [focused follow-up](../evidence/museums/museum_focused_review_2026-09-15.md) adds a
LeMoyne consolidation and two `source_conflict` holdouts. The later
[address follow-up](../evidence/museums/museum_address_review_2026-09-15.md) adds the Chipley
mailing consolidation and Peters Creek house/society pair. The
[Old Jail pass](../evidence/museums/museum_old_jail_review_2026-09-15.md) adds eight accepted
identity cases and two more source-conflict holds. The
[Union County pass](../evidence/museums/museum_union_county_review_2026-09-17.md) adds six
identity cases covering 15 source rows. The
[leaders pass](../evidence/museums/museum_leaders_review_2026-09-23.md) adds eight cases covering 19 rows,
one of them an isolated IMLS row whose legal name and EIN identify another organization.
The [methodology checkpoint](../evidence/museums/museum_methodology_2026-09-23.md) adds one Atlanta duplicate case.
The input had 92 source rows across 37 cases at that checkpoint. The September 26 batches
extend it; at the [M2 checkpoint](../evidence/museums/museum_m2_leaders_2026-09-26.md) it has
440 source rows across 185 cases, including 35 isolated conflicting rows.
A conflict row receives its own stable entity/site ID, `counted = FALSE` and
`reviewed_source_conflict`; its disputed aliases cannot propagate to accepted members.
Cases containing only conflicts need no canonical institution. Cases with accepted
members still require exactly one counted canonical record. An explicit
`reselected_canonical` role can replace the automatic primary-site choice with
a documented source row excluded only as `non_primary_site`, provided another
accepted member of that same baseline institution was counted. It cannot revive
an entirely excluded institution, a closed/nameless row, or a group supported
only by conflicting records. Full membership and source guards still apply;
the audit records the original false and corrected true counting flags.

Identity reconciliation does not certify a visitor location. Source coordinates remain
intact, including Mandeville's displaced points; the operator-supplied destination is
archived in the focused packet's `map_checks.csv`. The address packet's
`publication_locations.csv` stages separate publication coordinates, evidence and dated
access wording for Mandeville, Smedley and Peters Creek. Publication export must consume
these fields and refresh access checks. Generated review map links still use source
coordinates. The expanded IMLS review context now retains EIN and separate physical/mailing
street, city, state and ZIP fields as text. Readable addresses are assembled per original
row before combining repeated MIDs; institution summaries retain the source ID beside
each value. The legacy coalesced fields remain for compatibility, but are insufficient
for identity research: the earlier dossiers hid the Pennsylvania contradictions.
These fields enrich review sheets and future archives without changing analysis records
or applying new identity decisions. See the [field guide](../playbooks/complete-museum-review.md).
