library(rWikiPathways)
context("Pathway")

test_that("get WP2338 Xrefs", {
  xrefs = getXrefList("WP2338", "S")
  expect_true("Q9UPY3" %in% xrefs)
})

test_that("get WP2338 (again)", {
  xrefs = getXrefList(pathway="WP2338", systemCode="S")
  expect_true("Q9UPY3" %in% xrefs)
})
