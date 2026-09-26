# Resume only the dossier portion after the preserved-input snapshot succeeded.
for (f in list.files("R", pattern = "[.]R$", full.names = TRUE)) source(f)
p <- "data/validation/museum_affiliation_followup_2026-09-26"
a <- targets::tar_read(museum_analysis); e <- targets::tar_read(entities); r <- targets::tar_read(museum_records)
selected <- a[grepl("smithsonian|madame tussaud", a$name_expanded), ]
protected <- readr::read_csv(file.path(p, "preserved_input_checksums.csv"), show_col_types = FALSE)$path
lines <- readLines(file.path(p, "prepare.R"))
start <- grep("^near <-", lines)
eval(parse(text = lines[start:length(lines)]))
imls <- dn_imls_review_context("data/raw/2018_csv_museum_data_files.zip")
readr::write_csv(imls[imls$source_id %in% related$source_id, ], file.path(p, "imls_context.csv"), na = "")
