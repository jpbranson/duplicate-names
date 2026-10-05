---
type: Dataset
title: IRS exempt-organization files
description: "IRS Business Master File state extracts and the revocation list: evidence for museum identity research, and a weak planned founding-date proxy for C5."
resource: https://www.irs.gov/pub/irs-soi/
tags: [datasets, museums, churches, identity]
sequence: 8
license: Public domain
role: research evidence; planned for post 3
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: design
    resource: 7416eef:DESIGN.md
    title: DESIGN.md §3 data sources, as of commit 7416eef
  - id: handoff
    resource: 7416eef:HANDOFF.md
    title: HANDOFF.md §1 what is not in the repo, as of commit 7416eef
  - id: manifest
    resource: ../../data/raw/MANIFEST.json
    title: Input provenance manifest (IRS downloads)
---

# Role

- **Identity research.** Review packets cached IRS state extracts (Florida, Arkansas and
  Pennsylvania in the address follow-up; Kansas and Mississippi in the leaders review) and
  the revocation list to link EINs and mailing addresses to museums.[^handoff] These
  acquisitions sit outside `_targets.R`; their packets preserve the extracted
  evidence.[^design] An IRS revocation never by itself supports a `not_museum` decision
  ([decision 13](../decisions/13-exclude-sourced-non-museums.md)).
- **Planned temporal proxy.** The Business Master File `RULING` date is a weak proxy for
  congregation founding. Churches are exempt from filing, so coverage is partial and biased
  toward larger, incorporated bodies: use with loud caveats, or not at all.[^design]

Each download's URL, retrieval time and SHA-256 is in the manifest.[^manifest]

[^design]: DESIGN.md §3 data sources, as of commit 7416eef
[^handoff]: HANDOFF.md §1 what is not in the repo, as of commit 7416eef
[^manifest]: Input provenance manifest (IRS downloads)
