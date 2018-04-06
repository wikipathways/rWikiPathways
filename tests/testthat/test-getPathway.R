library(rWikiPathways)
context("Pathway")

test_that("get WP4", {
  gpml = getPathway("WP4")
  expect_length(gpml, 1)
})

test_that("get WP4 (again)", {
  gpml = getPathway(pathway="WP4")
  expect_length(gpml, 1)
})

test_that("get a specific revision of WP4", {
  gpml = getPathway(pathway="WP4", revision=83654)
  expect_length(gpml, 1)
})
