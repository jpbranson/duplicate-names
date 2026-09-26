# Church draft browser QA — September 26, 2026

Passed: isolated bundle render, two accessible figures, current C2 table, desktop
and 390x844 phone post layout without document overflow, standalone MapLibre map,
7,010-site count and pending-review notice, sources, region buttons including Hawaii,
and embedded iframe interaction. Final console checks show no errors. PNG fallback
and map CSV are present. Full publication and actual blog/theme integration remain
incomplete. The post frontmatter is still draft: true.

Issues found and fixed: Unicode alias truncation in mapgl GeoJSON on Windows
(display HTML entities preserve the visible Unicode); empty style sources serialized
as an array instead of an object; a second add_control overwriting the first;
mobile table overflow; and Pandoc embedding the whole iframe as a data URI. The
iframe now uses data-external=1 and keeps the local self-contained map resource,
per https://pandoc.org/MANUAL.html#options-affecting-specific-writers. This is a
self-sufficient folder bundle, not a single-file post.

A successful render did not prove interactive behavior: these defects were caught
by browser checks. Render logs and JSON diagnostics retain the failed attempts.
No matching or classifier truth labels were supplied or invented during QA.
