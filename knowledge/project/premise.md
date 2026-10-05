---
type: Project Brief
title: "Premise and core questions"
description: "Why the project exists and the research questions it answers: museums assert uniqueness (M1-M4); churches enumerate (C1-C5)."
tags: [museums, churches, questions]
sequence: 4
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: design
    resource: 7416eef:DESIGN.md
    title: "DESIGN.md §1 and the §5 preamble, as of commit 7416eef (moved here verbatim)"
---

Standing in Bangor, Maine, in front of the **International Cryptozoology Museum**, the
obvious question is not "is cryptozoology real" but "is this *the* one?" The name makes a
claim of singularity — *International*, definite article implied — and nobody adjudicates
that claim. There is no registrar of institutional names. Anyone can be The Museum of
anything.

That opens a general question: **when a place name asserts uniqueness, how often is it
actually unique?** And its inverse: **when a name is obviously generic, how does the
namespace get carved up geographically?**

Churches are the richer case, because they solved the collision problem explicitly and
centuries ago: they *numbered themselves*. First Presbyterian, Second Presbyterian, Third.
That is a namespace with a versioning convention baked in — and a territory rule implied by
it. Museums assert; churches enumerate.

# The core questions

**Museums**

- M1. What is the most duplicated museum name in the US?
- M2. Which *singular-claiming* names (The / International / National / World / American …)
  have collisions anyway? Rank by hubris-vs-reality.
- M3. How does the generic tail behave — Natural History, Children's, Fire, Railroad,
  County Historical? These collide by necessity, not accident. Different phenomenon,
  worth separating.
- M4. Which collisions have evidence of common ownership or branch affiliation, and which
  are independent institutions sharing a name? Repeated templates such as `Children's
  Museum of X` or `X County Historical Museum` form a separate explanatory category;
  the wording alone does not make them chains.

**Churches**

- C1. Which church names are duplicated most, nationally?
- C2. How far apart do two `First [Denomination] Church`es sit? What is the *territory* of
  a First — and is that territory a real spacing rule, or just a proxy for "one per
  municipality"?
- C3. How high does the ordinal ladder go? Highest observed Nth. Is the ladder complete —
  does a Fourth imply a First, Second, and Third nearby?
- C4. Which denominations count, and which invent? Ordinal vs. saint vs. virtue vs.
  toponym vs. modern-brand naming cultures.
- C5. *(deferred to post 3 — see [deliverables](deliverables.md))* Has the practice changed over time? Hypothesis:
  ordinals are a 19th-century urban mainline habit; the 20th century goes toponymic and
  virtue-based; the 21st goes single-word brand (Elevation, Life, Journey, Mosaic,
  The Rock).

# Metrics defined before looking

The original questions were defined before analysis. Subsequent methodological decisions
are recorded as [decisions](../decisions/index.md) so changes such as the museum L2 choice remain visible. The metrics themselves are in [metrics](../metrics/index.md).
