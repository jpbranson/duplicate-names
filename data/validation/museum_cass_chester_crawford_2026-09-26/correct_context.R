# Correct only the exploratory name selection after a copied regex was detected.
# Preserve original output and the one-time before snapshot; do not rerun prepare.
for(f in list.files('R',pattern='[.]R$',full.names=TRUE))source(f)
p <- 'data/validation/museum_cass_chester_crawford_2026-09-26'
stopifnot(!file.exists(file.path(p,'related_initial_selection.csv')))
stopifnot(file.copy(file.path(p,'related_baseline_records.csv'),file.path(p,'related_initial_selection.csv')))
stopifnot(file.copy(file.path(p,'imls_context.csv'),file.path(p,'imls_initial_selection.csv')))
before <- readRDS('data/processed/museum_cass_chester_crawford_before.rds')
baseline <- before$entities
candidates <- readr::read_csv(file.path(p,'candidates_before.csv'),show_col_types=FALSE)
near <- vapply(seq_len(nrow(baseline)),function(i)any(abs(baseline$lat[i]-candidates$lat)<.09 & abs(baseline$lon[i]-candidates$lon)<.13),logical(1))
named <- grepl('(cass|crawford) county|chester historical',baseline$name_raw,ignore.case=TRUE)
related <- baseline[baseline$entity_id%in%baseline$entity_id[near|named],]
readr::write_csv(related,file.path(p,'related_baseline_records.csv'),na='')
imls <- dn_imls_review_context('data/raw/2018_csv_museum_data_files.zip')
readr::write_csv(dplyr::filter(imls,.data$source_id%in%related$source_id),file.path(p,'imls_context.csv'),na='')
message(nrow(candidates),' candidates unchanged; ',nrow(related),' corrected related rows; original selection preserved')
