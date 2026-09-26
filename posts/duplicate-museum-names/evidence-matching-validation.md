# Matching validation used by this draft

The authoritative museum sample contains 300 independent human labels collected on
September 15, 2026: 127 same-institution pairs and 173 different-institution pairs.
The sample deliberately contains 60 pairs from each of five name-similarity bands,
all within 150 metres. The original labels are unchanged.

| Threshold 0.85 | Human: same | Human: different |
|---|---:|---:|
| Algorithm merges | 119 | 1 |
| Algorithm keeps separate | 8 | 172 |

Precision is 119/120 = 99.17%; recall is 119/127 = 93.70%; sample error is 9/300 = 3%.
These pooled, unweighted figures describe this selected sample. They do not estimate
the error rate among all US museums, include missed matches outside the radius,
validate transitive final clusters, or validate multi-site moves. The same sample
was used to select the threshold, rather than a separate held-out evaluation.

The nine original disagreements remain in the archive and are not relabelled by
assistant source research. Changes to matching rules would require fresh independent
labels before claiming improvement. The museum sample does not validate churches.

[Download the unchanged labels](resolution_labelling_2026-09-15.csv).
SHA-256: `ef36a81cfe3d0c413b7cfb2c0641f318e7a3d578db731fbe39425c4e0dbfab05`.

This concise bundle note is derived from the repository's authoritative
`data/validation/resolution_validation_2026-09-15.md`; it does not replace that report.
