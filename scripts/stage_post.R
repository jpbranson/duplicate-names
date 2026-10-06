# Stage a post's page bundle in the blogdown site and knit it there.
# Copies index.Rmd, _setup.R, R/ and payload/ from posts/<slug>/ into
# <DUPNAMES_BLOG_DIR>/content/post/<slug>/ and renders index.html beside them.
# It does not run Hugo, change `draft`, commit or push: publishing stays a deliberate
# step in the blog repository. Needs Pandoc (set RSTUDIO_PANDOC if none is on PATH).
# Example: DUPNAMES_BLOG_DIR=../goodsite Rscript scripts/stage_post.R museums
args <- commandArgs(trailingOnly = TRUE)
source("R/config_blog.R")
if (length(args) != 1L || !args[1] %in% names(dn_blog$slugs)) {
  stop("Supply one post key: ", paste(names(dn_blog$slugs), collapse = ", "))
}
if (!dn_blog_available()) {
  stop("Blog repo not found at '", dn_blog$repo_dir, "'. Set DUPNAMES_BLOG_DIR.")
}
if (!rmarkdown::pandoc_available()) stop("Pandoc not found. Set RSTUDIO_PANDOC.")
slug <- dn_blog$slugs[[args[1]]]
bundle <- file.path("posts", slug)
keep <- c("index.Rmd", "_setup.R", "R", "payload")
dest <- dn_blog_post_path(args[1])
dir.create(dest, showWarnings = FALSE, recursive = TRUE)
stopifnot(all(file.exists(file.path(bundle, keep))),
          all(file.copy(file.path(bundle, keep), dest, recursive = TRUE, overwrite = TRUE)))
# blogdown knits in a child session; hand it this project's library.
Sys.setenv(R_LIBS = paste(.libPaths(), collapse = .Platform$path.sep))
setwd(dn_blog$repo_dir)
blogdown::build_site(build_rmd = file.path(dn_blog$post_dir, slug, "index.Rmd"), run_hugo = FALSE)
message("Staged ", slug, " in ", normalizePath(file.path(dn_blog$post_dir, slug), winslash = "/"),
        ". Review it, then publish from the blog repository.")
