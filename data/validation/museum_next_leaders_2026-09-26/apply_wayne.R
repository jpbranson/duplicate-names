# One-time factual corrections. Not independent matching-accuracy labels.
for (f in list.files('R', pattern = '[.]R$', full.names = TRUE)) source(f)
p <- 'data/validation/museum_next_leaders_2026-09-26'
stopifnot(!file.exists(file.path(p, 'wayne_identity_after.csv')))
baseline <- targets::tar_read(entities)
ids <- dn_read_museum_review('data/validation/museum_identity_decisions.csv', dn_schema_museum_identity_decisions())
decisions <- dn_read_museum_review('data/validation/museum_decisions.csv', dn_schema_museum_decisions())
overrides <- dn_read_museum_review('data/validation/museum_name_overrides.csv', dn_schema_museum_name_overrides())
rules <- targets::tar_read(museum_chain_rules)
gazetteer <- targets::tar_read(gazetteer)
stopifnot(identical(ids, dn_read_museum_review(file.path(p, 'identity_decisions_before.csv'), dn_schema_museum_identity_decisions())))
urls <- function(...) paste(c(...), collapse = ' | ')
evidence <- list(
  MO = list(url = urls('https://waynecomo.wordpress.com/', 'https://waynecomo.wordpress.com/contact/'),
    note = 'Operator identifies Luna Museum at 108 West Elm and gives PO Box 222 for society membership payments. Overture has the physical museum address; IMLS has the mailing address. Count one institution and retain the displaced mailing point. Current governance remains pending.'),
  IA = list(url = urls('https://prairietrailsmuseum.wordpress.com/', 'https://prairietrailsmuseum.wordpress.com/contactus/', 'https://ptmuseum.blogspot.com/2017/10/', 'https://waynecountydevelopmentcorp.com/walldogs'),
    note = 'Museum contact links 515 East Jefferson and PO Box 104; its own history links the museum and society. Both IMLS rows share EIN 421049099, with that street or PO box. Two Overture names at the same campus and two displaced IMLS rows represent one museum, including the adjacent Heritage Barn exhibits. Count the museum-named Overture representative once. Complete affiliation review remains pending.'),
  NY = list(url = urls('https://www.waynehistory.org/about', 'https://www.waynehistory.org/visit'),
    note = 'Operator explicitly identifies Museum of Wayne County History at 21 Butternut Street. IMLS society and Overture museum addresses match. Jail, residence and carriage-house galleries are one museum campus. The local nonprofit society lists its 2026 board and museum staff; independent operation is supported. Seasonal public access is advertised; recheck hours before visitor export.'),
  NE = list(url = urls('https://wcm-ne.wixsite.com/waynecountymuseum', 'https://wcm-ne.wixsite.com/waynecountymuseum/contact-us', 'https://wcm-ne.wixsite.com/waynecountymuseum/missionleadership', 'https://www.cityofwayne.org/453/Wayne-County-Museum'),
    note = 'Museum operator identifies the Ley house donated to the Wayne County Historical Society, Seventh and Lincoln, and phone 402-375-1278. These match IMLS physical address and Overture 702 Lincoln, despite the displaced IMLS point. Count one Wayne County Museum. Operator mission and local board support independent operation. Operator and city differ slightly on the seasonal closing date; use appointment wording and recheck before visitor export.'),
  KY = list(url = urls('https://www.waynecountymuseum.com/', 'https://www.irs.gov/pub/irs-soi/eo_ny.csv'),
    note = 'Operator links PO Box 320 to William Crenshaw Kennedy, Jr. Memorial Museum at 65 North Main. IMLS 8409400741 is the local society EIN 611020324. IMLS 8402100284 mixes Monticello museum address/website with Michael J Quill Irish Cultural and Sports Centre EIN 222848395; current IRS NY data identifies the latter in East Durham NY, also PO Box 320. Isolate the mixed row uncounted without aliases. The Overture museum row is the current canonical source, but its 75 North Main address and source point versus current 65 North Main require publication-location review; affiliation is pending.'),
  IL = list(url = 'https://wayneillinoishistory.org/museums',
    note = 'Society lists two distinct museums: Early History Museum at 300 SE Second (separate from the public library despite a shared roof) and Hanna House Museum at 101 East Center. Existing society cluster identifies Early History Museum by its address. Preserve two institutions and record their common Wayne County Illinois Historical Society operator. The schoolhouse belongs to the park district and the courthouse photographs are outreach exhibits, not extra branches inferred here.'),
  PA = list(url = urls('https://www.waynehistorypa.com/about/contact', 'https://www.waynehistorypa.com/museums/main', 'https://www.waynehistorypa.com/'),
    note = 'Operator links main museum at 810 Main Street with PO Box 446, matching the existing cluster. The connected galleries and library form one main campus. The operator calls it Wayne County Historical Society Museum and lists separate museums including J.B. Park Farm Museum and Old Stone Jail; record common parent affiliation, without merging separate sites.')
)
identity <- function(case, keys, roles) {
  x <- baseline[match(keys, baseline$source_id), ]
  stopifnot(!anyNA(x$source_id), length(roles) == nrow(x))
  tibble::tibble(case_id = paste0('Next_Wayne_', case), source = x$source, source_id = x$source_id,
    expected_name = x$name_raw, expected_entity_id = x$entity_id,
    expected_coordinates = dn_identity_coordinates(x), role = roles,
    site_group = ifelse(roles == 'source_conflict', 'unresolved_source', paste0('wayne_', tolower(case))),
    evidence_url = evidence[[case]]$url, evidence_note = evidence[[case]]$note,
    reviewed_by = 'Codex source review', reviewed_on = '2026-09-26')
}
added <- dplyr::bind_rows(
  identity('MO', c('fca5a5b4-d004-4955-a9b4-b3a4a057c314', '8402900411'), c('canonical', 'mailing_address')),
  identity('IA', c('fe39a0d8-e6fc-4b14-981d-14761e75c5b4', '405076c5-98a9-4413-a2c5-3901b49e35f5', '8401900034', '8401900345'),
    c('canonical', 'same_site', 'mislocated', 'mailing_address')),
  identity('NY', c('8ff5a085-19cf-42eb-834d-790de5c9a0e7', '8403601288'), c('canonical', 'same_site')),
  identity('NE', c('f9c0cdf7-5808-401d-bc96-114772f03060', '8403100197'), c('canonical', 'mislocated')),
  identity('KY', c('d6592999-2949-4d3b-8cc4-a81fb3e3a02d', '8409400741', '8402100284'), c('canonical', 'mailing_address', 'source_conflict'))
)
ids <- dplyr::bind_rows(ids, added)
review <- dn_reconcile_museums(baseline, ids)
decision <- function(key, case, affiliation = 'unknown', status = 'pending', chain = NA_character_) {
  x <- baseline[match(key, baseline$source_id), ]
  stopifnot(!is.na(x$source_id))
  tibble::tibble(source = x$source, source_id = key, expected_name = x$name_raw,
    category_decision = 'not_flagged', affiliation_status = affiliation, chain_id = chain,
    review_status = status, evidence_url = evidence[[case]]$url, note = evidence[[case]]$note,
    reviewed_by = 'Codex source review', reviewed_on = '2026-09-26')
}
new_decisions <- dplyr::bind_rows(
  decision('fca5a5b4-d004-4955-a9b4-b3a4a057c314', 'MO'),
  decision('fe39a0d8-e6fc-4b14-981d-14761e75c5b4', 'IA'),
  decision('8ff5a085-19cf-42eb-834d-790de5c9a0e7', 'NY', 'independent', 'verified'),
  decision('f9c0cdf7-5808-401d-bc96-114772f03060', 'NE', 'independent', 'verified'),
  decision('d6592999-2949-4d3b-8cc4-a81fb3e3a02d', 'KY'),
  decision('37aaa243-5f9e-4fab-951d-1f00ccdabac4', 'IL', 'chain', 'verified', 'wayne_county_il_historical_society'),
  decision('4d3d2962-26b7-458b-9e62-7c16d5a0b1f8', 'IL', 'chain', 'verified', 'wayne_county_il_historical_society'),
  decision('5ae907bf-9fce-42f1-95a8-46213f72d13c', 'PA', 'chain', 'verified', 'wayne_county_pa_historical_society')
)
stopifnot(!any(new_decisions$source_id %in% decisions$source_id))
decisions <- dplyr::bind_rows(decisions, new_decisions)
preferred <- function(key, case, name) {
  x <- review$records[match(key, review$records$source_id), ]
  stopifnot(!is.na(x$source_id), x$counted)
  tibble::tibble(source = x$source, source_id = key, expected_name = x$name_raw,
    expected_entity_id = x$entity_id, preferred_name = name, evidence_url = evidence[[case]]$url,
    evidence_note = evidence[[case]]$note, reviewed_by = 'Codex source review', reviewed_on = '2026-09-26')
}
new_overrides <- dplyr::bind_rows(
  preferred('fca5a5b4-d004-4955-a9b4-b3a4a057c314', 'MO', 'Luna Museum'),
  preferred('fe39a0d8-e6fc-4b14-981d-14761e75c5b4', 'IA', 'Prairie Trails Museum of Wayne County'),
  preferred('f9c0cdf7-5808-401d-bc96-114772f03060', 'NE', 'Wayne County Museum'),
  preferred('d6592999-2949-4d3b-8cc4-a81fb3e3a02d', 'KY', 'William Crenshaw Kennedy, Jr. Memorial Museum'),
  preferred('37aaa243-5f9e-4fab-951d-1f00ccdabac4', 'IL', 'Early History Museum'),
  preferred('5ae907bf-9fce-42f1-95a8-46213f72d13c', 'PA', 'Wayne County Historical Society Museum')
)
overrides <- dplyr::bind_rows(overrides, new_overrides)
after <- dn_museum_analysis(review$records, rules, decisions, overrides, gazetteer)
stopifnot(nrow(added) == 13L, nrow(ids) == 138L, dplyr::n_distinct(ids$case_id) == 56L,
  sum(after$counted) == 52550L, sum(after$analysis_eligible) == 52418L,
  sum(review$records$counted) == 57264L, sum(after$review_status == 'verified') == 45L,
  sum(after$analysis_eligible & after$name_expanded == 'wayne county historical society') == 1L)
for (n in c('added', 'new_decisions', 'new_overrides', 'ids', 'decisions', 'overrides', 'after')) {
  readr::write_csv(get(n), file.path(p, paste0('wayne_', n, '.csv')), na = '')
}
readr::write_csv(review$audit, file.path(p, 'wayne_identity_audit.csv'), na = '')
readr::write_csv(dn_museum_ranking(after), file.path(p, 'wayne_ranking.csv'), na = '')
ny <- readr::read_csv('data/raw/next_leaders_irs_ny_2026-09-26.csv', col_types = readr::cols(.default = 'c'))
readr::write_csv(ny[ny$EIN == '222848395', ], file.path(p, 'irs_quill_selected.csv'))
readr::write_csv(ids, 'data/validation/museum_identity_decisions.csv', na = '')
readr::write_csv(decisions, 'data/validation/museum_decisions.csv', na = '')
readr::write_csv(overrides, 'data/validation/museum_name_overrides.csv', na = '')
readr::write_csv(ids, file.path(p, 'wayne_identity_after.csv'), na = '')
message('Wayne corrections applied: 52550 counted; 52418 eligible; 45 complete reviews; one unresolved bare society name.')
