# Standalone build in a copy with no project profile or analysis-root environment.
p <- "data/validation/artifact_refresh_2026-09-26"
bundle <- normalizePath("posts/duplicate-museum-names", winslash = "/")
stopifnot(file.exists(file.path(bundle, "payload/seed_institution.csv")))
iso <- normalizePath(file.path("data/processed", paste0("museum_bundle_check_", format(Sys.time(), "%Y%m%d_%H%M%S"))), winslash = "/", mustWork = FALSE)
dir.create(iso, recursive = TRUE)
files <- list.files(bundle, full.names = TRUE, all.files = FALSE)
stopifnot(all(file.copy(files, iso, recursive = TRUE)))
pandoc <- jsonlite::fromJSON("data/processed/tools/pandoc/provenance.json")
result <- callr::r(function(folder) {
  setwd(folder)
  stopifnot(!file.exists("_targets.R"), !dir.exists("data"), Sys.getenv("DUPNAMES_ROOT") == "__analysis_checkout_unavailable__")
  rendered <- rmarkdown::render("index.Rmd", output_format = rmarkdown::html_document(self_contained = TRUE, toc = FALSE, css = "preview.css"), output_file = "preview.html", quiet = TRUE, envir = new.env(parent = globalenv()))
  html <- paste(readLines(rendered, warn = FALSE), collapse = "\n")
  stopifnot(grepl("Working draft", html, fixed = TRUE), grepl("unpublished", html, fixed = TRUE), grepl("data:image/", html, fixed = TRUE), !grepl("{{", html, fixed = TRUE))
  list(path = rendered, bytes = unname(file.size(rendered)), pandoc = as.character(rmarkdown::pandoc_version()), input_files = list.files(".", recursive = TRUE))
}, args = list(folder = iso), libpath = .libPaths(), user_profile = FALSE, system_profile = FALSE,
  env = c(RSTUDIO_PANDOC = dirname(pandoc$executable), DUPNAMES_ROOT = "__analysis_checkout_unavailable__", DUPNAMES_BLOG_DIR = "__blog_destination_unavailable__"))
stopifnot(file.copy(result$path, file.path(bundle, "preview.html"), overwrite = TRUE))
if (dir.exists(file.path(iso, "figures"))) file.copy(file.path(iso, "figures"), bundle, recursive = TRUE, overwrite = TRUE)
jsonlite::write_json(list(status = "passed", isolated_directory = iso, no_project_profile = TRUE,
  analysis_checkout_used_by_knit = FALSE, final_publication_ready = FALSE, build = result), file.path(p, "standalone_build.json"), pretty = TRUE, auto_unbox = TRUE)
message("Standalone draft render passed; ", result$bytes, " bytes; Pandoc ", result$pandoc)



