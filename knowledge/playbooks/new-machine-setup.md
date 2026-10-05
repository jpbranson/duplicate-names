---
type: Playbook
title: "Getting running on a new machine"
description: "Clone, restore the R 4.4.2 library, run the selective builds, and know which inputs are not in the repository."
tags: [setup, reproducibility]
sequence: 1
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: handoff
    resource: 7416eef:HANDOFF.md
    title: "HANDOFF.md §1, as of commit 7416eef (moved here verbatim)"
---

```bash
git clone https://github.com/jpbranson/duplicate-names.git
cd duplicate-names
```

```r
renv::restore()      # 137 packages, pinned
```

**Pin R to 4.4.** The lockfile records 4.4.2. On the previous machine R 4.6.1 was
installed but had an empty library, so a newer R will not "just work" — it will try to
rebuild everything. On the current Windows machine the `Rscript` on `PATH` is 4.3.2 without
the renv library; call `C:\Program Files\R\R-4.4.2\bin\Rscript.exe` explicitly.

For the current museum review (preserves the completed working label sheet):

```r
targets::tar_make(names = c(museum_review_files, museum_identity_audit_file,
                            museum_records_file, dup_museums,
                            multisite_review, entities_file))
source("tests/testthat.R")              # source functions, then run tests
targets::tar_make(script = "_targets_churches.R", store = "_targets_churches",
                  names = church_output_files)   # church outputs
```

Before a full `targets::tar_make()`, archive any new human labels: `labelling_sheet`
rewrites the working CSV. See [README.md](../../README.md#running) for scoring and archiving.

# What is NOT in the repo

`data/raw/` and `data/processed/` are gitignored. The pipeline rebuilds its generated
analysis outputs when needed — the earlier cold run took **~5 minutes**, almost all
of it the Overture S3 query and tigris gazetteer download. These inputs need no
credentials: Overture's S3 bucket is public and reads anonymously.

`data/raw/MANIFEST.json` **is** tracked, with provenance and checksums for the museum
inputs and the identity-context query. The Census 2023 gazetteer is cached separately
and is not yet recorded in the manifest. The 38-row Overture identity-context query was
research outside the pipeline; `tar_make()` does not recreate it. Its
[tracked copy](../../data/validation/museum_identity_review_2026-09-15/overture_context.csv)
and the manifest's SQL preserve that evidence.
The address follow-up also records the public IRS Florida/Arkansas/Pennsylvania files
and operator pages in the manifest. These research caches are outside the pipeline;
selected IRS rows and the extracted Smedley marker are tracked in the address packet.
The Old Jail packet adds a 41-row Overture context query and 19 cached operator/government
pages. Its tracked context and manifest SQL preserve the query; it is also outside the pipeline.
The Union County packet adds a 21-row Overture context query and 30 cached public documents.
Its tracked extracts, evidence ledger and manifest snapshot preserve that later research;
`tar_make()` does not recreate these acquisitions either. The leaders packet adds 22- and
18-row Overture context queries and 46 cached public documents, including IRS Kansas and
Mississippi extracts and the IRS revocation list, under the same rules.

Human labels are preserved separately in `data/validation/`, outside the ignored,
rebuildable directories. The archived CSV cannot be recreated by `tar_make()`.
