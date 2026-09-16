# Museum source verification — first pass

**Subsequent update:** the [identity-reconciliation pass](museum_identity_review_2026-09-15.md)
applies nine sourced corrections. It also resolves the electronics museum's Middle River
record using the operator's relocation announcement. The later
[focused follow-up](museum_focused_review_2026-09-15.md) records the latest counts,
Pennsylvania source-conflict holds and remaining location checks. Counts below retain
this earlier checkpoint; the corresponding dated packet is unchanged.

**2026-09-15.** Checked **51 source records across 46 existing entity IDs**, recorded
official-source evidence and applied 24 explicit naming/affiliation decisions. This
completes the first source-verification pass, not the full top-20 publication review.

The [evidence ledger](museum_source_review_2026-09-15/evidence.csv) separates source
facts, interpretations, applied actions and outstanding identity questions. It retains
source IDs, coordinates, IMLS campus/address context, URLs, retrieval method and date.
The [case index](museum_source_review_2026-09-15/case_index.csv) groups the records into
nine cases. These are assistant source checks, not independent human matching labels.

## Applied decisions and count effects

| Measure | Before this pass | After |
|---|---:|---:|
| Baseline counted entities | 52,636 | 52,636 |
| Eligible for provisional name analysis | 52,497 | 52,501 |
| Category-only names confirmed as current names | 1 | 5 |
| Explicit historical-name holdouts | 0 | 4 |
| Category decisions still pending | 139 | 131 |
| MOI global-network affiliations in the 13-name group | 0 | 11 |

The tracked input is [museum_decisions.csv](museum_decisions.csv). The packet preserves
both [previous decisions](museum_source_review_2026-09-15/decisions_before.csv) and
[applied decisions](museum_source_review_2026-09-15/applied_decisions.csv), plus
[analysis rows after this pass](museum_source_review_2026-09-15/analysis_after.csv).
No entity IDs, site IDs, baseline exclusions, source names or matching thresholds changed.
All 24 decisions remain `review_status = pending`: a confirmed name or affiliation is
only one part of the complete factual identity/count review.

The top-20 ranking, including its cutoff tie, is unchanged. Washington County Historical
Society still leads with **19 provisional entities**; this is not a verified count of
distinct current museums. The [updated ranking](museum_source_review_2026-09-15/ranking_after.csv)
now shows 11 affiliated and two unknown Museum of Illusions candidates.

## University Art Gallery: all 13 records checked

Five universities explicitly use the name: [Cal Poly](https://cla.calpoly.edu/university-art-gallery),
[CSU East Bay](https://www.csueastbay.edu/artgallery/),
[CSU Stanislaus](https://www.csustan.edu/art-galleries/university-art-gallery),
[Sonoma State](https://artgallery.sonoma.edu/) and
[Union University](https://www.uu.edu/academics/departments/art/).
Cal Poly was already released; the other four are new releases. This confirms naming,
not campus coordinates, cluster correctness or independence from every other institution.

Four former names now receive `historical_name`, an explicit analysis holdout:

- **Baylor:** the university documents consolidation of the gallery and Martin Museum
  space in 2005; its current venue is Martin Museum of Art. The former-name treatment
  follows that institutional history. [Baylor history](https://magazine.web.baylor.edu/news/story/2006/art-angels),
  [current museum](https://martinmuseum.artsandsciences.baylor.edu/).
- **New Mexico State:** University Art Museum traces its history to University Art
  Gallery. [Museum history](https://uam.nmsu.edu/permanent-collection/about-the-colletion.html).
- **Stony Brook:** the institution dates the University Art Gallery name to 1988–2013,
  followed by Paul W. Zuccaire Gallery. [Gallery history](https://zuccairegallery.stonybrook.edu/about/).
- **UC San Diego:** the gallery explicitly documents its former name and current
  Mandeville name. [Gallery history](https://mandevilleartgallery.ucsd.edu/about/history.html).

Eastern Michigan, Elizabeth City State, Oklahoma Christian and UMass Dartmouth remain
pending. The first three need exact-name or record-location reconciliation. UMass places
the old University Art Gallery in its **Star Store archive**; the historical exhibition
address is in New Bedford, whereas IMLS uses the Dartmouth campus address. The archived
and current campus galleries should not be equated automatically.
[Current UMass gallery directory](https://www.umassd.edu/cvpa/galleries/),
[historical exhibition address](https://www.umassd.edu/cvpa/universityartgallery/exhibitions/2019/2019-mfa-thesis-exhibition-.html).

## Museum of Illusions: affiliation established for 11 locations

The official global-network directory lists San Diego, Santa Monica, Scottsdale,
Kansas City, Denver, Mall of America, Detroit, Charlotte, Pittsburgh, Washington DC
and Philadelphia. Each record is within **26 m** of the coordinate in that location's
outbound map link. The decisions establish **brand affiliation**, not common legal
ownership. [Official network directory](https://www.museumofillusions.com/our-locations/).

Hollywood's operator presents Museum of Illusions as an attraction within WonderWalk
at 6751 Hollywood Boulevard. Its broader affiliation and the attraction-versus-parent
counting unit remain open. [Operator visit page](https://illusions-la.com/plan-your-visit/).
Miami's indexed operator page reports a closure and refers to California locations,
but direct retrieval timed out. That limited excerpt is retained as a lead, without
assigning permanent closure or ownership. [Miami operator page](https://miaillusions.com/).

## Identity cases prepared for the next pass

| Case | Evidence and next action |
|---|---|
| National Electronics Museum: four entities | Official history documents relocation; the current visitor page suspends public access at Hunt Valley pending further notice. Reconcile the former Linthicum record, PO box and discrepant Baltimore-area point. A 2024 reopening announcement is insufficient evidence of present access. |
| National Vietnam War Museum: five exact-name entities, plus one Smedley alias | The Texas official map agrees with one Overture record within 3.9 m. IMLS has the same street address but a coordinate 6.9 km away; two other Overture points are 2.5 and 26.5 km away. Investigate those points before merging. The Florida IMLS legal name/address identifies the Smedley institution, whose fuller name appears in another POI. |
| Washington County societies: Arkansas, Florida, Georgia and Pennsylvania | Eight leading-name entity candidates plus the Georgia Old Jail entity have source dossiers. Resolve mailing/stale addresses and museum-specific aliases. Georgia's society operates three named museums, so common ownership cannot justify collapsing all sites into one museum. Eleven other leading-name entities remain outside this pass. |

Sources: [Electronics visitor status](https://www.nationalelectronicsmuseum.org/visitor-info/hours-admission/),
[Electronics history](https://www.nationalelectronicsmuseum.org/about-us/history-mission/),
[Texas address and map](https://www.nationalvnwarmuseum.org/contact-map-1),
[Smedley operator](https://www.smedleymuseum.com/),
[Florida address](https://theoriginalbunker.wixsite.com/orlando/contact),
[Arkansas properties](https://washcohistoricalsociety.org/Properties),
[Florida county museum listing](https://visitwcfla.com/businesses/details/washington-county-historical-society/),
[Georgia museums](https://wacohistorical.org/visit-us/),
[Georgia Old Jail](https://wacohistorical.org/genealogy/),
[Pennsylvania LeMoyne House](https://wchspa.org/lemoyne-houses/).

The **Cryptozoology seed location check is complete**: the selected Bangor point is
5.9 m from the destination in the operator's 490 Broadway map link. The operator also
identifies the former Thompson's Point and Hammond Street addresses as closed.
The three existing Portland source rows remain excluded by the existing site policy.
[Official visit page](https://cryptozoologymuseum.com/plan-your-visit/).

Distances use `sf`/s2 against coordinates in official-page links. The destination map
pages did not load; these are checks against operator-supplied map destinations, not
field surveys or independent geocoding validation. Undated visitor pages describe their
retrieved state and do not establish when that state began.

## Validation and next step

R 4.4.2: **108 assertions passed**, zero test failures, warnings or skips. The selective
pipeline rebuild completed nine targets. Audit checks confirmed the counts above,
unchanged entity/site assignments and baseline flags, byte-identical archived and
working human labels, and blank generated diagnostic labels. The 0.85 scoring result
remains 119 true merges, one false merge, eight missed merges and 172 true separations.
Windows locale warnings occurred at R startup; they were separate from the test results.

Only `labelling_sheet` remains outdated, deliberately left untouched to preserve the
completed working labels. [Checksums](museum_source_review_2026-09-15/input_checksums.csv)
record the code, inputs, labels and packet artifacts used for this checkpoint. The
earlier review packet is preserved separately.

Next, use these dossiers to implement supported, auditable identity/name corrections
and finish source checks for the remaining top-20 groups. The unresolved cases above
are research tasks, not a request for the user to label the full 470-row packet.
Any new claim about matching accuracy still requires fresh independent human labels.
Figures and the standalone post follow completed headline checks.
