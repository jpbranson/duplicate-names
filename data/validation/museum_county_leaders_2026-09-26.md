# County society leaders — supported corrections and remaining questions

2026-09-26 UTC. Investigated all 33 starting Franklin, Greene and Jackson County
Historical Society candidates and related source records. This is a validated
correction batch, **not completion of the headline review**. Each bare-name group
falls from eleven to six provisional non-chain institutions. None is certified.

| Measure | September 23 | This checkpoint |
|---|---:|---:|
| Original source rows retained | 60,002 | 60,002 |
| Counted source records | 57,292 | 57,274 |
| Counted museum institutions | 52,584 | 52,563 |
| Eligible for L2 analysis | 52,452 | 52,431 |
| Explicit identity rows / cases | 92 / 37 | 121 / 49 |
| Complete factual reviews | 19 | 28 |
| Sourced not-museum decisions | 3 | 7 |
| Isolated source conflicts | 5 | 7 |

The [packet](museum_county_leaders_2026-09-26/) preserves pre-review inputs, 296
Overture address/contact records from the pinned release, IMLS EIN/physical/mailing
context, public source acquisition status and manifest hashes, applied decisions,
audits, before/after rankings, and the [remaining queue](museum_county_leaders_2026-09-26/follow_up.csv).
Research notes explain [Franklin](museum_county_leaders_2026-09-26/research_notes.md),
[Greene](museum_county_leaders_2026-09-26/greene_notes.md), and
[Jackson](museum_county_leaders_2026-09-26/jackson_notes.md).

Franklin corrections consolidate Chambersburg's Old Jail/society, Rocky Mount's
current museum/mailing record, Columbus COSI records and its exhibit, and Ottawa's
society/archive records. The Ottawa research/administrative institution is not a
separate museum; Old Depot Museum remains separate. Greene corrections consolidate
Waynesburg, Stanardsville's current/former site, Bronck Museum and Jefferson's museum,
while isolating a museum-labelled bank-address row. Springfield's preservation
society is excluded separately from History Museum on the Square.

Jackson corrections consolidate Lakefield's museum, separate Independence's History
Center from the 1859 Jail Museum, and isolate a Baldwin/Maquoketa mixed source record.
The Newport museum-support society and Maquoketa genealogy library are not additional
museums. Distinct Iowa subordinate EINs must not be merged on their shared IRS legal
name. Library research at a museum does not itself make that museum out of scope:
Murphysboro's operator explicitly documents museum exhibits and remains counted.

The Missouri split required an explicit `split_canonical` role. Each destination
site group has exactly one representative; all affected baseline-cluster members
must be listed in one guarded case. Stable new IDs and aliases drawn only from
assigned source rows prevent the other institution's names from leaking across the
split. Former-site assignments are rejected in split cases because the current
schema cannot specify their destination unambiguously. Ordinary merge behavior and
the automatic matching baseline remain unchanged.

Validation: **231 test assertions and 23 integrity checks pass**, including guarded
replay, refreshed reviewed Parquet, unchanged automatic baseline/multisite queue,
60,002 original source rows/fields, unchanged threshold 0.85, and all 247 protected
prior evidence/label files. The explicit publication gate still rejects the unfinished
Jackson group; the Franklin and Greene sub-batches likewise recorded rejected gates.
See [validation log](museum_county_leaders_2026-09-26/jackson_validation.log) and
[checks](museum_county_leaders_2026-09-26/jackson_integrity_checks.csv).

The old human-label sample was not regraded and these factual decisions are not
independent accuracy labels. Preferred public names, uncertain museum roles and
several older addresses remain pending. Local operators with multiple distinct
museums need consistent common-operator affiliation treatment in the next Old Jail
pass; Chambersburg's current independent flag must be revisited under that rule.
No national winner or complete present-day museum census is established here.
Cloud resource spending for this work remains USD 0.

Read-only reproduction: source `R/`, read the packet's `jackson_*_decisions_after.csv`,
apply `dn_reconcile_museums()` to the unchanged saved `entities`, then
`dn_museum_analysis()` with the saved rules and decisions. Do not rerun `prepare.R`
or the one-time apply scripts. `build_check_county.R jackson` is the selective
rebuild/check command for this checkpoint; future live inputs will require a new
packet rather than overwriting this one.
