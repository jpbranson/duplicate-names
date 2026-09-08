# setup-renv.R ------------------------------------------------------------
# One-time environment bootstrap. Run with R 4.4:
#   "C:/Program Files/R/R-4.4.2/bin/x64/Rscript.exe" setup-renv.R
#
# Kept out of R/ deliberately: _targets.R sources everything in R/, and this
# script has side effects that must not run on every tar_make().

options(
  repos = c(CRAN = "https://packagemanager.posit.co/cran/latest"),
  renv.config.auto.snapshot = FALSE,
  Ncpus = max(1L, parallel::detectCores() - 1L)
)

# Posit Package Manager serves Windows binaries, so this is downloads rather
# than compiles. renv keeps a global cache, so the cost is paid once across
# projects rather than once per project.

if (!requireNamespace("renv", quietly = TRUE)) install.packages("renv")

if (!file.exists("renv.lock") && !dir.exists("renv")) {
  renv::init(bare = TRUE, restart = FALSE)
}

# Explicit snapshots, driven by DESCRIPTION.
#
# The default ("implicit") records only packages referenced in code today,
# which silently drops anything a Phase 1 stub has committed to but not yet
# called — sf, mapgl and stringdist all vanished from the lockfile that way.
#
# DESCRIPTION must say `Type: Project`, NOT carry a `Package:` field: renv
# treats a DESCRIPTION with `Package:` as an R package project and relocates
# the library out of renv/library into the cache, orphaning everything already
# installed. Everything goes in Imports because the default dependency fields
# are Imports/Depends/LinkingTo — Suggests is not scanned.
renv::settings$snapshot.type("explicit")

pkgs <- read.dcf("DESCRIPTION", fields = "Imports")[1, 1] |>
  strsplit(",")            |> unlist() |>
  trimws()                 |>
  (\(x) x[nzchar(x)])()

renv::install(pkgs, prompt = FALSE)
renv::snapshot(prompt = FALSE)

cat("\n--- bootstrap complete ---\n")
cat("R:", R.version.string, "\n")
cat("packages:", length(pkgs), "requested\n")
