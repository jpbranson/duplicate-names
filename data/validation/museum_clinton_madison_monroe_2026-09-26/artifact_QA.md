# Local artifact QA — September 26, 2026

The standalone museum draft rendered successfully in isolation (668,153 bytes,
Pandoc 3.11). Its nine-row recent-review table was checked in the browser,
including Clinton 9→0, Madison 9→0 and Monroe 9→3. A screenshot after a timed-out
DOM geometry request confirmed that the table fits the visible narrow viewport;
no exact viewport geometry claim is made. No captured console errors were found.

The explorer build and serialized validation completed. It contains 52,802
museum canonical records, 52,361 eligible, 6,262 aliases and 101 factual reviews
marked verified. Church payloads remain 540,778 records, 442,834 eligible, 4,463
aliases and zero verified reviews. Compressed payloads total 77.2272 MiB.
All serialized L2/L3 bucket, index, ID, count and alias checks and 51 state
outlines passed; all 19 JS assertions passed.

The refreshed browser search and selection of `monroe county historical society`
showed exactly three records (IMLS 8404700484, 8405500216 and 8402900602), all
pending with unknown affiliation. No captured explorer console errors appeared.
The earlier CSV filesystem-save check remains unverified after IAB download
timeouts; it was not retried or claimed complete.

Both drafts and the explorer remain unpublished. Factual, independent-label and
publication-destination blockers remain open. Cloud resource spending: USD 0.
