# Affiliation follow-up checkpoint

2026-09-26 UTC. Supported corrections are validated; the overall affiliation and
headline review remains incomplete. Counts are provisional: **52,557 counted museum
institutions**, **52,425 eligible for L2**, **57,272 counted source records**, **125
identity rows in 51 cases**, **39 complete factual reviews**, eleven sourced
non-museum decisions. All 60,002 original source rows are retained.

The [packet](museum_affiliation_followup_2026-09-26/) includes preserved inputs,
384 Overture context records, IMLS address/EIN context, source acquisition statuses,
[research notes](museum_affiliation_followup_2026-09-26/research_notes.md), explicit
identity decisions and a source-level audit. Two Las Vegas wax-museum records now
represent one affiliated Madame Tussauds attraction with its current public name.
Two Archives of American Art office/research sites are excluded as additional museums.
Five Smithsonian parent-label records receive supported affiliation while their
institution membership/names remain pending; three generic parent rows remain unknown.

A consistency check also corrected two older independent flags: Washington County
Heritage Center shares its local operator with Warden's House and Hay Lake School;
Stevens Memorial Museum shares the John Hay Center operator with The Depot Railroad
Museum. Four companion records gain affiliation but keep full reviews pending.
Their museums remain separate. An independent nonprofit board does not make multiple
museums operated by that board independent of one another.

**253 test assertions and 17 integrity checks pass**, including all 366 protected
prior evidence/label files, unchanged automatic baseline and multisite queue,
unchanged threshold 0.85, original source fields, guarded replay and both exports.
[Validation](museum_affiliation_followup_2026-09-26/validation.log).
The initial sub-checkpoint is preserved in initial_* files; use
museum_decisions_final.csv for the final decisions and the archived identity/name
inputs for reproduction. Do not rerun prepare.R, resume_prepare.R, apply.R or
local_operator_apply.R. No new independent accuracy estimate is made.

[M2 semantic review](museum_affiliation_followup_2026-09-26/m2_semantic_review.csv)
records why a scope token alone does not establish a singularity claim. Subjects
such as African American history or international folk art must not be presented as
claims of exclusive institutional scope. No M2 collision group is certified here.

Old Jail, county groups, newly exposed top-name groups, Smithsonian identity cases,
Museum of Illusions Miami Beach and the earlier queues remain incomplete. The explicit
Old Jail gate still fails. The post may proceed only as a visibly provisional local
draft until those factual/publication requirements are met. No external blog directory
is configured and the default ../blog directory is absent. Cloud spending USD 0.
