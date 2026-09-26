# Run only after the derived pipeline and preservation checks succeed.
p<-'data/validation/church_ordinal_review_2026-09-26'
checks<-readr::read_csv(file.path(p,'integrity_checks.csv'),show_col_types=FALSE)
stopifnot(nrow(checks)>=20L,all(checks$passed),file.exists(file.path(p,'checkpoint.json')))
bundle<-'posts/duplicate-church-names';folder<-'data/processed/church_review'
required<-c('duplicate_counts','census_place_exclusivity','incorporated_place_exclusivity',
 'territory_summary','ordinal_ladders','naming_style_profile','municipal_multiplicity','coverage','publication_gates')
for(n in required)stopifnot(file.copy(file.path(folder,paste0(n,'.csv')),
 file.path(bundle,'payload',paste0(n,'.csv')),overwrite=TRUE))
counts<-readr::read_csv(file.path(folder,'duplicate_counts.csv'),show_col_types=FALSE) |>
 dplyr::group_by(.data$level) |> dplyr::slice_head(n=200L) |> dplyr::ungroup()
readr::write_csv(counts,file.path(bundle,'payload/duplicate_counts.csv'))
# The map's complete entity/coordinate set was checked in validate.R. Reuse it.
source(file.path(p,'render_standalone.R'))
Sys.setenv(DUPNAMES_DASHBOARD_EVIDENCE=p)
source('dashboard/build_data.R')
