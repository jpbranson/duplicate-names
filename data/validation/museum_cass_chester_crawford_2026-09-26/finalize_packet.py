"""Write checkpoint documentation only after the selective build passes."""
import csv,json,subprocess,sys,re
from pathlib import Path
p=Path(__file__).parent
checks=list(csv.DictReader((p/'integrity_checks.csv').open()))
assert len(checks)==25 and all(r['passed']=='TRUE' for r in checks)
c=next(csv.DictReader((p/'counts.csv').open()))
assert c['counted_institutions']=='52466' and c['eligible']=='52334'
log=(p/'build_validate.log').read_text(errors='replace')
assert '25 integrity checks passed; 1097 earlier files unchanged.' in log
subprocess.run([sys.executable,str(p/'export_human_review.py')],check=True)
report='''# Cass, Chester and Crawford source review — September 26, 2026

The 24 starting candidates in three eight-member L2 groups have sourced
dispositions. Supported corrections are applied and validated. Twelve factual
reviews remain incomplete; no national M1 or M2 winner is certified.

## Validated checkpoint

| Measure | Before | After |
|---|---:|---:|
| Original source rows | 60,002 | 60,002 |
| Counted source rows | 57,191 | 57,171 |
| Counted institutions | 52,480 | 52,466 |
| Eligible institutions | 52,348 | 52,334 |
| Identity rows / cases | 258 / 106 | 292 / 121 |
| Complete factual reviews, including exclusions | 110 | 123 |
| `not_museum` decisions | 21 | 22 |
| Preferred names | 57 | 69 |
| Isolated source conflicts | 23 | 28 |

All 340 test assertions and 25 integrity checks pass. All 1,097 earlier protected
evidence and human-label files remain unchanged. The automatic baseline, baseline
multi-site queue, normalized source fields, source coordinates, previous decisions
and 0.85 matching threshold are preserved. These source reviews are not independent
matching-accuracy labels.

| L2 name, non-chain institutions | Before | After | Remaining scope |
|---|---:|---:|---|
| Cass County Historical Society | 8 | 0 | Current public names, reconciled duplicates, two affiliated Indiana museums and one isolated conflict |
| Chester Historical Society | 8 | 3 | New Hampshire verified; Vermont and New Jersey pending |
| Crawford County Historical Society | 8 | 3 | Iowa, Wisconsin and Georgia pending |

Other pending reviews carry fuller public names or isolated conflict identities.
Zero for the Cass bare-name group does not mean no Cass museums exist. The batch
adds 34 identity memberships in 15 cases, 25 factual decisions and 12 preferred
names. Twelve museum reviews and one affirmative archive exclusion are complete.

## Supported decisions

- **Cass, Iowa and Minnesota:** Reconcile each society/museum pair and use its
  public name: Cass County Historical Museum in Griswold and Cass County Museum
  in Walker. Source addresses, phones, mailing contacts and operator governance
  support each institution. Griswold's 410/412 street variation and conflicting
  weekly hours still need a publication entrance/access check.
  [Griswold history](https://www.casscoiowamuseum.com/our-history),
  [Walker operator](https://casscountymuseum.org/).
- **Cass, Missouri and Illinois:** Three Harrisonville museum/archive/society
  records describe one Burnt District Museum campus; the cabin is on the same
  grounds. Virginia's society has museum exhibits and keeps its fuller Historical
  & Genealogical Society name. Research functions do not justify excluding a
  documented museum. [Harrisonville city](https://ci.harrisonville.mo.us/793/Burnt-District-Museum),
  [Virginia operator](https://www.casschgs.org/about-our-society).
- **Cass, Indiana:** Long Home Museum and Cass County Museum/Castaldi Family
  History Center are two named institutions at Market and Broadway. Consolidate
  duplicate Long Home records, retain both museums, and record their common
  historical-society affiliation. [Operator](https://www.casscountyhistory.org/).
- **Chester, Connecticut and New York:** Three Connecticut rows reconcile to
  Chester Museum at The Mill. Orange County's 1915 Erie Station and society
  mailing record reconcile, while the mixed Chestertown/Warren County IMLS row
  stays isolated. [Connecticut museum](https://chesterhistoricalsociety.org/history),
  [Erie Station](https://www.chesterhistoricalsociety.com/about-us/),
  [Chestertown](https://www.chesterhistory.com/about).
- **Chester, Vermont and New Hampshire:** Reconcile the address-matched pairs.
  Vermont's current museum/site and governance review remains pending. New
  Hampshire's municipal community page documents public exhibits, membership
  and officers at Stevens Memorial Hall. Its obsolete operator domain now
  carries gambling content and is not used as current evidence.
  [Vermont town](https://www.chestervt.gov/chester-historic-preservation-committee.html),
  [New Hampshire town](https://www.chesternh.org/1602/Chester-Historical-Society).
- **Crawford, Missouri and Illinois:** Reconcile each clean museum pair and use
  Crawford County Historical Society Museum. Cuba's governance remains pending
  because the legacy domain contains unrelated spam. Illinois's state directory
  explicitly joins Robinson PO Box 554 with 408 South Cross. The contradictory
  IMLS row uses the Palestine Preservation Society EIN and PO Box 87 and stays
  isolated. IRS exemption group 9411 links the two legal records fiscally but
  does not alone establish common museum operation.
  [Missouri tourism](https://www.visitmo.com/things-to-do/crawford-county-historical-society-museum-2),
  [Illinois museum directory](https://icpn.museum.state.il.us/sites/icpn/files/attachments/ICPN_table_pages_of_Illinois_Museums_NO-contacts%26no_websites.pdf),
  [Robinson chamber](https://www.robinsonchamber.com/visitor-information).
- **Crawford, Michigan:** The operator's 97 East Michigan/PO Box 218 contacts
  reconcile the society and museum. A society treasurer letter, visually checked
  on page 29 of the December 2023 county packet, documents its board managing
  museum work. Current operator hours supersede stale search excerpts.
  [Operator](https://crawfordcountyhistoricalsociety.com/),
  [County packet](https://www.crawfordco.org/wp-content/uploads/2023/12/Board-Packet-12142023-B.pdf).
- **Crawford, Pennsylvania:** Exclude the generic administrative/archive record
  from the museum count on affirmative operator role evidence. Preserve Mount
  Hope: The Baldwin-Reynolds House Museum and Johnson-Shaw Stereoscopic Museum
  as separate institutions with a common operator. Reconcile their clean
  duplicate rows. Isolate the Baldwin IMLS row with Meadville Public Library
  EIN 250990592 and library mailing address; no disputed aliases are transferred.
  [Operator locations](https://crawfordhistorical.org/about/contact/),
  [Archive roles](https://crawfordhistorical.org/research/research-archives/),
  [Johnson-Shaw](https://crawfordhistorical.org/johnson-shaw-stereoscopic-museum/).

Five new conflicts are isolated: Cass Michigan (society versus municipal museum),
Chester New York (Orange County versus Chestertown), Crawford Arkansas (historical
society versus genealogy library), Crawford Illinois (Robinson versus Palestine),
and Crawford Pennsylvania (museum versus library). These are source-field
contradictions, not exclusions inferred from failed searches or mailboxes.

## Explicit primary-site correction

The first dry run rejected Baldwin-Reynolds' documented Terrace visitor-site row
because the automatic baseline had excluded it as a secondary site. Added the
explicit `reselected_canonical` role: it accepts only a source excluded as
`non_primary_site`, with an accepted counted member of the same baseline
institution. It cannot reopen a closed/nameless row, revive an entirely excluded
institution, or use a conflicting row as its counted support. Full membership,
evidence, name, entity and coordinate guards remain mandatory. The source-level
audit preserves the original and corrected counting flags, and the automatic
baseline remains unchanged. Eighteen new regression assertions cover the behavior
and rejected cases; all 85 identity assertions pass. This correction selects an
existing source point; it does not certify a visitor entrance or alter coordinates.

A subsequent dry run rejected the draft status spelling `affiliated`; it was
corrected to the existing `chain` status. Validation was not weakened. Both failed
dry runs left live decision inputs unchanged; the corrected dry run and one-time
application passed exact count and protected-file guards.

## Incomplete work and evidence limitations

The [twelve-item human-review queue](museum_cass_chester_crawford_2026-09-26/human_review.csv)
records concrete gaps and next actions. It includes five source conflicts, Vermont
and New Jersey museum scope, Iowa address history, Wisconsin/Hauge Center scope,
Georgia's dated site/move information, Cuba governance, and Robinson/Palestine
operating relationships. Independent church labels and publication destinations
are still missing. No outreach has been authorized or sent.

There were 68 bounded public acquisition attempts: 61 successful caches and seven
failures (four HTTP 404, one 403, two TLS validation failures). Raw bytes, manifest
hashes, extracted documents and selected IRS rows preserve provenance. The
gambling-contaminated old domains were treated as untrusted; no linked gambling
sites were visited. No authentication or certificate checks were bypassed.

The 29-page Michigan packet is scanned. Poppler rendered it for inspection; page
29 is saved in this packet. Illinois directory page 14 was visually checked to
distinguish mailing and actual-site columns; page 9 identifies Virginia and page
21 identifies Fife Opera House in the extracted table. CSV IRS input was handled
as structured data. Poppler emitted missing-font notices for the table but its
saved image was legible. The initial copied exploratory regex selected the wrong
related-name context; its outputs were preserved, and a one-time context-only
correction produced the 234 relevant rows. Candidate/baseline snapshots were
unaffected.

## Resume and artifacts

The packet holds all 24 dispositions, 234 related baseline rows, 111 pinned-release
Overture context rows, before/after audit and ranking files, guarded proposals,
application marker, tests, checks and remaining actions. `applied.json` is the
one-time completion marker: never rerun `prepare.R`, `correct_context.R` or
`apply.R --apply`. `build_validate.R --verify-only` is read-only while this remains
the live checkpoint; later batches make its fixed-count checks historical.

Continue Jefferson and Lincoln County Historical Society (eight candidates each),
then Madison Historical Society, Marion County Historical Society and Milton
Historical Society, plus earlier unresolved/M2 queues. Museum draft/explorer
payloads still show the older Clinton/Madison/Monroe checkpoint and need a later
refresh; they are not presented as current. Final headline, map/access, blog
publication, church validation and deployment work remain incomplete. The national
leader fails the explicit recorded-status publication gate. Cloud spending is
USD 0, strictly below USD 5.
'''
Path(str(p)+'.md').write_text(report,encoding='utf-8')
print('Validated checkpoint report written.')
