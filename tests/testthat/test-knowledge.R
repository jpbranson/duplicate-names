knowledge_root <- function() test_path("..", "..", "knowledge")

# A scratch bundle under the session temp directory, which R removes on exit.
local_bundle <- function() {
  root <- tempfile("okf")
  dir.create(root)
  root
}

test_that("the knowledge bundle conforms to OKF v0.2 and the bundle conventions", {
  expect_identical(dn_okf_check(knowledge_root()), character(0))
})

test_that("every concept has a type, a title and a one-line description", {
  concepts <- dn_okf_concepts(knowledge_root())
  expect_gt(nrow(concepts), 0)
  expect_false(anyNA(concepts$type))
  expect_true(all(nzchar(concepts$description)))
  expect_false(any(grepl("\n", concepts$description)))
})

test_that("the checker reports missing types, broken links and stale indexes", {
  root <- local_bundle()
  dir.create(file.path(root, "topic"))
  writeLines(c("---", "okf_version: \"0.2\"", "---", "", "* [Topic](topic/) - x"),
             file.path(root, "index.md"))
  writeLines(c("---", "title: No type", "---", "", "See [missing](gone.md)."),
             file.path(root, "topic", "a.md"))
  problems <- dn_okf_check(root)
  expect_true(any(grepl("a.md: type is missing", problems, fixed = TRUE)))
  expect_true(any(grepl("unresolved path: gone.md", problems, fixed = TRUE)))
  expect_true(any(grepl("topic/index.md: missing", problems, fixed = TRUE)))

  writeLines(c("---", "type: Note", "description: A note.", "---", "", "Body."),
             file.path(root, "topic", "a.md"))
  dn_okf_write_indexes(root)
  expect_identical(dn_okf_check(root), character(0))
})

test_that("deprecated concepts must name their replacement", {
  root <- local_bundle()
  writeLines(c("---", "okf_version: \"0.2\"", "---"), file.path(root, "index.md"))
  writeLines(c("---", "type: Note", "status: deprecated", "---"), file.path(root, "old.md"))
  expect_true(any(grepl("old.md: deprecated concept has no superseded_by",
                        dn_okf_check(root), fixed = TRUE)))
})

test_that("git objects and URLs are not checked as local paths", {
  expect_identical(dn_okf_is_local_path(c("7416eef:DESIGN.md", "https://x.org/a",
                                          "s3://bucket/a/*", "../a.md", "scope with spaces")),
                   c(FALSE, FALSE, FALSE, TRUE, FALSE))
})
