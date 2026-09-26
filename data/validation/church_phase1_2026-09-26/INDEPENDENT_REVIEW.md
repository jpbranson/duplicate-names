# Independent church validation protocol

These labels must come from a human who independently checks the evidence. The
assistant must not fill truth columns or use its factual decisions to measure its
own accuracy. Original museum labels are unchanged and cannot evaluate this cohort.

## Matching

Generated `matching_labels_blank.csv` presents names, source IDs, points and source
dates without the predicted similarity/merge result. Predictions and sampling strata
are separate in `matching_predictions.csv`. The reproducible seed is 20260926.
The sample draws up to 30 pairs per similarity band for each of two strata: within
Overture and Overture versus historical/legal sources, up to 300 pairs in total.
All candidates are within 150 m. Blank means unresolved; use 1 for the same
institution and 0 for distinct institutions. Record reviewer, official evidence URL
and notes, including historical/current identity distinctions or uncertain points.
A shared name, tax address, website domain or denomination alone is not sufficient.

Save completed work outside `data/processed/` under a new dated `data/validation/`
file before rebuilding generated sheets. Preserve the blank sample and predictions
as well. Do not lower 0.85 or change gold labels to improve a measured score. Any
threshold adjustment needs a further independent evaluation set. Report coverage,
uncertain labels, confusion matrix, and per-stratum results. Weighted candidate-pair
estimates require the retained stratum sizes and sample counts. No result estimates
nationwide current-institution completeness or final transitive-cluster accuracy.

`cluster_review.csv` separately lists automatic multi-record clusters. Final-cluster
identity needs review distinct from pair-level validation. Multi-campus institutions,
relocations and out-of-radius matches require additional evidence; they cannot be
certified by the 150 m sample.

## Naming styles and denomination families

`classifier_labels_blank.csv` draws up to 63 institutions per predicted style and
caps the total at 500, without displaying the predicted labels. The separated
`classifier_predictions.csv` retains the sampling stratum and population size.
Label `ordinal`, `saint`, `virtue`, `toponym`, `modern_brand`, `ethnolinguistic`,
`descriptive` or `other`, and add a broad denomination family when supported.
Allow unresolved labels and state the tie-breaking convention before scoring.
A heuristic style, operator identity and a congregation's own description can differ.
Do not infer congregation members' demographics or history from names.

Publish a confusion matrix and stratified/weighted error estimate only after the
labels exist. The current classifier has no measured error rate. Dictionary tests
check implementation behavior, not the truth of cultural interpretations.

## Publication gate

Independent labels do not replace official-source verification of the leading names,
highest ordinals, current operation, or congregation versus campus identities. Names
alone cannot explain a missing Third or a city's two First Baptists. The separate
historical posts require their own sourcing. No final church headline is certified
by a successful pipeline run.
