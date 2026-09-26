# Artifact refresh QA — Veterans/Carroll, September 26, 2026

The isolated museum render passed: 667,028-byte self-contained HTML, Pandoc 3.11, no analysis checkout used by knitting. The browser visibly shows the six added table rows with current counts 2, 1, 4, 4, 3, 1, and the revised Georgia/Missouri explanation. Observed viewport width 518, document width 503 and table width 471: no horizontal overflow at that tested size. Existing chart labels/alt text are retained; no new claim of a 390-pixel test is made.

Explorer data rebuilt at 14:14:17 UTC. Museums: 52,805 canonical records, 52,374 eligible, 6,253 with aliases, 85 factual reviews marked verified. Churches unchanged: 540,778 canonical records, 442,834 eligible and no independent factual-review certifications. All serialized L2/L3 name buckets, counts, aliases and 51 state outlines pass validation. Nineteen focused JS assertions pass. Payloads occupy 77.226 MiB compressed; no remote tiles or paid compute.

After reload, the browser shows the Veterans Memorial Museum group at three and loads exactly three institutions: verified independent Chehalis and Laurel, plus pending/unknown Johnstown. This confirms updated index and payload versions agree. Museum draft and explorer report no captured console errors. Local museum/church drafts and explorer remain marked as deliverables.

CSV filesystem saving remains unverified after the earlier IAB download timeouts; those attempts were not repeated without a new fix. Earlier broader filter/map/import QA remains dated evidence. No public deployment or blog-theme integration is claimed. Cloud spending USD0.
