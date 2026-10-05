# Duplicate Names — Development Plan

**Moved.** On 2026-10-05 this plan moved into the [knowledge bundle](knowledge/index.md),
an [Open Knowledge Format](knowledge/conventions.md) v0.2 bundle, one concept per section.
The text moved verbatim, with section references turned into links. The original is
`git show 7416eef:DESIGN.md`. The headings below keep old links and the `DESIGN.md §N`
references in code comments working. Edit the concepts, not this file.

## 1. The premise

[Premise and core questions](knowledge/project/premise.md)

### The core questions

[M1-M4 and C1-C5](knowledge/project/premise.md#the-core-questions)

## 2. Deliverables

[Deliverables D1-D7](knowledge/project/deliverables.md)

## 3. Data sources

[Data sources overview](knowledge/datasets/overview.md), with one concept per source in
[datasets](knowledge/datasets/index.md)

## 4. The hard part: name normalization

[Methodology](knowledge/methodology/index.md)

### 4.1 Normalization ladder

[Name normalization ladder (L0-L4)](knowledge/methodology/normalization-ladder.md)

### 4.2 Structured extraction

[Structured extraction](knowledge/methodology/structured-extraction.md)

### 4.3 Entity resolution (deduplicating the *data*, not the *names*)

[Entity resolution](knowledge/methodology/entity-resolution.md)

### 4.3.1 Curated identity corrections

[Curated identity corrections](knowledge/methodology/identity-corrections.md)

### 4.4 Franchise / branch detection (M4)

[Franchise and branch detection](knowledge/methodology/chain-detection.md)

### 4.5 Category-only names

[Category-only names](knowledge/methodology/category-only-names.md)

## 5. Metrics — defined before we look

[Metrics](knowledge/metrics/index.md); the implementation-status paragraphs are in the
[museum publication gate](knowledge/methodology/publication-gate.md)

## 6. Known traps

[Known traps](knowledge/methodology/known-traps.md)

## 7. Technical architecture

[Architecture overview](knowledge/architecture/overview.md), plus
[distance correctness](knowledge/architecture/distance-correctness.md),
[reproducibility](knowledge/architecture/reproducibility.md),
[renv gotchas](knowledge/architecture/renv.md) and
[licensing](knowledge/architecture/licensing.md)

### 7.1 Publishing into blogdown

[Publishing into blogdown](knowledge/architecture/blog-publishing.md)

### 7.2 Dashboard (Phase 4)

[Dashboard design](knowledge/architecture/dashboard.md)

### 7.3 Blog defaults (adjustable)

[Blog defaults](knowledge/architecture/blog-defaults.md)

## 8. Phases

[Phases](knowledge/project/phases.md), including the
[Immediate Phase 2 deliverable](knowledge/project/phases.md#immediate-phase-2-deliverable-as-of-2026-09-26);
the live state is the [current status report](knowledge/project/status.md)

## 9. Decisions

[Decisions](knowledge/decisions/index.md), one concept per decision:

1. [US-first scope](knowledge/decisions/01-us-first-scope.md)
2. [R blogdown output](knowledge/decisions/02-r-blogdown-output.md)
3. [Temporal C5 deferred to post 3](knowledge/decisions/03-temporal-c5-deferred.md)
4. [First Baptist split gets its own post](knowledge/decisions/04-first-baptist-split-own-post.md)
5. [Museums first, in two halves](knowledge/decisions/05-museums-first-phasing.md)
6. [Closed museums flagged, not counted](knowledge/decisions/06-closed-museums-flagged-not-counted.md)
7. [The physical institution is the unit](knowledge/decisions/07-physical-institution-unit.md)
8. [Blog integration defaulted](knowledge/decisions/08-blog-integration-defaults.md)
9. [Museum headlines use L2](knowledge/decisions/09-museum-headlines-use-l2.md)
10. [Retain the 0.85 threshold](knowledge/decisions/10-retain-085-threshold.md)
11. [Auditable identity corrections](knowledge/decisions/11-auditable-identity-corrections.md)
12. [Separate chains from the headline](knowledge/decisions/12-separate-chains-from-headline.md)
13. [Exclude sourced non-museums](knowledge/decisions/13-exclude-sourced-non-museums.md)
14. [Post 1 headline-sufficient review and stopping rules](knowledge/decisions/14-post-1-headline-sufficient-review.md)

### Still open

[Open questions](knowledge/project/open-questions.md#publication-details-still-open)

## 10. Cross-references

[Knowledge bundle index](knowledge/index.md)
