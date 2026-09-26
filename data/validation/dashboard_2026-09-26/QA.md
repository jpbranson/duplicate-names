# Static explorer QA — September 26, 2026

Local build, not deployed and not a certified dataset. No cloud spend.

Passed:
- Nineteen focused JS import/count/export assertions (`tests.log`).
- Independent JSON/gzip validation of every payload bucket at both L2 and L3:
  52,847 museum canonical rows (52,425 eligible) and 540,778 church canonical
  rows (442,834 eligible). Unique IDs, numeric coordinates, boolean scope,
  aliases, index/group totals and 51 Census outlines agree with the manifest.
  No OSM rows. See `serialized_payload_checks.json` and payload checksums.
- Browser collection switching, search and selection: Depot Museum 10; Old Jail
  Museum L2 8 with four verified/four pending; First Baptist Church L3 7,010.
- Old Jail L3/all-record view shows 16 rows including two holds; defaults keep
  known chains separate and unknown affiliation explicit.
- A Hayesville popup exposes Clay County Historical & Arts Museum as a source
  alias, preserves pending/unknown review and source coordinates.
- Local fictional-parks CSV import: three rows, two matching North Park names;
  aliases displayed; all imported records marked unverified. No network upload.
- Desktop and 390x844 phone layout: no document horizontal overflow; map controls,
  selected counts and table container remain usable. No explorer console errors.
- CSV generation and persistent Save prepared CSV link show the correct selected
  count, with aliases/review included. Spreadsheet-safe serialization is unit-tested.

Unverified / blocked:
- The IAB browser automation timed out twice waiting for a saved blob CSV download,
  including its dedicated file-link download API. A visible prepared link remains
  available; no claim is made that a filesystem download was confirmed. A normal
  browser/manual save check remains on the human review list.
- Public hosting and actual blog integration: destination is missing. No deployment.
- Museum/church factual and independent-label gates remain incomplete; UI tests
  do not satisfy them. Other categories are supported through local CSV input;
  the fictional example is not an acquired third-category research dataset.
