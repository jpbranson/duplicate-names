# One-time sourced Depot corrections after the Wayne sub-batch.
for (f in list.files('R', pattern = '[.]R$', full.names = TRUE)) source(f)
p <- 'data/validation/museum_next_leaders_2026-09-26'
stopifnot(!file.exists(file.path(p, 'depot_identity_after.csv')))
baseline <- targets::tar_read(entities)
ids <- dn_read_museum_review('data/validation/museum_identity_decisions.csv', dn_schema_museum_identity_decisions())
decisions <- dn_read_museum_review('data/validation/museum_decisions.csv', dn_schema_museum_decisions())
overrides <- dn_read_museum_review('data/validation/museum_name_overrides.csv', dn_schema_museum_name_overrides())
rules <- targets::tar_read(museum_chain_rules)
gazetteer <- targets::tar_read(gazetteer)
stopifnot(identical(ids, dn_read_museum_review(file.path(p, 'wayne_identity_after.csv'), dn_schema_museum_identity_decisions())),
  identical(decisions, dn_read_museum_review(file.path(p, 'wayne_decisions.csv'), dn_schema_museum_decisions())),
  identical(overrides, dn_read_museum_review(file.path(p, 'wayne_overrides.csv'), dn_schema_museum_name_overrides())))
urls <- function(...) paste(c(...), collapse = ' | ')
e <- list(
  Ironwood = list(url = urls('https://ironwoodchamber.org/business/old-depot-museum/', 'https://ironwoodchamber.org/business/ironwood-depot/', 'https://ironwoodmi.gov/community/live/'),
    note = 'The chamber, which also occupies the depot, and city identify the former Chicago and Northwestern depot as the museum maintained by Ironwood Area Historical Society at 150 North Lowell. Five records of the building, museum and resident society describe one museum. Preserve aliases and use Old Depot Museum, the chamber museum listing title. Current society governance remains pending because the operator sites fail DNS/connection; city building ownership does not by itself resolve operational independence.'),
  Fort_Payne = list(url = urls('https://www.fortpaynedepotmuseum.com/', 'https://fortpayne.org/community/museums/the-depot-museum/', 'https://encyclopediaofalabama.org/article/fort-payne-depot-museum/'),
    note = 'Current museum operator gives 105 Fifth Street NE, phone 256-845-5714 and PO Box 681420, matching Overture and both IMLS records, whose shared EIN is 630869280. Count the museum-named Overture row once; IMLS points are displaced. Operator identifies Fort Payne Depot Museum Inc. and its partnership with the city. The museum-authored encyclopedia account describes its own 12-member board. The depot, caboose and rotating-exhibit annex form this institution; no separate annex institution is inferred. Public hours are advertised and require a dated check before visitor export.'),
  Enterprise = list(url = urls('https://peariverhistorical.square.site/', 'https://www.peariver.org/', 'https://www.peariver.org/museum.html'),
    note = 'Current operator website, read in the browser on 2026-09-26, states that the local volunteer nonprofit owns and operates Pea River Museum at the historic depot, as well as a gift shop and research library. The older operator site distinguishes Railroad Street museum from 108 South Main library/shop. Three depot/building records identify one museum, including the Enterprise Train Depot row with the same 106 Railroad address and 334-393-2901 phone. Use current public name Pea River Museum. Local nonprofit ownership and operation are explicit. Do not reuse library/shop hours as museum visitor hours.'),
  Enterprise_library = list(url = urls('https://peariverhistorical.square.site/', 'https://www.peariver.org/', 'https://peariver.org/librarygiftshop.html'),
    note = 'Overture society and IMLS society record identify 108 South Main, the separately described research library and gift shop. Current operator distinguishes these functions from the Pea River Museum in the depot behind them. Exclude this library/shop record as not_museum, while preserving the separate counted museum. This decision rests on affirmative operator descriptions, not the society name or failed search.'),
  Two_Harbors = list(url = urls('https://lakecountyhistoricalsociety.org/', 'https://lakecountyhistoricalsociety.org/duluth-iron-range-depot/', 'https://www.exploreminnesota.com/profile/lake-county-historical-society-dir-railroad-depot-museum/2216'),
    note = 'Operator and state tourism agency identify the D&IR Railroad Depot Museum at 520 South Avenue, phone 218-834-4898. Operator describes the museum in the former Duluth and Iron Range headquarters; four building/society/museum rows, including IMLS physical 520 South and mailing PO Box 128, represent one museum. Retain the other separately named Lake County museums as distinct institutions under the same parent. Irrelevant pharmacy links in the fetched detail-page template were ignored; museum identity is corroborated by the state source and source addresses. Visitor hours differ across pages and need rechecking.'),
  Three_M = list(url = urls('https://lakecountyhistoricalsociety.org/', 'https://lakecountyhistoricalsociety.org/3m-museum/'),
    note = 'Operator explicitly identifies 3M Birthplace Museum inside the original John Dwan Law Office at 203 Waterfront Drive, owned by the society since 1991. Two colocated building/museum records describe one museum. Use the Dwan source as canonical because it supplies the physical street; the 3M source has the parent depot contact address but its museum name, point and dedicated operator URL identify this institution. Keep that discrepancy in the supporting row. Common Lake County Historical Society operator is sourced. The operator says closed for repairs for the 2026 season; this is a temporary access restriction, not institutional closure. No current visitor recommendation.'),
  Oroville = list(url = urls('https://sites.google.com/view/borderlandshistorical/home', 'https://sites.google.com/view/borderlandshistorical/about-us', 'https://sites.google.com/view/borderlandshistorical/about-us/contact-us'),
    note = 'Operator identifies Old Oroville Depot Museum at 1210 Ironwood, matching the Overture address and IMLS physical address. The IMLS point is displaced. Its visitor center and outdoor exhibits belong to the same museum. Count once and retain former society-name alias. Current operator uses Okanogan Borderlands Historical Society; current/old legal name and the plural museum mission need affiliation clarification. Do not merge the nearby mislocated Molson School Museum record merely from proximity.'),
  Stratford = list(url = 'https://texastimetravel.com/directory/sherman-county-depot-museum/',
    note = 'Texas Historical Commission identifies Sherman County Depot Museum at 17 North Main, phone 806-290-3655, matching Overture and IMLS museum row. The automatic IMLS cluster also contains Sherman County Historical Society with a different EIN and only PO Box 1248. Split that uncertain society record from the accepted museum rather than infer institutional identity from the shared displaced point. Count the Overture museum once with its IMLS museum support; retain a separate pending society record until its museum role and relationship are sourced. Current museum governance and access remain pending.'),
  Wakefield = list(url = urls('https://www.wakefieldheritage.org/', 'https://www.wakefieldheritage.org/visit/wakefield-train-depot', 'https://www.wakefieldheritage.org/visit/graves-library-museum'),
    note = 'Operator identifies Wakefield Train Depot at 101 East First and separately operates Graves Library Museum at 206 West Third. These are two distinct museums under Wakefield Heritage Organization, whose EIN is 810633055. Depot source is at the First Street site. Use the operator name for the depot and record shared affiliation. Generic society rows at a differing Third Street direction and old PO box remain pending and are not merged into either visitor site.'),
  Mammoth = list(url = urls('https://www.arkansas.com/state-parks/explore/parks/mammoth-spring-state-park', 'https://www.arkansas.com/sites/default/files/2025-12/MammothSpring_2014_web.pdf', 'https://www.arkansas.com/state-parks/explore/parks/jacksonport-state-park'),
    note = 'State operator identifies the historic Frisco train depot and museum within Mammoth Spring State Park and publishes separate Train Depot Museum hours. The candidate point is the depot, distinct from the welcome center. Arkansas State Parks also operates the Jacksonport courthouse museum; record common state museum operator rather than independence. Use Train Depot Museum, the current operator access-section name. Depot winter closure and weekly access restrictions must accompany any visitor export.'),
  Rusk = list(url = urls('https://www.ruskcountyhistory.org/', 'https://www.ruskcountyhistory.org/about-center', 'https://www.ruskcountyhistory.org/about-commission'),
    note = 'Current operator calls the institution Rusk County Depot Museum & History Center at 514 North High, matching Overture. It is one museum complex with historic structures and Children\'s Discovery Center. The county owns the museum property and artifacts, its historical commission oversees operations, and a separate foundation fundraises. Record independent local county operation and the current public name. The separate commission research center is not silently merged into the museum. Public hours are advertised and require recheck before visitor export.'),
  Arcadia = list(url = urls('https://www.bienvilleparish.org/residents/local-attractions', 'https://www.achp.gov/preserve-america/community/arcadia-louisiana', 'https://www.la2nd.org/wp-content/uploads/2022/09/50564ca.pdf'),
    note = 'Current parish attraction directory calls the site Arcadia Depot Museum and links the local museum page. Federal preservation context identifies the same depot under the older Bienville Parish Depot Museum name. Apply the more specific current parish name while preserving Depot Museum as alias. The municipal lease ended by agreement in 2004 per the 2016 court opinion; that historical fact does not establish current operator governance or access. Keep complete review pending; linked social page was unavailable.')
)
identity <- function(case, keys, roles, groups = rep(paste0('depot_', tolower(case)), length(keys))) {
  x <- baseline[match(keys, baseline$source_id), ]
  stopifnot(!anyNA(x$source_id), length(roles) == nrow(x))
  tibble::tibble(case_id = paste0('Next_Depot_', case), source = x$source, source_id = keys,
    expected_name = x$name_raw, expected_entity_id = x$entity_id, expected_coordinates = dn_identity_coordinates(x),
    role = roles, site_group = groups, evidence_url = e[[case]]$url, evidence_note = e[[case]]$note,
    reviewed_by = 'Codex source review', reviewed_on = '2026-09-26')
}
added <- dplyr::bind_rows(
  identity('Ironwood', c('a83f517a-72ed-4ff5-b04f-da8f1157270f','599688d9-9a69-45f3-aec7-17c2e5c344e5','9dca76f6-80a7-4da7-a487-435c032ad459','8402600185','8402600612'), c('canonical',rep('same_site',4))),
  identity('Fort_Payne', c('ea597015-66bf-447a-9a7b-8fcb47a32d74','8400100076','8400100296'), c('canonical','mislocated','mislocated')),
  identity('Enterprise', c('e629a526-88d1-4afe-a0e9-387f1913cb02','ea762bd9-f327-4d46-b5b6-0a2593786614','96b6d282-994c-4417-b904-ce1bca9e958a'), c('canonical','same_site','same_site')),
  identity('Two_Harbors', c('fc50fc17-a0b6-47f6-9c71-9865fca69f66','c20c7b90-dd50-4f50-a49d-d7996149b2ee','174cfc35-41d5-4ba9-9b18-96d0452bcd83','8402700314'), c('canonical',rep('same_site',3))),
  identity('Three_M', c('a5deb034-33a5-413a-b63b-e6a3c9f6ec72','f98b9c93-fba1-48c7-85a4-2c4d01e9c68f'), c('canonical','same_site')),
  identity('Oroville', c('9c84f701-e58e-4c68-9cfd-30c69b18539a','8405300474'), c('canonical','mislocated')),
  identity('Stratford', c('1c3d4cc1-1e28-4eac-827b-f295fc5c55fc','8404800059','8404801538'), c('split_canonical','mislocated','split_canonical'), c('stratford_museum','stratford_museum','stratford_society'))
)
ids <- dplyr::bind_rows(ids, added)
review <- dn_reconcile_museums(baseline, ids)
decision <- function(key, case, affiliation = 'unknown', status = 'pending', chain = NA_character_, category = 'not_flagged') {
  x <- baseline[match(key, baseline$source_id), ]
  tibble::tibble(source = x$source, source_id = key, expected_name = x$name_raw,
    category_decision = category, affiliation_status = affiliation, chain_id = chain,
    review_status = status, evidence_url = e[[case]]$url, note = e[[case]]$note,
    reviewed_by = 'Codex source review', reviewed_on = '2026-09-26')
}
new_decisions <- dplyr::bind_rows(
  decision('a83f517a-72ed-4ff5-b04f-da8f1157270f','Ironwood'),
  decision('ea597015-66bf-447a-9a7b-8fcb47a32d74','Fort_Payne','independent','verified'),
  decision('e629a526-88d1-4afe-a0e9-387f1913cb02','Enterprise','independent','verified'),
  decision('c7847063-e4d4-405c-a248-4e08691a0baa','Enterprise_library',status='verified',category='not_museum'),
  decision('fc50fc17-a0b6-47f6-9c71-9865fca69f66','Two_Harbors','chain','verified','lake_county_mn_historical_society'),
  decision('a5deb034-33a5-413a-b63b-e6a3c9f6ec72','Three_M','chain','verified','lake_county_mn_historical_society'),
  decision('9c84f701-e58e-4c68-9cfd-30c69b18539a','Oroville'),
  decision('1c3d4cc1-1e28-4eac-827b-f295fc5c55fc','Stratford'),
  decision('8404801538','Stratford'),
  decision('9355de74-5271-43e5-9b00-9dfb44e8e2be','Wakefield','chain','verified','wakefield_heritage_organization'),
  decision('52b41c07-849a-4aaa-bd25-36d1371101b2','Wakefield','chain','pending','wakefield_heritage_organization'),
  decision('8403100357','Wakefield','chain','pending','wakefield_heritage_organization'),
  decision('232b315e-a91a-430e-a5f7-b7f626b185c5','Mammoth','chain','verified','arkansas_state_parks'),
  decision('17c44e14-c701-4a0f-9164-84420d27a921','Rusk','independent','verified'),
  decision('c46a0fda-6435-470d-bdea-a2d491a9b44d','Arcadia')
)
stopifnot(!any(new_decisions$source_id %in% decisions$source_id))
decisions <- dplyr::bind_rows(decisions, new_decisions)
preferred <- function(key, case, name) {
  x <- review$records[match(key, review$records$source_id), ]
  stopifnot(!is.na(x$source_id), x$counted)
  tibble::tibble(source=x$source,source_id=key,expected_name=x$name_raw,expected_entity_id=x$entity_id,
    preferred_name=name,evidence_url=e[[case]]$url,evidence_note=e[[case]]$note,
    reviewed_by='Codex source review',reviewed_on='2026-09-26')
}
new_overrides <- dplyr::bind_rows(
  preferred('a83f517a-72ed-4ff5-b04f-da8f1157270f','Ironwood','Old Depot Museum'),
  preferred('e629a526-88d1-4afe-a0e9-387f1913cb02','Enterprise','Pea River Museum'),
  preferred('fc50fc17-a0b6-47f6-9c71-9865fca69f66','Two_Harbors','D&IR Railroad Depot Museum'),
  preferred('a5deb034-33a5-413a-b63b-e6a3c9f6ec72','Three_M','3M Birthplace Museum'),
  preferred('9c84f701-e58e-4c68-9cfd-30c69b18539a','Oroville','Old Oroville Depot Museum'),
  preferred('1c3d4cc1-1e28-4eac-827b-f295fc5c55fc','Stratford','Sherman County Depot Museum'),
  preferred('9355de74-5271-43e5-9b00-9dfb44e8e2be','Wakefield','Wakefield Train Depot'),
  preferred('232b315e-a91a-430e-a5f7-b7f626b185c5','Mammoth','Train Depot Museum'),
  preferred('17c44e14-c701-4a0f-9164-84420d27a921','Rusk','Rusk County Depot Museum & History Center'),
  preferred('c46a0fda-6435-470d-bdea-a2d491a9b44d','Arcadia','Arcadia Depot Museum')
)
overrides <- dplyr::bind_rows(overrides,new_overrides)
after <- dn_museum_analysis(review$records,rules,decisions,overrides,gazetteer)
counts <- tibble::tibble(counted=sum(after$counted),eligible=sum(after$analysis_eligible),
  source_counted=sum(review$records$counted),identity_rows=nrow(ids),identity_cases=dplyr::n_distinct(ids$case_id),
  verified=sum(after$review_status=='verified'),not_museum=sum(after$category_decision=='not_museum'))
print(counts,width=Inf)
stopifnot(nrow(added)==22L,nrow(ids)==160L,counts$identity_cases==63L,
  counts$counted==52539L,counts$eligible==52407L,counts$source_counted==57250L,
  counts$verified==53L,counts$not_museum==12L,
  sum(after$analysis_eligible & after$name_expanded=='depot museum')==0L)
for(n in c('added','new_decisions','new_overrides','ids','decisions','overrides','after','counts'))
  readr::write_csv(get(n),file.path(p,paste0('depot_',n,'.csv')),na='')
readr::write_csv(review$audit,file.path(p,'depot_identity_audit.csv'),na='')
readr::write_csv(dn_museum_ranking(after),file.path(p,'depot_ranking.csv'),na='')
readr::write_csv(ids,'data/validation/museum_identity_decisions.csv',na='')
readr::write_csv(decisions,'data/validation/museum_decisions.csv',na='')
readr::write_csv(overrides,'data/validation/museum_name_overrides.csv',na='')
readr::write_csv(ids,file.path(p,'depot_identity_after.csv'),na='')
message('Depot factual corrections applied; unfinished affiliations and headline certification remain pending.')
