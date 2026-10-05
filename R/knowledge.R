# Open Knowledge Format (OKF v0.2) helpers for the knowledge/ bundle.
#
# The bundle's conventions are in knowledge/conventions.md. These helpers are not
# part of either pipeline: tar_source() loads them, but no target depends on them.

DN_OKF_RESERVED <- c("index.md", "log.md")
DN_OKF_STATUS <- c("draft", "stable", "deprecated")
DN_OKF_TIME <- "^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}(:\\d{2}(\\.\\d+)?)?(Z|[+-]\\d{2}:\\d{2})$"
DN_OKF_ACTOR <- "^(human:[^[:space:]]+|process:[^[:space:]]+|[^[:space:]:/]+/[^[:space:]]+)$"

# Subdirectory descriptions for generated indexes.
DN_OKF_DIRS <- c(
  "project" = "Premise, deliverables, phases, current status, mission, work logs, open questions and pitfalls",
  "decisions" = "Numbered project decisions, with dates and recorded approvals",
  "methodology" = "Normalization, extraction, entity resolution, identity corrections, chains, category names and the publication gate",
  "metrics" = "Pre-registered museum (M1-M3) and church (C1-C5) metrics",
  "datasets" = "Source datasets used, planned or rejected, with provenance",
  "inputs" = "Live decision tables and label sets that feed the pipelines",
  "evidence" = "One concept per dated validation packet, by track",
  "evidence/museums" = "Museum review checkpoints, 2026-09-15 to the current M2 checkpoint",
  "evidence/churches" = "Church acquisition, ordinal/scope checkpoint and the pending scope proposal",
  "evidence/artifacts" = "Local post and explorer build checks",
  "architecture" = "Stack, reproducibility, renv, licensing, blog publishing and dashboard design",
  "playbooks" = "Step-by-step procedures for setup, review, evidence preservation and replay",
  "publications" = "State of each post and the explorer",
  "leads" = "Analogous naming phenomena for future posts"
)

dn_okf_read <- function(path) {
  x <- readLines(path, encoding = "UTF-8", warn = FALSE)
  if (!length(x) || x[1] != "---") {
    return(list(frontmatter = NULL, body = x, error = NULL))
  }
  end <- which(x == "---")
  end <- end[end > 1]
  if (!length(end)) {
    return(list(frontmatter = NULL, body = x, error = "unterminated frontmatter"))
  }
  fm <- tryCatch(
    yaml::yaml.load(paste(x[seq.int(2, length.out = end[1] - 2)], collapse = "\n")),
    error = function(e) structure(conditionMessage(e), class = "dn_okf_error")
  )
  if (inherits(fm, "dn_okf_error")) {
    return(list(frontmatter = NULL, body = x[-seq_len(end[1])], error = unclass(fm)))
  }
  list(frontmatter = fm %||% list(), body = x[-seq_len(end[1])], error = NULL)
}

dn_okf_files <- function(root) {
  files <- list.files(root, pattern = "[.]md$", recursive = TRUE)
  sort(files)
}

# One row per concept document, in index order.
dn_okf_concepts <- function(root = "knowledge") {
  files <- dn_okf_files(root)
  files <- files[!basename(files) %in% DN_OKF_RESERVED]
  rows <- lapply(files, function(f) {
    fm <- dn_okf_read(file.path(root, f))$frontmatter
    one <- function(key, default = NA_character_) {
      v <- fm[[key]]
      if (is.null(v) || !length(v)) default else as.character(v[[1]])
    }
    data.frame(
      path = f, dir = dirname(f), file = basename(f),
      type = one("type"), title = one("title", sub("[.]md$", "", basename(f))),
      description = one("description", ""), status = one("status", "stable"),
      sequence = suppressWarnings(as.numeric(one("sequence"))),
      stringsAsFactors = FALSE
    )
  })
  out <- do.call(rbind, rows)
  out[order(out$dir, is.na(out$sequence), out$sequence, out$file), , drop = FALSE]
}

dn_okf_plural <- function(x) ifelse(grepl("s$", x), x, paste0(x, "s"))

# Text of a generated index.md for one directory below the bundle root.
dn_okf_index_text <- function(root, dir, concepts = dn_okf_concepts(root)) {
  here <- concepts[concepts$dir == dir, , drop = FALSE]
  lines <- character()
  entry <- function(r) {
    desc <- r$description
    if (identical(r$status, "draft")) desc <- paste("Draft.", desc)
    sprintf("* [%s](%s) - %s", r$title, r$file, desc)
  }
  for (type in unique(here$type)) {
    of_type <- here[here$type == type, , drop = FALSE]
    current <- of_type[of_type$status != "deprecated", , drop = FALSE]
    old <- of_type[of_type$status == "deprecated", , drop = FALSE]
    if (nrow(current)) {
      lines <- c(lines, paste("#", dn_okf_plural(type)), "",
                 vapply(seq_len(nrow(current)), function(i) entry(current[i, ]), ""), "")
    }
    if (nrow(old)) {
      lines <- c(lines, paste0("# ", dn_okf_plural(type), " (superseded)"), "",
                 vapply(seq_len(nrow(old)), function(i) entry(old[i, ]), ""), "")
    }
  }
  subdirs <- list.dirs(file.path(root, dir), full.names = FALSE, recursive = FALSE)
  if (length(subdirs)) {
    keys <- if (dir == ".") subdirs else file.path(dir, subdirs)
    keep <- order(match(keys, names(DN_OKF_DIRS)), subdirs)
    subdirs <- subdirs[keep]
    keys <- keys[keep]
    desc <- unname(DN_OKF_DIRS[keys])
    desc[is.na(desc)] <- "Subdirectory"
    lines <- c(lines, "# Subdirectories", "",
               sprintf("* [%s](%s/) - %s", subdirs, subdirs, desc), "")
  }
  paste0(paste(lines[-length(lines)], collapse = "\n"), "\n")
}

dn_okf_index_dirs <- function(root) {
  dirs <- list.dirs(root, full.names = FALSE, recursive = TRUE)
  setdiff(dirs, "")
}

# Rewrite every generated index.md. The bundle-root index.md is written by hand.
dn_okf_write_indexes <- function(root = "knowledge") {
  concepts <- dn_okf_concepts(root)
  paths <- character()
  for (dir in dn_okf_index_dirs(root)) {
    path <- file.path(root, dir, "index.md")
    con <- file(path, open = "wb")
    writeLines(enc2utf8(dn_okf_index_text(root, dir, concepts)), con, sep = "", useBytes = TRUE)
    close(con)
    paths <- c(paths, path)
  }
  invisible(paths)
}

# Relative paths only: not URLs, git objects such as 7416eef:DESIGN.md, or scope descriptors.
dn_okf_is_local_path <- function(x) {
  !grepl("^[A-Za-z][A-Za-z0-9+.-]*:", x) & !grepl("^[0-9a-f]{7,40}:", x) &
    !grepl("[[:space:]]", x) & nzchar(x)
}

dn_okf_resolves <- function(from_dir, target) {
  target <- sub("#.*$", "", target)
  if (!nzchar(target)) return(TRUE)
  file.exists(file.path(from_dir, utils::URLdecode(target)))
}

# Body lines outside fenced code, with inline code spans removed.
dn_okf_prose <- function(body) {
  fence <- cumsum(grepl("^\\s*```", body)) %% 2 == 1 | grepl("^\\s*```", body)
  gsub("`[^`]*`", "", body[!fence])
}

dn_okf_body_links <- function(body) {
  text <- dn_okf_prose(body)
  m <- regmatches(text, gregexpr("\\]\\(([^)[:space:]]+)\\)", text))
  sub("^\\]\\((.*)\\)$", "\\1", unlist(m))
}

dn_okf_check_time <- function(x) is.character(x) && length(x) == 1 && grepl(DN_OKF_TIME, x)

dn_okf_check_actor_events <- function(x, key) {
  if (is.null(x)) return(character())
  if (!is.null(names(x))) x <- list(x)
  bad <- character()
  for (ev in x) {
    if (!is.character(ev$by) || !grepl(DN_OKF_ACTOR, ev$by)) {
      bad <- c(bad, sprintf("%s.by is not an actor", key))
    }
    if (!is.null(ev$at) && !dn_okf_check_time(ev$at)) {
      bad <- c(bad, sprintf("%s.at is not an ISO 8601 datetime with offset", key))
    }
  }
  bad
}

dn_okf_check_concept <- function(root, f) {
  path <- file.path(root, f)
  doc <- dn_okf_read(path)
  if (!is.null(doc$error)) return(paste0(f, ": ", doc$error))
  fm <- doc$frontmatter
  if (is.null(fm)) return(paste0(f, ": missing frontmatter"))
  p <- character()
  if (!is.character(fm$type) || length(fm$type) != 1 || !nzchar(fm$type)) {
    p <- c(p, "type is missing or empty")
  }
  status <- fm$status %||% "stable"
  if (!status %in% DN_OKF_STATUS) p <- c(p, paste("unknown status", status))
  if (identical(status, "deprecated") && is.null(fm$superseded_by)) {
    p <- c(p, "deprecated concept has no superseded_by")
  }
  p <- c(p, dn_okf_check_actor_events(fm$generated, "generated"),
         dn_okf_check_actor_events(fm$verified, "verified"))
  if (!is.null(fm$generated) && is.null(fm$generated$at)) p <- c(p, "generated.at is missing")
  if (!is.null(fm$stale_after) && !dn_okf_check_time(fm$stale_after)) {
    p <- c(p, "stale_after is not an ISO 8601 datetime with offset")
  }
  ids <- character()
  for (s in fm$sources) {
    if (is.null(s$resource)) p <- c(p, "a sources entry has no resource")
    if (!is.null(s$id)) ids <- c(ids, s$id)
  }
  if (anyDuplicated(ids)) p <- c(p, "duplicate sources ids")
  prose <- dn_okf_prose(doc$body)
  used <- unique(unlist(regmatches(prose, gregexpr("\\[\\^[^]]+\\]", prose))))
  used <- gsub("^\\[\\^|\\]$", "", used)
  missing <- setdiff(used, ids)
  if (length(missing)) {
    p <- c(p, paste("footnotes without a sources id:", paste(missing, collapse = ", ")))
  }
  from <- dirname(path)
  paths <- c(fm$resource, fm$superseded_by, unlist(fm$implemented_in),
             vapply(fm$sources, function(s) as.character(s$resource %||% ""), ""))
  links <- c(paths[dn_okf_is_local_path(paths)], dn_okf_body_links(doc$body))
  links <- links[dn_okf_is_local_path(links) & !startsWith(links, "#")]
  broken <- links[!vapply(links, function(l) dn_okf_resolves(from, l), TRUE)]
  if (length(broken)) p <- c(p, paste("unresolved path:", unique(broken)))
  if (any(grepl("__GEN_AT__", c(doc$body, unlist(fm))))) p <- c(p, "unreplaced __GEN_AT__ placeholder")
  if (length(p)) paste0(f, ": ", p) else character()
}

# Problems with the bundle at root; character(0) when it conforms.
dn_okf_check <- function(root = "knowledge") {
  files <- dn_okf_files(root)
  problems <- character()
  for (f in files[!basename(files) %in% DN_OKF_RESERVED]) {
    problems <- c(problems, dn_okf_check_concept(root, f))
  }
  concepts <- dn_okf_concepts(root)
  for (dir in dn_okf_index_dirs(root)) {
    path <- file.path(root, dir, "index.md")
    if (!file.exists(path)) {
      problems <- c(problems, paste0(file.path(dir, "index.md"), ": missing"))
    } else if (!identical(paste(readLines(path, encoding = "UTF-8", warn = FALSE), collapse = "\n"),
                          sub("\n$", "", dn_okf_index_text(root, dir, concepts)))) {
      problems <- c(problems, paste0(file.path(dir, "index.md"),
                                     ": stale; run dn_okf_write_indexes()"))
    }
  }
  root_index <- dn_okf_read(file.path(root, "index.md"))
  if (is.null(root_index$frontmatter) ||
      !identical(names(root_index$frontmatter), "okf_version")) {
    problems <- c(problems, "index.md: root index must carry only okf_version frontmatter")
  }
  top <- list.dirs(root, full.names = FALSE, recursive = FALSE)
  linked <- dn_okf_body_links(root_index$body)
  for (d in top[!paste0(top, "/") %in% linked]) {
    problems <- c(problems, sprintf("index.md: does not link %s/", d))
  }
  for (f in files[basename(files) %in% DN_OKF_RESERVED]) {
    doc <- dn_okf_read(file.path(root, f))
    if (basename(f) == "index.md" && f != "index.md" && !is.null(doc$frontmatter)) {
      problems <- c(problems, paste0(f, ": index files carry no frontmatter"))
    }
    links <- dn_okf_body_links(doc$body)
    links <- links[dn_okf_is_local_path(links)]
    broken <- links[!vapply(links, function(l) dn_okf_resolves(dirname(file.path(root, f)), l), TRUE)]
    if (length(broken)) problems <- c(problems, paste0(f, ": unresolved path: ", unique(broken)))
  }
  if (file.exists(file.path(root, "log.md"))) {
    log <- readLines(file.path(root, "log.md"), encoding = "UTF-8", warn = FALSE)
    heads <- sub("^## ", "", grep("^## ", log, value = TRUE))
    dates <- as.Date(heads, format = "%Y-%m-%d")
    if (anyNA(dates) || !all(grepl("^\\d{4}-\\d{2}-\\d{2}$", heads))) {
      problems <- c(problems, "log.md: date headings must be YYYY-MM-DD")
    } else if (is.unsorted(rev(dates), strictly = TRUE)) {
      problems <- c(problems, "log.md: entries must be newest first, one heading per date")
    }
  }
  problems
}
