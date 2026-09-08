library(testthat)

# Source the project's functions. Deliberately not an R package: the analysis
# code is a pipeline, not a library, and targets sources R/ the same way.
for (f in list.files("R", pattern = "[.]R$", full.names = TRUE)) source(f)

test_dir("tests/testthat")
