# County leaders research notebook — in progress

Research date: 2026-09-26 UTC / 2026-09-25 America/Chicago.
These are factual research notes, not independent matching labels. The Franklin
sub-batch was applied and validated at 01:28 UTC: see `apply_franklin.R`, its applied
decision CSVs, `franklin_validation.log` and `franklin_integrity_checks.csv` for final
dispositions. The table below preserves research leads, not the final decision state.
Further proposed memberships must be checked against complete baseline clusters.

## Franklin County starting group (11 institutions)

| Place | Evidence read | Provisional disposition / next check |
|---|---|---|
| Chambersburg PA | [Operator home](https://www.franklinhistorical.org/), [governance](https://www.franklinhistorical.org/about), [visits](https://www.franklinhistorical.org/visit): society headquartered at Old Jail, 175 E King; its own nonprofit board; Old Jail and John Brown House have separate tours | Merge society Overture 73e263dc-870a-405b-9005-b0075cece747 and IMLS 8404201394 with The Old Jail 0d75bfd8-a6a7-4bcd-b4b8-fa824929726f if source context agrees. Keep John Brown House separate. Operator has dated September/November 2026 access and October closure wording. |
| Winchester TN | [Society](https://www.franklincountytnhistory.com/) identifies nonprofit, PO Box 130 and library history room. [Historic NPS nomination](https://npgallery.nps.gov/GetAsset/5efd6520-f17a-44c1-831b-49263b437a32) describes historical society operating Old Jail | Historic relationship is insufficient to merge a current society mailing row into the already reconciled museum. Check current operator, EIN and earlier Old Jail evidence. |
| Lavonia GA | [Georgia corporation record](https://ecorp.sos.ga.gov/BusinessSearch/BusinessInformation?businessId=8984&businessType=Domestic+Nonprofit+Corporation&fromSearch=True) matches 255 North Fork Rd and active 2026 registration; [Chamber](https://www.franklin-county.com/business-directory.php) lists society | Existence confirmed, museum scope unresolved. Related Overture record 80d3de55-6615-4df8-84cb-f3fc513fe691 near Carnesville needs address/site reconciliation. No exclusion based on office address alone. |
| Brookville IN | [County tourism walking tour](https://franklincountyin.com/wp-content/uploads/2019/03/Brookville-Historic-Tour-2016.pdf) and [state nomination](https://secure.in.gov/apps/dnr/shaard/r/25b67/N/Franklin_CO_Seminary_Nom.pdf) identify society-owned Seminary Museum at 412 Fifth St. [Library](https://fclibraries.org/in-search-of/) references collection; state historical society directory links former operator site | IMLS 8401800641 uses 826 Main St mailing address. No Seminary museum source row found in immediate baseline neighborhood. Need current naming/access and link to mailing record. Operator Welcome.html fetch failed; no inferred closure. |
| Louisburg NC | [Louisburg College restoration report](https://www.louisburg.edu/_resources/tar-river-center/pdfs-files/Jail-Stabilization.pdf), dated 2018, says society formerly used jail as museum; [county 2013 minutes](https://www.franklincountync.gov/Archive/ViewFile/Item/1947) discuss whistling museum | Current institution/museum/address unresolved. IMLS 8403700497 remains pending. Ignore generic museum-directory prose as confirmation. |
| Rocky Mount VA (two) | [Operator](https://franklincountyvahistoricalsociety.org/) gives 460 S Main St and PO Box 905, nonprofit history museum and library. [County tourism](https://visitfranklincountyva.com/27/Things-to-Do) names History Museum & Research Library | Proposed canonical 10e7fc9e-03f9-4f19-9721-866275411ebb with IMLS 8405100628; displaced society Overture 9fd03a7f-b35a-4ad9-a00a-b04f20cead24 needs context. Operator access text dates to 2022; do not present as freshly confirmed hours. |
| Columbus OH | [COSI history](https://cosi.org/about-cosi/history-of-cosi) establishes society origins/current 333 W Broad; [city ordinance](https://columbus.legistar.com/LegislationDetail.aspx?GUID=A80F490B-CA43-46F6-ADA6-51FB614C78FF&ID=4694386&Options=&Search=) identifies FCHS dba COSI, EIN 31-4383802, same address | Society IMLS 8403900842 belongs with COSI. Two Overture COSI rows, IMLS 8403900675 (different EIN), Dinosaur Gallery sub-attraction require context. Do not merge unrelated Columbus Historical Society or Franklin County Genealogical & Historical Society. |
| Ottawa KS (two) | [Operator](https://olddepotmuseum.org/), [museum](https://olddepotmuseum.org/historical-sites/old-depot-museum/), [governance](https://olddepotmuseum.org/about/trustees-staff/) identify Old Depot Museum and separate archives/research center, Dietrich Cabin | IMLS society PO Box 145 and Overture society point must be mapped to correct function. Do not collapse separately named museum and cabin merely because they share an operator. |
| Hampton IA | [Operator museum page](https://fchsiowa.org/historical-museum) identifies Franklin County Historical Museum, appointment access, 1000 Central Ave W / PO Box 114 matching IMLS 8401900675 | Museum exists, naming differs from raw society name. Related museums/grounds elsewhere need checking; no correction yet. |

## Runtime / acquisition

- Snapshot `prepare.R` completed: 33 candidates, 611 related baseline records,
  before-state RDS, decisions/audit/manifest copies and protected-file SHA-256s.
- `Rscript` 4.4.2 requires session-local `RENV_PATHS_ROOT` in writable workspace.
  Set `RENV_PATHS_SANDBOX` there too to avoid attempts to write the user's cache.
- Several web click calls returned internal errors; direct URL opens work.
- `acquire_context.R` completed a public anonymous pinned-release Overture query:
  296 contextual records saved. No paid service provisioned.
