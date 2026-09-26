for(f in list.files('R',pattern='[.]R$',full.names=TRUE)) source(f)
x<-src_census_states()
message('Census states: ',nrow(x))
