# Museum publication preparation — September 26, 2026

This checkpoint prepares an **unpublished draft**, not a certified museum winner.
The [affiliation checkpoint](museum_affiliation_followup_2026-09-26.md) precedes it.

The reviewed data retain all 60,002 original records: 57,272 counted source rows,
52,557 counted institutions and 52,425 eligible L2 institutions. There are 125
identity rows in 51 cases, seven isolated source conflicts and eleven sourced
not-museum decisions. Forty institutions have complete factual reviews.

The International Cryptozoology Museum seed now has a complete factual review:
its operator documents the current Bangor location, closed older locations, and
its own nonprofit governance. Four historical source records represent one reviewed
institution. This does not establish worldwide uniqueness. The explicit selected-name
publication gate passes for this seed; the leading M1/M2 groups remain uncertified.
See [gate results](museum_publication_2026-09-26/publication_gates.csv) and
[remaining work](museum_publication_2026-09-26/publication_blockers.csv).

## Publication tooling and draft

`dn_museum_publication_points()` checks source identity/name/coordinate guards,
evidence and dates, and adds separate publication coordinates and access wording.
It never replaces source points. The three sourced address overrides have fresh
operator access checks: Mandeville remains closed; Smedley lists weekend access;
Wright House lists events or arranged tours. Pending identity reviews still prevent
visitor-ready status. These checks expire after 30 days by default.

The [museum bundle](../../posts/duplicate-museum-names/README.md) contains its own
payloads and helpers, a clearly provisional count-comparison chart, and matching
validation evidence. It explains the pending M1/M2 checks rather than claiming a
national winner. Front matter retains `draft: true`.

The bundle was rendered in an isolated directory with the analysis checkout and
blog path unavailable, using a portable, checksum-verified official Pandoc release.
A fresh R subprocess rendered a self-contained preview. The first attempt exposed
helper scoping; sourcing helpers into the knitting environment fixed it. The original
failed log is retained. The final title, draft notice and chart were inspected in
the in-app browser at a narrow viewport; caption wrapping and chart labels were fixed.
See [build evidence](museum_publication_2026-09-26/standalone_build.json).

**Validation:** 265 assertions and 10 integrity checks pass; all 418 protected prior
files are unchanged. The original independent labels, automatic museum baseline,
source fields and 0.85 threshold are preserved. These checks do not certify factual
judgments or final-cluster accuracy.

**Incomplete:** county/Old Jail and new leader reviews, unresolved Smithsonian roles,
M2 meaning and identity checks, final headline payloads and publication. No blog
checkout is configured and the default destination is absent. No site was published.
Church acquisition can proceed independently. Cloud resources used: USD 0.
