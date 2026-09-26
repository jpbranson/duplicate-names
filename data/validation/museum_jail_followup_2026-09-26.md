# Old Jail follow-up — validated corrections, incomplete headline review

2026-09-26 UTC. The supported correction batch is complete; the Old Jail headline
review is not. Its non-chain L2 group falls from eleven to eight institutions,
with four complete factual reviews and four pending cases.

| Measure | County checkpoint | This checkpoint |
|---|---:|---:|
| Original source rows retained | 60,002 | 60,002 |
| Counted source records | 57,274 | 57,273 |
| Counted museum institutions | 52,563 | 52,560 |
| Eligible for L2 analysis | 52,431 | 52,428 |
| Explicit identity rows / cases | 121 / 49 | 123 / 50 |
| Complete factual reviews | 28 | 36 |
| Sourced not-museum decisions | 7 | 9 |
| Isolated source conflicts | 7 | 7 |

The [packet](museum_jail_followup_2026-09-26/) preserves before/after decisions,
source acquisition results and hashes, evidence notes, audits, ranks and validation.
[Applied decisions](museum_jail_followup_2026-09-26/applied_name_decisions.csv)
explain each record-level change. Shared operators link Allegan jail/village,
Sandersville jail/Brown House, and Chambersburg jail/John Brown House, without
merging the separate visitor institutions. Chambersburg's earlier independent flag
was corrected. Companion institutions remain pending where their full review is unfinished.

Barnesville's archives and former corporate office are reconciled as one excluded
non-museum institution. Its jail museum remains separate. Historic Tours of America's
generic St Augustine operator/campus record is not a fourth museum beside its named
attractions. Lawrenceburg, Barnesville, Smethport and St Augustine have sourced factual
reviews. Smethport now uses the operator's public name, **The County Museum in The Old
Jail**, through a guarded preferred-name input; its source name and coordinates are unchanged.

Validation: **253 assertions and 17 integrity checks pass**, including all 325 protected
prior evidence/label files, original source fields, automatic baseline, original
threshold 0.85, guarded replay and refreshed Parquet. See the
[log](museum_jail_followup_2026-09-26/validation.log) and
[checks](museum_jail_followup_2026-09-26/integrity_checks.csv).
The explicit publication gate correctly rejects the unfinished Old Jail group.
These source decisions are not independent matching-accuracy labels.

[Remaining cases](museum_jail_followup_2026-09-26/human_review.csv): Hayesville needs
current public-name/operator/campus confirmation; Winchester needs current governance
and the relationship between two distinct legal organizations; Thompson Falls needs
current governance and precise visitor-address wording; Greenwood needs museum-campus
scope confirmation. Failed access, historical leases and public repair funding do not
settle these questions. No outreach message has been sent. Visitor access and publication
map points require a dated check even for institutions with complete factual review.

The lower corrected groups reveal other unreviewed leaders (including Depot Museum
and Wayne County Historical Society at ten). This checkpoint does not establish a
national winner. County and earlier queues also remain open. Continue independent
Smithsonian/affiliation work while preserving these gaps for human review.

Do not rerun the one-time prepare/apply scripts. Read-only reproduction uses archived
after-inputs, the unchanged entities target, dn_reconcile_museums() and dn_museum_analysis()
with the saved gazetteer. build_check.R validates this live checkpoint; do not overwrite
it after a successor changes the live inputs. Cloud resource spending remains USD 0.
