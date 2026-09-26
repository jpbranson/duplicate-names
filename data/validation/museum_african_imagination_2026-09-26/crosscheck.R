for(f in list.files('R',pattern='[.]R$',full.names=TRUE))source(f)
b<-targets::tar_read(entities)
x<-b[grepl('ASSOCIATION.*SCIENCE.*SPACE|SCIENCE.*SPACE.*ENGINEERING|\\bASSET\\b|SOUTHERN ILLINOIS|ACADIAN MEMORIAL',b$name_raw,ignore.case=TRUE),]
print(x[c('source_id','entity_id','name_raw','lon','lat','counted')],n=100,width=Inf)
p<-'data/validation/museum_african_imagination_2026-09-26'
readr::write_csv(x,file.path(p,'baseline_name_crosscheck.csv'))
k<-c('b77eb5bd-97e4-4369-a1d0-0dc7aaa2a019','f426349b-22f0-4454-9dde-fbb94a11f5f9','6f04fee0-d8f6-499f-bed2-96c1eacb1433','11d33303-171f-4d9e-8128-3bac109e573c','c26105b0-3fba-4900-8100-0c2e16e3775e','3e0f85d0-3213-4bc9-a0a0-1bbccc701df5','8404801487','df256160-3087-49eb-a5d1-8de8fceabc70','8402100230','3a87c63f-98f0-4876-9ade-7e6ad7f8a1fa','4a06db8a-1c1f-45b1-9f07-a169ab0649a5','7501a491-b22b-4926-a466-c218d99284fd','7d036ce3-6450-4717-a025-f47f3302347e','46a9f87e-a76f-4e67-b202-272c9acb12a7','8404802033')
z<-b[b$entity_id%in%b$entity_id[b$source_id%in%k],]
print(z[c('source_id','entity_id','name_raw','counted')],n=100,width=Inf)
readr::write_csv(z,file.path(p,'affected_cluster_members.csv'))
