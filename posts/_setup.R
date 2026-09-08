# _setup.R ----------------------------------------------------------------
# Sourced by the first chunk of every post. Keeps knitr defaults, the theme,
# and the embed helpers in one place so the posts stay consistent and none of
# them has to think about figure geometry.
#
# Posts read ONLY from their own payload/ directory. Nothing here may touch
# data/, DuckDB, or the network — blogdown re-knits on every site rebuild, and
# a post that triggers an Overture query would make the blog unbuildable.

source(file.path(dn_root, "R", "config_blog.R"))
source(file.path(dn_root, "R", "theme_dupnames.R"))
source(file.path(dn_root, "R", "embed.R"))

suppressPackageStartupMessages({
  library(ggplot2)
  library(dplyr)
})

knitr::opts_chunk$set(
  echo    = dn_blog$echo_code,
  message = FALSE,
  warning = FALSE,
  collapse = TRUE,

  # 720px content column / 96 dpi. One number to change, in config_blog.R.
  fig.width  = dn_blog$fig_width,
  fig.asp    = 0.618,
  fig.align  = "center",
  out.width  = "100%",

  # SVG for line and bar work: sharp at any zoom, tiny files.
  # svglite rather than knitr's "svg" (= grDevices::svg), which needs cairo
  # support and is less predictable on Windows.
  # Override per-chunk for anything with tens of thousands of overplotted
  # points, where SVG file size explodes:
  #   ```{r, dev = "ragg_png", dpi = 192}
  dev = "svglite"
)

ggplot2::theme_set(theme_dupnames())

# Load a payload file. Errors loudly if the payload is missing rather than
# silently knitting a post with no numbers in it.
dn_payload <- function(file) {
  path <- file.path("payload", file)
  if (!file.exists(path)) {
    stop("Missing payload file: ", path,
         "\nRun the pipeline and re-export before knitting.", call. = FALSE)
  }
  if (grepl("\\.parquet$", path)) arrow::read_parquet(path) else readr::read_csv(path, show_col_types = FALSE)
}
