# theme_dupnames.R --------------------------------------------------------
# Shared ggplot2 theme, palette and scales. Requires ggplot2 attached.
#
# The palette is the dataviz reference instance, used verbatim rather than
# invented: the slot ORDER is the colourblind-safety mechanism (candidate
# orderings were enumerated and only those clearing every adjacent-pair gate
# in both light and dark kept). Do not reorder, do not insert a ninth hue,
# do not "adjust one to match the blog." Swapping in a different palette
# means re-running the validator against these gates, not eyeballing it.

# Categorical ---------------------------------------------------------------
# Light-surface steps. Assign in fixed order, never cycled.
dn_palette <- c(
  blue    = "#2a78d6",
  orange  = "#eb6834",
  aqua    = "#1baf7a",
  yellow  = "#eda100",
  magenta = "#e87ba4",
  green   = "#008300",
  violet  = "#4a3aa7",
  red     = "#e34948"
)

# Chart chrome and ink (light surface) --------------------------------------
dn_ink <- list(
  surface   = "#fcfcfb",
  page      = "#f9f9f7",
  primary   = "#0b0b0b",
  secondary = "#52514e",
  muted     = "#898781",
  grid      = "#e1e0d9",
  axis      = "#c3c2b7"
)

# Sequential (magnitude: duplicate counts, territory distance) --------------
# One hue, light -> dark. Never a rainbow.
dn_sequential <- c(
  "#cde2fb", "#b7d3f6", "#9ec5f4", "#86b6ef", "#6da7ec", "#5598e7",
  "#3987e5", "#2a78d6", "#256abf", "#1c5cab", "#184f95", "#104281", "#0d366b"
)

# For ORDINAL ramps (discrete ordered marks) the lightest step must still
# clear 2:1 against the surface: start at #86b6ef, not #cde2fb.
dn_sequential_ordinal <- dn_sequential[4:length(dn_sequential)]

# Diverging (only for genuine polarity, e.g. over/under an expected count) --
dn_diverging <- list(low = "#2a78d6", mid = "#f0efec", high = "#e34948")

# Series caps ---------------------------------------------------------------
# The number of categorical hues that stay distinguishable depends on whether
# any pair can end up adjacent:
#   * DN_CAP_ADJACENT - stacked bars, grouped bars, lines. Order controls
#     which pairs touch, so all 8 slots validate.
#   * DN_CAP_ALL_PAIRS - maps, scatter, small multiples. Any pair can land
#     side by side, and only the first 3 slots clear the floors.
# Post 2 wants to colour a map by denomination; there are far more than three.
# Fold the tail into "Other", or facet. Do not add a ninth hue.
DN_CAP_ADJACENT  <- 8L
DN_CAP_ALL_PAIRS <- 3L

#' Palette function with an enforced cap
dn_pal <- function(n, cap = DN_CAP_ADJACENT) {
  if (n > cap) {
    stop(sprintf(
      "%d series requested but the cap is %d. Fold the tail into 'Other' or facet; do not extend the palette.",
      n, cap
    ), call. = FALSE)
  }
  unname(dn_palette[seq_len(n)])
}

scale_colour_dn <- function(..., cap = DN_CAP_ADJACENT) {
  ggplot2::discrete_scale("colour", palette = function(n) dn_pal(n, cap), ...)
}
scale_color_dn <- scale_colour_dn

scale_fill_dn <- function(..., cap = DN_CAP_ADJACENT) {
  ggplot2::discrete_scale("fill", palette = function(n) dn_pal(n, cap), ...)
}

scale_fill_dn_c <- function(...) {
  ggplot2::scale_fill_gradientn(colours = dn_sequential, ...)
}
scale_colour_dn_c <- function(...) {
  ggplot2::scale_colour_gradientn(colours = dn_sequential, ...)
}

# Theme ---------------------------------------------------------------------
theme_dupnames <- function(base_size = 12, base_family = "") {
  ggplot2::theme_minimal(base_size = base_size, base_family = base_family) +
    ggplot2::theme(
      plot.background  = ggplot2::element_rect(fill = dn_ink$surface, colour = NA),
      panel.background = ggplot2::element_rect(fill = dn_ink$surface, colour = NA),

      # Recessive grid; horizontal only, and no minor lines.
      panel.grid.major.y = ggplot2::element_line(colour = dn_ink$grid, linewidth = 0.3),
      panel.grid.major.x = ggplot2::element_blank(),
      panel.grid.minor   = ggplot2::element_blank(),

      axis.line.x = ggplot2::element_line(colour = dn_ink$axis, linewidth = 0.4),
      axis.ticks  = ggplot2::element_blank(),
      axis.text   = ggplot2::element_text(colour = dn_ink$muted, size = ggplot2::rel(0.9)),
      axis.title  = ggplot2::element_text(colour = dn_ink$secondary, size = ggplot2::rel(0.9)),

      # Text wears text tokens, never the series colour.
      plot.title    = ggplot2::element_text(colour = dn_ink$primary, face = "bold",
                                            size = ggplot2::rel(1.15),
                                            margin = ggplot2::margin(b = 4)),
      plot.subtitle = ggplot2::element_text(colour = dn_ink$secondary,
                                            size = ggplot2::rel(0.95),
                                            margin = ggplot2::margin(b = 12)),
      plot.caption  = ggplot2::element_text(colour = dn_ink$muted,
                                            size = ggplot2::rel(0.8), hjust = 0,
                                            margin = ggplot2::margin(t = 12)),
      plot.title.position   = "plot",
      plot.caption.position = "plot",

      legend.position      = "top",
      legend.justification = "left",
      legend.title         = ggplot2::element_blank(),
      legend.text          = ggplot2::element_text(colour = dn_ink$secondary),
      legend.key.size      = ggplot2::unit(10, "pt"),

      strip.text = ggplot2::element_text(colour = dn_ink$secondary, face = "bold", hjust = 0)
    )
}

#' Source line for a figure caption.
#'
#' Attribution is not optional for some of these sources, so it is a function
#' rather than something to retype. If OSM is ever load-bearing in a published
#' figure, this is where the ODbL attribution has to appear (see DESIGN.md §7).
dn_caption <- function(sources, note = NULL) {
  known <- c(
    overture = "Overture Maps",
    osm      = "OpenStreetMap contributors (ODbL)",
    gnis     = "USGS GNIS (2021 archive)",
    imls     = "IMLS Museum Universe Data File",
    hifld    = "HIFLD Places of Worship",
    census   = "US Census Bureau"
  )
  unknown <- setdiff(sources, names(known))
  if (length(unknown)) {
    stop("Unknown source key(s): ", paste(unknown, collapse = ", "), call. = FALSE)
  }
  line <- paste0("Source: ", paste(known[sources], collapse = "; "), ".")
  if (!is.null(note)) line <- paste(line, note)
  line
}
