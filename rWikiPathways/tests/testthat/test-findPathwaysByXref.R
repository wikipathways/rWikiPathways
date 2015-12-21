library(rWikiPathways)
context("Search")

test_that("find by Xref", {
  pathways = findPathwaysByXref("HMDB00001", "Ch")
  expect_that(nrow(pathways), not(equals(0)))
})

test_that("find by Xref (again)", {
  pathways = findPathwaysByXref(identifier="HMDB00001", systemCode="Ch")
  expect_that(nrow(pathways), not(equals(0)))
})

test_that("find by multiple Xrefs", {
  pathways = findPathwaysByXref(
    identifier=c("HMDB00001", "HMDB00002"),
    systemCode=c("Ch", "Ch")
  )
  expect_that(nrow(pathways), not(equals(0)))
})
