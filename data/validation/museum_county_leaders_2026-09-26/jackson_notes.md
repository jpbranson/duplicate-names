# Jackson County source review — in progress

Research date 2026-09-26 UTC. The supported Jackson sub-batch is now applied and
validated: 231 test assertions, 23 integrity checks. The table preserves research
findings; `jackson_applied_*_decisions.csv` record actual decisions. Research is factual
source checking, not independent matching labels. `jackson_sources.json` and shared
`cache_status.csv` record sources and acquisition limits. Current IRS Iowa input was
already acquired for Greene; its EIN, SORT_NAME, GROUP and AFFILIATION fields distinguish
the county society's subordinate organizations. Do not merge them on legal name alone.

| Starting location | Evidence and intended disposition |
|---|---|
| Newport AR, IMLS 8400500285 | Operator `jacksonhistory.net/jchs-history/` identifies a preservation/publication society that transferred its museum building to the state and donated most collections after the 1997 tornado. State Parks' courthouse history corroborates 1965 transfer. Exclude the society support record as not_museum, retain Jacksonport's separately operated museum. IMLS jchdonline.org is not corroborating evidence. |
| Holton KS, 8402000064 | Operator Google Site identifies Roebke House at 216 New York and county museum at 327 New York, plus a research house at 208. IMLS mailing 2116 New York is discrepant. Do not attach the generic society record to one of two museums without evidence; pending. |
| Murphysboro IL, cacd25a7-8dfa-4a6c-a113-10f6d18e6fbf + 8401700373 | Already one baseline entity at 1616 Edith Street. Operator about/history pages explicitly document changing exhibits, museum collections and elected volunteer board. Supports verified independent museum review under its society name. |
| Lakefield MN, b4ee8d7b-3852-4d1d-aff7-f42ee258febf + 8402700338 | Operator matches 307 North Highway 86/507-662-5505 and museum history. Merge displaced IMLS society row into the museum-named Overture record. Own board confirmed; county audit describes legally separate, fiscally dependent component unit with one county appointee. Keep affiliation pending until that relationship and current name wording are fully reviewed. |
| Jackson MI, 8402600479 | Current myjacksonhistorical.org describes a society founded in 2020, after the IMLS snapshot. It cannot establish the older EIN 381861466 organization's fate. Pending; no exclusion inferred from a successor-looking website. |
| Commerce GA, 8401300277 | County archives and library document society preservation/library support. Historical sources describe exhibits with Crawford Long Museum, but current scope is unresolved. Pending, no unsupported merge or exclusion. |
| Independence MO, 3dd7d9f9-6688-44d7-a4ce-210205555063 + 8402900687 + c4d698e3-5e35-45c6-a955-46e6af9bfca3 + 8402900125 | Overture society row is at jail 217 North Main; IMLS society row at 112 West Lexington belongs to History Center in courthouse, with rotating exhibits. Existing society cluster must split while two jail-labelled rows consolidate. Preserve two visitor institutions. Requires guarded split support in correction layer; preferred History Center name and shared-operator affiliation remain pending. |
| Altus OK, 8404000398 | State audit distinguishes the society and local museum organizations but does not resolve source 20485 E County Road 168. Pending; no unsupported exclusion. |
| Maquoketa IA, 8401900280 | IRS EIN 320335904 / PO Box 1065 is Jackson County Genealogical Library. County recorder genealogy page distinguishes this research chapter from historical museum at 1212 E Quarry. Supports not_museum for library-only record, without merging into parent museum. |
| Spragueville IA, 8401900706 | EIN 870791319 / 127 East Main. Current role and preferred chapter name unresolved. Absence from current IRS file is not an exclusion reason. |
| Baldwin IA, 8401900708 | IRS EIN 900885953 / PO Box 91 identifies Baldwin Society. IMLS mixes that with 1212 E Quarry and jciahs.com, belonging to Maquoketa museum (parent EIN 420984105, confirmed foundation profile/county directory). Isolate mixed source row as uncounted source_conflict; do not donate its aliases to Maquoketa or infer Baldwin has no museum. |

The public jciahs.com page includes unrelated commercial text and native download failed
certificate validation. No TLS bypass. County government and the foundation's nonprofit
profile provide corroborating museum evidence; do not use the compromised-looking page
as sole authority. County genealogy page web retrieval failed; bounded native cache is
unsuccessful, but the government's `jackson.county.iowa.sites.gmdsolutions.net` hosting
URL was readable and cached. Explicit source access limits are retained.
