library(rWikiPathways)
context("Search")

test_that("find by Xref", {
  pathways = findPathwaysByXref('ENSG00000232810','En')
  expect_gt(length(pathways), 0)
})

test_that("find by Xref (again)", {
  pathways = findPathwaysByXref(identifier="ENSG00000232810", systemCode="En")
  expect_gt(length(pathways), 0)
})
