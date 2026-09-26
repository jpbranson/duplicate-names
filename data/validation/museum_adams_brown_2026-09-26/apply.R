# Factual correction batch. First run without arguments to inspect proposed outputs;
# run once with --apply only after reviewing those outputs. No human labels created.
for(f in list.files('R',pattern='[.]R$',full.names=TRUE))source(f)
p <- 'data/validation/museum_adams_brown_2026-09-26'
stopifnot(!file.exists(file.path(p,'applied.json')))
baseline <- targets::tar_read(entities)
ids <- dn_read_museum_review('data/validation/museum_identity_decisions.csv',dn_schema_museum_identity_decisions())
decisions <- dn_read_museum_review('data/validation/museum_decisions.csv',dn_schema_museum_decisions())
overrides <- dn_read_museum_review('data/validation/museum_name_overrides.csv',dn_schema_museum_name_overrides())
for(n in c('museum_identity_decisions','museum_decisions','museum_name_overrides')) {
 live <- readBin(file.path('data/validation',paste0(n,'.csv')),'raw',n=file.size(file.path('data/validation',paste0(n,'.csv'))))
 old <- readBin(file.path(p,paste0(n,'_before.csv')),'raw',n=file.size(file.path(p,paste0(n,'_before.csv'))))
 stopifnot(identical(live,old))
}
urls <- function(...)paste(c(...),collapse=' | ')
e <- list(
 Adams_PA=list(url=urls('https://gettysburghistory.org/about-us/','https://gettysburghistory.org/beyond-the-battle-museum/','https://gettysburghistory.org/research/','https://www.adamscountycf.org/accf2/wp-content/uploads/2018/09/2018-Giving-Book.pdf'),note='The operator documents its move from the seminary area to the new Beyond the Battle Museum at 625 Biglerville Road in April 2023 and the Gettysburg History public identity in 2025. Overture museum and parent rows both give 625 Biglerville. The 2018 community-foundation entry links 368 Springs Avenue and PO Box 4325, matching the old Overture and IMLS records. Count one current museum, with former-site and mailing records preserved. Its research room and event center are components of that campus. The same operator now owns Shriver House, which remains a separate museum. The older PDF is web-index readable but raw download returned 403.'),
 Shriver=list(url=urls('https://www.shriverhouse.org/our-history/','https://www.shriverhouse.org/','https://gettysburghistory.org/about-us/'),note='Museum explicitly reports Gettysburg History ownership and management since January 2025, alongside Beyond the Battle. Shriver remains a separate house museum at 307 Baltimore Street, matching the Overture row. Record common parent affiliation and current public name; do not combine distinct visitor institutions.'),
 Adams_ID=list(url=urls('https://historicpindepot.com/about/','https://historicpindepot.com/about/timeline/','https://www.newmeadowsidaho.us/business/adams-county-historical-societypin-railway-depot'),note='Operator links Historic P&IN Depot at 101 South Commercial Avenue to PO Box 352, matching Overture and IMLS. Count the depot once and retain the displaced mailing point. The May 2025 transfer to the city retains society oversight and continued museum/exhibit use; current lobby/City Hall hours and special exhibits are separately described. This is one locally operated institution, not a closure or a second city-hall museum. Recheck exhibit access before a visit recommendation.'),
 Adams_IN=list(url=urls('https://www.adamscountymuseum.org/page2','https://www.adamscountymuseum.org/form-map','https://www.adamscountymuseum.org/'),note='The society describes its museum in the purchased Dugan Mansion at 420 West Monroe, matching Overture, and lists PO Box 262 matching IMLS. Its 2026 board and museum hours support local independent operation. Count the museum-named physical record once, preserving the society mailing record. The current operator uses several museum-name variants; retain the existing museum canonical name.'),
 Adams_CO=list(url=urls('https://www.adamscountymuseum.com/about-us','https://www.adamscountymuseum.com/','https://www.adamscountymuseum.com/museum-buildings'),note='Operator identifies Adams County Museum at 9601 Henderson Road and explicitly describes one complex comprising the museum office and historic/reconstructed buildings. Both existing source members identify that address. Its nonprofit society has its own board; district funding does not imply common museum ownership. Retain the baseline cluster and use Adams County Museum as the public name. Tours of campus buildings require advance scheduling.'),
 Adams_NE=list(url=urls('https://www.adamshistory.org/index.php?Itemid=158&id=11&option=com_content&view=article','https://www.adamshistory.org/index.php?Itemid=4&id=3&option=com_content&view=article','https://www.adamshistory.org/index.php?Itemid=124&catid=17&id=5%3Acontact-us&option=com_content&view=article'),note='The operator affirmatively describes its archives, research, publications and radio history work, located inside Hastings Museum at 1330 North Burlington, with PO Box 102. Those addresses match IMLS. This is the separate historical society archive, not an additional museum. Exclude as not_museum without merging it into Hastings Museum or changing the museum institution. Cached About page includes the local board and executive director.'),
 Adams_WI=list(url=urls('https://adamshistory.com/?page_id=2','https://adamshistory.com/?page_id=429','https://adamshistory.com/?page_id=73'),note='The operator links PO Box 264 to its local society and explicitly operates the separate McGowan House museum, Heritage Center exhibits at 311 Main and a fairgrounds museum. Record sourced common-parent affiliation. The generic mailing-only IMLS row cannot yet be assigned to a particular counted site; keep its name and overall review pending, without merging distinct museums or inventing coordinates.'),
 Adams_WA=list(url=urls('https://adamscountyhistoricalsociety.com/about.php','https://adamscountyhistoricalsociety.com/contact.php'),note='Current operator gives PO Box 526 Lind, rotating meeting places and its 2026 board. The Lind Overture row links that website but lacks a precise visitor address; IMLS instead gives 974 East Weber Road Ritzville. Available primary evidence does not bridge that old legal/address record or establish the museum role of either point. Keep both pending and separate. Generic directory claims about a depot are not accepted as identity evidence; neither a mailbox nor absent museum page establishes not_museum.'),
 Brown_IN=list(url=urls('https://www.browncountyhistorycenter.org/','https://www.browncountyhistorycenter.org/pioneer-village.html','https://browncounty.com/do-list/brown-county-history-center/','https://browncounty.com/do-list/pioneer-village/','https://www.browncountyhistorycenter.org/uploads/7/3/3/0/7330483/2025_february.pdf'),note='Operator links 90 East Gould and PO Box 668, matching the current Overture society and IMLS mailing identity; the archive physical field retains older 46 East Gould. Its newsletter identifies the local board, museum/old jail and archives. Official destination listings describe Pioneer Village at the History Center, immediately adjoining the center, under the same phone/operator. Treat the center, archives and adjacent historic-building village as one integrated museum campus, using Brown County History Center; retain Pioneer Museum as a source alias. No separate distant branches are inferred. Seasonal building access differs from walk-through grounds access.'),
 Brown_KS=list(url=urls('https://www.cityofhiawatha.org/residents/page/museums','https://www.brcoks.org/1209/Brown-County-Genealogy','https://brcountyksgs.org/history-of-the-society'),note='City and county list two separate Historical Society museums: downtown at 611 Utah and Agriculture Museum at 301 East Iowa. Corresponding IMLS rows share EIN 480886284 and those exact streets; match each to its Overture museum separately. The baseline downtown cluster incorrectly includes Genealogical Society EIN 481216776 at 116 South Seventh. That operator documents its independent library and 1999 move from a desk in the historical society. Explicitly split the library from the museum and exclude only its separate library record as not_museum. Preserve two museums under Brown County Kansas Historical Society; no shared-operator merge across the two campuses.'),
 Brown_WI=list(url=urls('https://browncohistoricalsoc.org/features/historic-hazelwood/','https://browncohistoricalsoc.org/contact/','https://browncohistoricalsoc.org/about/board-staff/','https://browncohistoricalsoc.org/about/history-of-the-society/'),note='Operator owns Hazelwood Historic House Museum at 1008 South Monroe and describes its office in the lower level. Both IMLS rows share EIN 390884495 and that physical/street identity; the museum-named IMLS point is displaced. Merge the three source entities into one historic-house institution and retain source aliases. Current local board and 1989 ownership transfer support independence; former involvement in Heritage Hill and Neville Museum is not present common ownership.'),
 Brown_SD=list(url=urls('https://bchsofsd.com/about/','https://bchsofsd.com/'),note='Current society explicitly describes itself as supporting Dacotah Prairie Museum and its Foundation through volunteer and financial assistance, historical publications and projects. Its own history distinguishes the society from the museum; the current contact is at the museum. Exclude the separate IMLS society-office record as not_museum, while retaining the separately represented Dacotah Prairie Museum. This is supported by affirmative role descriptions, not the old address alone. Do not infer current ownership of Centennial Village from historical donations.'),
 Brown_NE=list(url=urls('https://usgenwebsites.org/negenweb/NEBrown/brownhistsoc.htm','https://browncountyne.gov/wp-content/uploads/2024/09/Current-COMPREHENSIVE-PLAN.pdf'),note='A society-hosted history describes Coleman House and genealogy facilities at 406 East Fourth; county planning distinguishes Coleman/Dixon House museum from Sellors Barton Museum. IMLS gives 339 North Ash and PO Box 124. Current source-address continuity, exact institution/campus scope and governance remain unresolved. Keep this candidate pending; do not merge it into Sellors Barton or rewrite its source point.'),
 Brown_IL=list(url='https://browncountyil.org/history-of-mt-sterling/',note='County destination history identifies Whistle Stop Depot Museum, restored by Brown County Historical Society, at the fairgrounds beside the Ferguson school exhibit. Use this supported museum public name for the society candidate. Its old RR 4 Box 16 record and present governance/access still require follow-up; leave complete review and affiliation pending. Do not infer that the school is a separate institution.'),
 Brown_OH=list(url='https://www.browncountyohiochamber.com/destination-map/',note='The official chamber destination map identifies Brown County Historical Society Museum at 200 East Cherry Street Georgetown, distinct from Grant, Rankin and Parker institutions. Use that public museum name. The IMLS PO Box 283, current operator governance and precise jail/library campus scope still need confirmation. No ownership or merge is inferred from unsourced directory prose, and the candidate remains pending.')
)
identity <- function(case,keys,roles,groups=rep(tolower(case),length(keys))) {
 x <- baseline[match(keys,baseline$source_id),]
 stopifnot(!anyNA(x$source_id),length(roles)==nrow(x))
 tibble::tibble(case_id=paste0('AB_',case),source=x$source,source_id=x$source_id,expected_name=x$name_raw,
 expected_entity_id=x$entity_id,expected_coordinates=dn_identity_coordinates(x),role=roles,site_group=groups,
 evidence_url=e[[case]]$url,evidence_note=e[[case]]$note,reviewed_by='Codex source review',reviewed_on='2026-09-26')
}
added <- dplyr::bind_rows(
 identity('Adams_PA',c('9bc6534c-5c96-4694-a488-e1b5bb156f0e','98ac1f1c-fa45-4dbf-936c-84d69aa71286','24e6aa00-8e2f-409c-9f86-f3b881c4e5ca','8404201022'),c('canonical','same_site','former_site','mailing_address'),c('adams_pa','adams_pa','adams_pa_former','adams_pa')),
 identity('Adams_ID',c('ca6d9884-7c79-4fb4-b0a6-26b1982fc2d5','8401600104'),c('canonical','mailing_address')),
 identity('Adams_IN',c('5a290bce-72eb-48e7-90e6-c7de8dee8e71','8401800661'),c('canonical','mailing_address')),
 identity('Brown_IN',c('a1d017c5-82bf-4f34-a59e-53fadcb5b37e','8401800640','238b8aab-1bef-40f3-9d75-18e0eafebf57'),c('canonical','mailing_address','same_site')),
 identity('Brown_KS',c('aff43a35-ba4c-4e4a-b131-e68efc4ed329','8402000306','8402000471','4e541899-3db8-4463-9b6e-fe3c2edb01ff','8402000105'),c('split_canonical','mislocated','split_canonical','split_canonical','mislocated'),c('downtown','downtown','genealogy','agriculture','agriculture')),
 identity('Brown_WI',c('0ca9f4f1-d41a-46d1-8d55-47515acdca80','8405500087','8405500350'),c('canonical','mislocated','same_site')))
ids <- dplyr::bind_rows(ids,added)
review <- dn_reconcile_museums(baseline,ids)
decision <- function(key,case,aff='unknown',status='pending',chain=NA_character_,category='not_flagged') {
 x<-baseline[match(key,baseline$source_id),];stopifnot(!is.na(x$source_id))
 tibble::tibble(source=x$source,source_id=key,expected_name=x$name_raw,category_decision=category,affiliation_status=aff,
 chain_id=chain,review_status=status,evidence_url=e[[case]]$url,note=e[[case]]$note,reviewed_by='Codex source review',reviewed_on='2026-09-26')
}
new_decisions <- dplyr::bind_rows(
 decision('9bc6534c-5c96-4694-a488-e1b5bb156f0e','Adams_PA','chain','verified','gettysburg_history'),
 decision('a954cd19-6a7d-4745-a9df-1a492f251551','Shriver','chain','verified','gettysburg_history'),
 decision('ca6d9884-7c79-4fb4-b0a6-26b1982fc2d5','Adams_ID','independent','verified'),
 decision('5a290bce-72eb-48e7-90e6-c7de8dee8e71','Adams_IN','independent','verified'),
 decision('9fa2c7d5-60f1-42e6-b311-d3ef900a5798','Adams_CO','independent','verified'),
 decision('8403100324','Adams_NE','independent','verified',category='not_museum'),
 decision('8405500241','Adams_WI','chain','pending','adams_county_wi_historical_society'),
 decision('33a655d1-24d1-4058-90f9-14a802f3fe82','Adams_WA'),decision('8405300663','Adams_WA'),
 decision('a1d017c5-82bf-4f34-a59e-53fadcb5b37e','Brown_IN','independent','verified'),
 decision('aff43a35-ba4c-4e4a-b131-e68efc4ed329','Brown_KS','chain','verified','brown_county_ks_historical_society'),
 decision('4e541899-3db8-4463-9b6e-fe3c2edb01ff','Brown_KS','chain','verified','brown_county_ks_historical_society'),
 decision('8402000471','Brown_KS','independent','verified',category='not_museum'),
 decision('0ca9f4f1-d41a-46d1-8d55-47515acdca80','Brown_WI','independent','verified'),
 decision('8404600066','Brown_SD','independent','verified',category='not_museum'),
 decision('8403100207','Brown_NE'),decision('8401701116','Brown_IL'),decision('8403900553','Brown_OH'))
stopifnot(!any(new_decisions$source_id%in%decisions$source_id))
decisions <- dplyr::bind_rows(decisions,new_decisions)
preferred <- function(key,case,name) {
 x<-review$records[match(key,review$records$source_id),];stopifnot(!is.na(x$source_id),x$counted)
 tibble::tibble(source=x$source,source_id=key,expected_name=x$name_raw,expected_entity_id=x$entity_id,preferred_name=name,
 evidence_url=e[[case]]$url,evidence_note=e[[case]]$note,reviewed_by='Codex source review',reviewed_on='2026-09-26')
}
new_overrides <- dplyr::bind_rows(
 preferred('9bc6534c-5c96-4694-a488-e1b5bb156f0e','Adams_PA','Beyond the Battle Museum'),
 preferred('a954cd19-6a7d-4745-a9df-1a492f251551','Shriver','Shriver House Museum'),
 preferred('9fa2c7d5-60f1-42e6-b311-d3ef900a5798','Adams_CO','Adams County Museum'),
 preferred('a1d017c5-82bf-4f34-a59e-53fadcb5b37e','Brown_IN','Brown County History Center'),
 preferred('aff43a35-ba4c-4e4a-b131-e68efc4ed329','Brown_KS','Brown County Historical Society Museum'),
 preferred('4e541899-3db8-4463-9b6e-fe3c2edb01ff','Brown_KS','Brown County Agriculture Museum'),
 preferred('0ca9f4f1-d41a-46d1-8d55-47515acdca80','Brown_WI','Hazelwood Historic House Museum'),
 preferred('8401701116','Brown_IL','Whistle Stop Depot Museum'),preferred('8403900553','Brown_OH','Brown County Historical Society Museum'))
overrides <- dplyr::bind_rows(overrides,new_overrides)
after <- dn_museum_analysis(review$records,targets::tar_read(museum_chain_rules),decisions,overrides,targets::tar_read(gazetteer))
protected<-readr::read_csv(file.path(p,'protected_files.csv'),show_col_types=FALSE)
stopifnot(identical(unname(vapply(protected$path,digest::digest,character(1),algo='sha256',file=TRUE)),protected$sha256))
summary <- tibble::tibble(source_rows=nrow(review$records),counted_rows=sum(review$records$counted),institutions=sum(after$counted),eligible=sum(after$analysis_eligible),identity_rows=nrow(ids),identity_cases=dplyr::n_distinct(ids$case_id),complete_reviews=sum(after$review_status=='verified'),not_museum=sum(after$category_decision=='not_museum'),overrides=nrow(overrides))
print(summary,width=Inf)
print(dn_museum_ranking(after)[1:12,],width=Inf)
stopifnot(nrow(added)==19L,nrow(new_decisions)==18L,nrow(new_overrides)==9L,
 summary$source_rows==60002L,summary$counted_rows==57239L,summary$institutions==52526L,
 summary$eligible==52394L,summary$identity_rows==179L,summary$identity_cases==69L,
 summary$complete_reviews==65L,summary$not_museum==15L,summary$overrides==27L)
for(n in c('added','new_decisions','new_overrides','after','ids','decisions','overrides','summary'))
 readr::write_csv(get(n),file.path(p,paste0('proposed_',n,'.csv')),na='')
readr::write_csv(review$audit,file.path(p,'proposed_identity_audit.csv'),na='')
if('--apply'%in%commandArgs(trailingOnly=TRUE)){
 readr::write_csv(ids,'data/validation/museum_identity_decisions.csv',na='')
 readr::write_csv(decisions,'data/validation/museum_decisions.csv',na='')
 readr::write_csv(overrides,'data/validation/museum_name_overrides.csv',na='')
 jsonlite::write_json(list(applied_utc=format(Sys.time(),tz='UTC',usetz=TRUE),summary=summary,cloud_cost_usd=0),file.path(p,'applied.json'),pretty=TRUE,auto_unbox=TRUE)
 message('Factual decisions applied. Pipeline exports still require selective rebuild.')
}else message('Dry run passed; no live decision inputs changed.')
