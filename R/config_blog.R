# config_blog.R -----------------------------------------------------------
# Every knob that depends on the blog repo lives here and nowhere else.
# These are defaults chosen before the blog repo settled; adjust and re-knit.
# Nothing downstream should hardcode a path, a width, or a URL.

dn_blog <- list(

  ## --- where the blog lives ---------------------------------------------
  # Override without editing this file:  Sys.setenv(DUPNAMES_BLOG_DIR = "...")
  # or set it in ~/.Renviron so it survives sessions.
  repo_dir = Sys.getenv("DUPNAMES_BLOG_DIR", unset = "../blog"),

  # Standard Hugo layout. Change only if the theme is unusual.
  post_dir   = "content/post",
  static_dir = "static",

  ## --- post format -------------------------------------------------------
  # ".Rmd" (Pandoc -> HTML) rather than ".Rmarkdown" (Hugo -> Markdown).
  # Rationale: .Rmarkdown cannot carry HTML dependencies, so it forecloses
  # inline htmlwidgets permanently. Maps are iframed either way (see embed.R),
  # so this costs nothing today and keeps the option open. .Rmd also gets
  # Pandoc footnotes and citations, which a source-heavy post wants.
  # Switching later is a rename plus a rebuild.
  post_ext = ".Rmd",

  # Leaf page bundles: content/post/<slug>/index.Rmd with data alongside.
  # Data files then publish as page resources, so readers can download the
  # numbers behind each chart.
  page_bundle = TRUE,

  ## --- embeds ------------------------------------------------------------
  # Namespaced under the project so future projects can't collide.
  embed_rel      = "static/embeds/duplicate-names",  # path inside the blog repo
  embed_url_base = "/embeds/duplicate-names",        # URL once deployed
  embed_height   = 520L,                             # px; per-embed override ok

  ## --- figure geometry ---------------------------------------------------
  # Assumed content column width. Most Hugo themes land at 700-800px; 720
  # is the safe middle and divides cleanly by 96 dpi -> fig.width = 7.5in.
  # Measure the real column once the theme is chosen and change this one number.
  content_px = 720L,

  # Show code in posts? FALSE suits a general-audience blog; the pipeline is
  # public anyway, so the code belongs in the repo rather than the prose.
  echo_code = FALSE,

  ## --- slugs -------------------------------------------------------------
  # Plain and searchable rather than clever. These become permanent URLs,
  # so they are worth disliking now instead of after publication.
  slugs = c(
    museums       = "duplicate-museum-names",
    churches      = "duplicate-church-names",
    over_time     = "church-naming-over-time",
    first_baptist = "the-other-first-baptist"
  )
)

# Derived, not configured -------------------------------------------------
dn_blog$fig_width <- dn_blog$content_px / 96

#' Absolute path to a post's page bundle inside the blog repo
dn_blog_post_path <- function(key) {
  slug <- dn_blog$slugs[[key]]
  file.path(dn_blog$repo_dir, dn_blog$post_dir, slug)
}

#' Absolute path to the blog's embed directory
dn_blog_embed_path <- function() {
  file.path(dn_blog$repo_dir, dn_blog$embed_rel)
}

#' Is the blog repo actually there yet?
#' Deploy steps call this so a missing repo fails loudly instead of writing
#' a payload into a path that doesn't exist.
dn_blog_available <- function() dir.exists(dn_blog$repo_dir)
