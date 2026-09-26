# Verify that the post builds without the analysis checkout, profile or network.
p <- 'data/validation/church_ordinal_review_2026-09-26'
bundle <- normalizePath('posts/duplicate-church-names',winslash='/')
iso <- normalizePath(file.path('data/processed',paste0('church_bundle_check_',format(Sys.time(),'%Y%m%d_%H%M%S'))),winslash='/',mustWork=FALSE)
dir.create(iso,recursive=TRUE)
stopifnot(all(file.copy(list.files(bundle,full.names=TRUE),iso,recursive=TRUE)))
pandoc <- jsonlite::fromJSON('data/processed/tools/pandoc/provenance.json')
result <- callr::r(function(folder) {
  setwd(folder)
  stopifnot(!file.exists('_targets_churches.R'),!dir.exists('data'))
  rendered <- rmarkdown::render('index.Rmd',output_format=rmarkdown::html_document(
    self_contained=TRUE,toc=FALSE,css='preview.css'),output_file='preview.html',quiet=TRUE,
    envir=new.env(parent=globalenv()))
  html <- paste(readLines(rendered,warn=FALSE),collapse='\n')
  stopifnot(grepl('Research draft',html,fixed=TRUE),grepl('unpublished',html,fixed=TRUE),
    grepl('data:image/',html,fixed=TRUE),!grepl('{{',html,fixed=TRUE),
    file.exists('embeds/first-baptist.html'),file.exists('first-baptist-fallback.png'),
    grepl('src="embeds/first-baptist.html"',html,fixed=TRUE))
  list(path=rendered,bytes=unname(file.size(rendered)),pandoc=as.character(rmarkdown::pandoc_version()),
    input_files=list.files('.',recursive=TRUE))
},args=list(folder=iso),libpath=.libPaths(),user_profile=FALSE,system_profile=FALSE,
env=c(RSTUDIO_PANDOC=dirname(pandoc$executable),DUPNAMES_ROOT='__analysis_checkout_unavailable__',
      DUPNAMES_BLOG_DIR='__blog_destination_unavailable__'))
stopifnot(file.copy(result$path,file.path(bundle,'preview.html'),overwrite=TRUE))
if(dir.exists(file.path(iso,'figures'))) file.copy(file.path(iso,'figures'),bundle,recursive=TRUE,overwrite=TRUE)
jsonlite::write_json(list(status='passed',isolated_directory=iso,no_project_profile=TRUE,
  analysis_checkout_used_by_knit=FALSE,final_publication_ready=FALSE,build=result),
  file.path(p,'standalone_build.json'),pretty=TRUE,auto_unbox=TRUE)
message('Standalone church draft render passed; ',result$bytes,' bytes')

