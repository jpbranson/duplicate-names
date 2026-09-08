# embed.R -----------------------------------------------------------------
# Maps ship as self-contained HTML files that the post iframes, rather than as
# inline htmlwidgets. See DESIGN.md §7.1 for why. The short version: it works
# with either post format, it can't collide with the Hugo theme's CSS, and the
# same files become the Phase 4 dashboard unchanged.

#' Write a widget to a standalone HTML file in embeds/
#'
#' selfcontained = TRUE inlines every dependency, so the file opens correctly
#' in a bare browser tab with no sibling directory. That is the acceptance test
#' for an embed: open it directly, not just inside the post.
dn_save_embed <- function(widget, slug, title = NULL, dir = "embeds") {
  if (!requireNamespace("htmlwidgets", quietly = TRUE)) {
    stop("htmlwidgets is required to build embeds.", call. = FALSE)
  }
  dir.create(dir, showWarnings = FALSE, recursive = TRUE)
  path <- file.path(dir, paste0(slug, ".html"))

  # saveWidget insists on an absolute path when selfcontained = TRUE.
  htmlwidgets::saveWidget(
    widget,
    file          = normalizePath(path, winslash = "/", mustWork = FALSE),
    selfcontained = TRUE,
    title         = title %||% slug
  )
  invisible(path)
}

#' Render a static fallback image for an embed
#'
#' Every interactive map needs one, for RSS readers and anyone blocking
#' iframes. Build it as its own considered key view rather than screenshotting
#' the widget at the end — it is often the version most people actually see.
#'
#' NOTE: `dir` must be the post's page-bundle directory, not `embeds/`.
#' `dn_iframe()` links the fallback as a page resource relative to the post,
#' so the PNG travels with `index.Rmd` while the HTML goes to `static/`.
dn_save_fallback <- function(plot, slug, dir,
                             width = dn_blog$fig_width, height = width * 0.618) {
  dir.create(dir, showWarnings = FALSE, recursive = TRUE)
  path <- file.path(dir, paste0(slug, "-fallback.png"))
  ggplot2::ggsave(path, plot, width = width, height = height, dpi = 192, bg = dn_ink$surface)
  invisible(path)
}

#' HTML for an embedded map, for use in a `results='asis'` chunk
#'
#' Deliberately no `sandbox` attribute: sandboxing without `allow-scripts`
#' silently kills the map, and with it the attribute buys nothing here since
#' we author the embed ourselves.
dn_iframe <- function(slug, caption = NULL,
                      height = dn_blog$embed_height,
                      fallback = TRUE,
                      title = NULL) {
  src <- paste0(dn_blog$embed_url_base, "/", slug, ".html")

  fb <- if (isTRUE(fallback)) {
    sprintf(
      ' <a href="%s-fallback.png">Static version</a>.',
      slug  # page-bundle resource, so a relative name resolves against the post
    )
  } else ""

  cap <- if (!is.null(caption) || nzchar(fb)) {
    sprintf("\n  <figcaption>%s%s</figcaption>", caption %||% "", fb)
  } else ""

  sprintf(
'<figure class="dn-embed">
  <iframe src="%s" width="100%%" height="%d" loading="lazy"
          title="%s" style="border:0;display:block;width:100%%;"></iframe>%s
</figure>',
    src, as.integer(height), title %||% (caption %||% slug), cap
  )
}

#' Copy built embeds into the blog repo
dn_deploy_embeds <- function(dir = "embeds") {
  if (!dn_blog_available()) {
    stop("Blog repo not found at '", dn_blog$repo_dir,
         "'. Set DUPNAMES_BLOG_DIR.", call. = FALSE)
  }
  dest <- dn_blog_embed_path()
  dir.create(dest, showWarnings = FALSE, recursive = TRUE)
  files <- list.files(dir, pattern = "\\.html$", full.names = TRUE)
  ok <- file.copy(files, dest, overwrite = TRUE)
  message(sprintf("Copied %d embed(s) to %s", sum(ok), dest))
  invisible(files[ok])
}
