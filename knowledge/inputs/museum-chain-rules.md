---
type: Decision Table
title: Museum chain rules
description: Sourced brand-affiliation rules and ambiguous-name review hints that the museum pipeline matches against every source record; no match means unknown affiliation, not independence.
resource: ../../data/validation/museum_chain_rules.csv
tags: [museums, chains, affiliation]
status: stable
implemented_in:
  - ../../_targets.R
  - ../../R/schema.R
  - ../../R/museums.R
  - ../../R/resolve.R
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: csv
    resource: ../../data/validation/museum_chain_rules.csv
    title: Live museum chain rules (museum_chain_rules.csv)
  - id: code
    resource: ../../R/museums.R
    title: Museum analysis, affiliation evidence and review queues (R/museums.R)
  - id: resolve
    resource: ../../R/resolve.R
    title: Entity resolution and franchise flagging (R/resolve.R)
  - id: analysis-report
    resource: ../../data/validation/museum_analysis_2026-09-15.md
    title: Initial Phase 2 museum analysis report
  - id: index
    resource: 7416eef:data/validation/README.md
    title: Validation evidence index at 7416eef, decision inputs and human labels
  - id: readme
    resource: 7416eef:README.md
    title: Project README at 7416eef, running and archive helper
  - id: agents
    resource: ../../AGENTS.md
    title: Repository guidelines for coding agents
---

# Purpose

`museum_chain_rules.csv` holds sourced brand-affiliation rules and ambiguous-name review
hints; unknown does not mean independent.[^index] A rule matches a regular expression against
each source record and gives the matching entity a `chain_id`, so chain locations can be kept
out of the M1/M2 headlines and reported beside them.[^agents] The
[initial Phase 2 analysis](../evidence/museums/museum_analysis_2026-09-15.md) introduced it:
affiliation now requires a sourced rule or an explicit decision.[^analysis-report]
Per-institution affiliation decisions live in [museum decisions](museum-decisions.md).

# Schema

`dn_read_museum_review()` reads every column as text (blank or `NA` is missing) and checks the
columns against `dn_schema_chain_rules()`; a missing or extra column stops the build.[^code]

| Column | Type | Description |
|---|---|---|
| `rule_id` | text | Rule identifier; required and unique |
| `chain_id` | text | Brand assigned to matching entities, or the review hint for a `candidate` rule; required |
| `match_on` | text | `name` (cleaned, expanded L2 form of `name_raw`), `operator` (cleaned `operator` field) or `candidate` (name match that sets only `chain_candidate`) |
| `pattern` | text | Perl regular expression; must be non-empty |
| `evidence_url` | text | Source for the rule; must start with `https://` |
| `evidence_note` | text | Scope and limits of the evidence; not validated |
| `reviewed_by` | text | Reviewer; required |
| `reviewed_on` | text (date) | Review date, `YYYY-MM-DD`; required |

# Rules

- `dn_affiliation_evidence()` stops unless rule IDs are unique, `match_on` is valid, patterns
  are non-empty, evidence starts with `https://`, and chain ID, reviewer and date are
  present.[^code]
- Each original record is matched, then the evidence propagates across its entity. The
  operator of one entity is never taken to control a similarly named one.[^code]
- Two non-candidate rules that assign different chains to one entity stop the build.[^code]
- No match leaves `is_franchise` as `NA`. A nonempty operator or a repeated naming template
  cannot establish affiliation.[^resolve] Unknown affiliation is `NA`, not
  independence.[^agents]
- A brand rule does not establish that each matching record is a distinct, currently
  operating museum.[^analysis-report]
- An explicit row in `museum_decisions.csv` replaces the rule-derived affiliation of the
  entity it addresses.[^code]
- Headlines exclude chain-affiliated locations; chains are reported with `museum_chains` and
  `museum_chain_overlap`.[^agents]

# Current contents

As of commit 7416eef: six rules and six `chain_id` values, all reviewed by "Codex source
review" on 2026-09-15. There are no `operator` rules.[^csv]

| `rule_id` | `chain_id` | `match_on` |
|---|---|---|
| `play_street` | `play_street` | name |
| `ripleys` | `ripleys` | name |
| `madame_tussauds` | `madame_tussauds` | name |
| `ice_cream` | `museum_of_ice_cream` | name |
| `illusions` | `illusions_network_unresolved` | candidate |
| `smithsonian` | `smithsonian_parent_label` | candidate |

The `illusions` note says generic brand wording is shared by different networks and needs
location-specific evidence. The `smithsonian` note says parent labels may describe offices or
research facilities.[^csv] Git history has one commit for this file (4b90ee6, 2026-09-15).

# Consumers

- `_targets.R`: `museum_chain_rules_file` → `museum_chain_rules`. It feeds `entities` through
  `dn_flag_franchises()` and `museum_analysis` through `dn_museum_analysis()`.[^resolve][^code]
  So a rule change also changes the automatic baseline's `is_franchise`/`chain_id` flags.
- Downstream: `dup_museums`, `museum_ranking`, `museum_chains`, `museum_chain_overlap` and
  `museum_review_files`.
- `scripts/archive_museum_review.R` records its checksum; it does not copy the file.[^readme]
- Method: [chain detection](../methodology/chain-detection.md);
  [decision 12](../decisions/12-separate-chains-from-headline.md).

# Preservation

- Preserve the current file in a new dated packet before changing it; dated copies describe
  their own checkpoint.[^index] Recent packets save it as `museum_chain_rules_before.csv`, for
  example in the
  [M2 packet](../../data/validation/museum_m2_leaders_2026-09-26/museum_chain_rules_before.csv).
- Never edit an archived copy. See [preserve evidence](../playbooks/preserve-evidence.md).

[^csv]: Live museum chain rules (museum_chain_rules.csv)
[^code]: Museum analysis, affiliation evidence and review queues (R/museums.R)
[^resolve]: Entity resolution and franchise flagging (R/resolve.R)
[^analysis-report]: Initial Phase 2 museum analysis report
[^index]: Validation evidence index at 7416eef, decision inputs and human labels
[^readme]: Project README at 7416eef, running and archive helper
[^agents]: Repository guidelines for coding agents
