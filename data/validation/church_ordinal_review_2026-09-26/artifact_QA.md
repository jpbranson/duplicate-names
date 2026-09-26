# Church checkpoint artifact QA

browser_verified: yes

The isolated church render passed. Browser inspection confirms the unpublished
notice, the Alexandria/Miami Christian-scope exclusions, the Seventh/Eighth Day
explanation, preserved outer First, and the distinction between Tenth Presbyterian
and Tenth Memorial. The revised section is legible at the browser's normal width;
the inline map loads and reports the unchanged 7,010 provisional sites.

Both dashboard datasets pass all four serialized L2/L3 checks and the 51-state
check. Payload size is 77.224959 MiB. Church metadata has 540,778 records / 442,832
eligible / 4,463 aliases / zero verified; museum metadata remains unchanged.
Browser all-records search shows the Alexandria record as pending with the sourced
scope-hold reason; eligible-only search excludes it. Clearing scope resets the table
caption to No records selected. Browser error log is empty.

The first map-CSV check failed because of a one-ULP read-round-trip discrepancy:
maximum longitude difference 1.421085e-14 and latitude 7.105427e-15 degrees. The
before/current analysis source coordinates passed bitwise equality, and all 7,010
map IDs are identical. Initial failure output is preserved. The repaired CSV check
uses a strict 1e-12-degree serialization bound; source-coordinate checks stay exact.

Browser QA reproduced a loading race: a scope change during an index fetch
invalidated that fetch and left the collection empty. The fix retains the pending
index and applies the latest scope after load, ignores stale index failures, and
resets the table caption when clearing details. Seven new asynchronous assertions
and all 19 data/import/export assertions pass. The original loading failure and
successful browser retest are documented in the flight log. Versioned app script
20260926-church-scope2 ensures the current code loads. A label-based automation
selector initially found no matches; the observed element IDs worked.
The prior browser CSV download-event timeout is still unresolved: actual filesystem
saving is not claimed here. No retry or workaround for the earlier automatic
approval rejection of the draft-tab deliverable marker was attempted. Both drafts
remain unpublished, with no national headline or project completion certified.
