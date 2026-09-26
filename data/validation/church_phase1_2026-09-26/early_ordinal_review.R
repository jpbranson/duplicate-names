for(f in list.files('R',pattern='[.]R$',full.names=TRUE)) source(f)
x<-arrow::read_parquet('data/raw/overture_worship_2026-08-19.0.parquet')
clean<-dn_name_clean(x$name_raw)
idx<-which(grepl('^([0-9]+(st|nd|rd|th)|twent|thirt|fort|fift|sixt|sevent|eight|ninet|hundred|one hundred|tenth|eleventh|twelfth|thirteenth|fourteenth|fifteenth|sixteenth|seventeenth|eighteenth|nineteenth)',clean))
y<-x[idx,];y$name_expanded<-dn_church_name_expand(clean[idx]);y$ordinal<-dn_church_parse_ordinal(y$name_expanded)
y<-y[!is.na(y$ordinal) & y$ordinal>=10L & !y$operating_status %in% 'permanently_closed' & y$religion %in% 'christian',]
y<-y[order(-y$ordinal,y$name_raw),]
context<-arrow::read_parquet('data/raw/overture_worship_2026-08-19.0_context.parquet')
j<-match(y$source_id,context$id)
y$websites<-vapply(context$websites[j],paste,collapse=' | ',character(1))
y$phones<-vapply(context$phones[j],paste,collapse=' | ',character(1))
readr::write_csv(y,'data/validation/church_phase1_2026-09-26/early_high_ordinals.csv')
print(y[,c('name_raw','ordinal','lon','lat','websites')],n=40,width=180)
