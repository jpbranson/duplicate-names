for(f in list.files('R',pattern='[.]R$',full.names=TRUE))source(f)
p<-'data/validation/church_ordinal_review_2026-09-26'
test<-testthat::test_dir('tests/testthat',reporter='summary',stop_on_failure=TRUE)
saveRDS(test,file.path(p,'test_results.rds'))
flat<-as.data.frame(test)
jsonlite::write_json(list(tests=nrow(flat),passed=sum(flat$passed),failed=sum(flat$failed),
 errors=sum(flat$error),warnings=sum(flat$warning),skips=sum(flat$skipped)),
 file.path(p,'test_summary.json'),pretty=TRUE,auto_unbox=TRUE)
old<-targets::tar_outdated(script='_targets_churches.R',store='_targets_churches')
writeLines(old,file.path(p,'outdated_before.txt'))
# This build must reuse the pinned public source caches.
stopifnot(!any(c('church_raw_overture','church_raw_gnis','church_raw_hifld','church_raw')%in%old))
targets::tar_make(names='church_output_files',script='_targets_churches.R',store='_targets_churches',reporter='verbose')
