library(rWikiPathways)
context("Pathway")

test_that("get WP4", {
  gpml = getPathway("WP4")
})

test_that("get WP4 (again)", {
  gpml = getPathway(pathway="WP4")
})

test_that("get a specific revision of WP4", {
  gpml = getPathway(pathway="WP4", revision=83654)
})
