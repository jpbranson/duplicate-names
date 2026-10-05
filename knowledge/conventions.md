---
type: Guide
title: Knowledge bundle conventions
description: How this Open Knowledge Format (OKF v0.2) bundle is organized, what each type and frontmatter key means here, and how to maintain it.
tags: [okf, maintenance]
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: okf-spec
    resource: https://raw.githubusercontent.com/GoogleCloudPlatform/open-knowledge-format/refs/heads/main/SPEC.md
    title: Open Knowledge Format specification, version 0.2
    author: team:google-cloud-open-knowledge-format
---

# Scope

`knowledge/` is the project's knowledge bundle in [Open Knowledge Format
v0.2](https://raw.githubusercontent.com/GoogleCloudPlatform/open-knowledge-format/refs/heads/main/SPEC.md).[^okf-spec]
It holds everything the project knows: questions, methods, decisions, metrics, data sources,
decision inputs, evidence checkpoints, current status, work history, leads and playbooks.

It does **not** hold the evidence itself. Dated packets, decision CSVs and human labels stay
under `data/validation/`, where checksums protect them byte for byte. Concepts here describe
and cite those files; never edit a dated packet to fit the bundle.

Outside the bundle:

- `README.md` explains setup, builds, tests and repository layout.
- `AGENTS.md` holds the rules every coding agent loads automatically.
- `DESIGN.md`, `HANDOFF.md`, `LEADS.md` and `FLIGHT_LOG.md` are redirect stubs that keep
  older links and section anchors working. Do not add content to them.

# Layout

| Directory | Holds | Main `type` values |
|---|---|---|
| `project/` | Premise, deliverables, phases, current status, mission, work logs, open questions, pitfalls | `Project Brief`, `Plan`, `Status Report`, `Mission`, `Work Log`, `Open Questions`, `Reference` |
| `decisions/` | Numbered project decisions (1–14 so far) | `Decision` |
| `methodology/` | Normalization, extraction, entity resolution, identity corrections, chains, category names, publication gate, known traps | `Method`, `Reference` |
| `metrics/` | Pre-registered museum (M1–M3) and church (C1–C5) metrics | `Metric` |
| `datasets/` | Source datasets, used or rejected | `Dataset`, `Reference` |
| `inputs/` | Live decision tables and the human-label archive that feed the pipelines | `Decision Table`, `Label Set` |
| `evidence/` | One concept per dated validation packet, by track (`museums/`, `churches/`, `artifacts/`) | `Evidence Packet` |
| `architecture/` | Stack, reproducibility, licensing, blog publishing, dashboard | `Design Note` |
| `playbooks/` | Step-by-step procedures | `Playbook` |
| `publications/` | State of each post and the explorer | `Publication` |
| `leads/` | Analogous naming phenomena for future posts | `Lead` |

Every directory has a generated `index.md`. The bundle root `index.md` is written by hand
and declares `okf_version: "0.2"`. `log.md` at the root records changes to the bundle.

# Frontmatter used here

OKF requires only `type`. This bundle also uses:

- `title`, `description` (one sentence; copied into indexes), `tags`, and `resource` when
  the concept describes one concrete file, dataset or URL.
- **Provenance:** `sources`, each with `id`, `resource` and `title`. Cite a specific claim
  with a footnote whose label is the source `id`, for example `[^report]`. Text moved from
  the pre-bundle documents cites a git object such as `7416eef:DESIGN.md`; read it with
  `git show 7416eef:DESIGN.md`.
- **Trust:** `generated: { by, at }` on every concept. `verified` is added only when a person
  (`human:<id>`) or a named process confirms the concept against its sources. It is absent
  everywhere at migration, so every concept starts in the *unverified* tier.
- **Lifecycle:** `status` is `stable` (the default, may be omitted), `draft` (a proposal not
  yet applied or approved) or `deprecated` (kept for links and history; superseded).
  `stale_after` marks content that must be rechecked by a date, such as the status report
  or dated visitor-access wording.

Producer-defined keys (OKF permits extensions):

| Key | Meaning |
|---|---|
| `checkpoint` | Date (`YYYY-MM-DD`) of the dated checkpoint a concept describes |
| `sequence` | Integer order within a directory's generated index; evidence packets run oldest first |
| `publication_state`, `slug` | State and planned URL slug of a post or the explorer (`publications/`) |
| `license`, `role` | A dataset's license and how the project uses it (`datasets/`) |
| `surfaced` | Date a surfaced lead was found |
| `superseded_by` | Relative path of the concept that replaced a `deprecated` one |
| `decision` | Decision number, matching the historical "DESIGN decision N" references |
| `decided` | Date a decision was settled |
| `approved_by` | Actor recorded in the sources as approving a decision; omitted when unknown |
| `questions` | Research questions a metric answers, such as `[M1]` or `[C2]` |
| `implemented_in` | Relative paths of the code implementing a method or metric |
| `lead_origin` | `seeded` (before analysis) or `surfaced` (found during analysis) |

**Two meanings of "verified".** OKF `verified` says who confirmed a *concept document*. The
data field `review_status = verified` means an institution's factual review is complete.
Neither implies the other, and neither is an independent matching-accuracy label.

# Actors

- Agents and tools: `<producer>/<version>`, for example `claude-code/claude-opus-5-5`.
- People: `human:<id>`, for example `human:jpbranson`. Only a person may add a `human:`
  verification.
- Automated processes: `process:<id>`.

# Links and paths

Use **relative** links and paths everywhere, measured from the file that contains them
(`../decisions/14-post-1-headline-sufficient-review.md`,
`../../data/validation/museum_decisions.csv`). OKF also allows `/`-rooted bundle paths, but
GitHub resolves a leading `/` against the repository root rather than `knowledge/`, so they
break in the browser. `dn_okf_check()` requires every relative link to resolve.

# Maintenance

1. **Edit concepts, not stubs.** Update the concept that owns a fact and refresh its
   `generated`. When a fact changes over time, add the new state and keep the dated history.
2. **New evidence packet.** Add `evidence/<track>/<packet basename>.md` with the next
   `sequence`. Set the previous current packet to `status: deprecated` with `superseded_by`.
   Then update [the status report](project/status.md) and any input, method or publication
   concept whose facts changed.
3. **New decision.** Add `decisions/NN-<slug>.md` with `decision`, `decided` and, when
   recorded, `approved_by`.
4. **New lead.** When an analogous naming phenomenon surfaces during analysis, record it
   rather than chasing it inline: add `leads/<slug>.md` (`type: Lead`,
   `lead_origin: surfaced`, `surfaced: YYYY-MM-DD`) with the question, why it is
   interesting, and a data note.
5. **Mission progress.** Append checkpoint entries to [the flight log](project/flight-log.md)
   and keep [the mission board](project/mission.md) current.
6. **Regenerate and check.** From the repository root, in R 4.4.2:

   ```r
   for (f in list.files("R", pattern = "[.]R$", full.names = TRUE)) source(f)
   dn_okf_write_indexes("knowledge")   # rewrite every generated index.md
   dn_okf_check("knowledge")           # character(0) when conformant
   ```

   `tests/testthat/test-knowledge.R` runs the same check and fails on stale indexes.
7. **Log it.** Add a dated entry, newest first, to [the bundle log](log.md).

[^okf-spec]: Open Knowledge Format specification, version 0.2
