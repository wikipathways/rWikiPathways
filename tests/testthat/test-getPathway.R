library(rWikiPathways)
context("Pathway")

test_that("get WP554", {
  gpml = getPathway("WP554")
  expect_length(gpml, 1)
})

test_that("get WP4 (again)", {
  gpml = getPathway(pathway="WP554")
  expect_length(gpml, 1)
})

test_that("get a specific revision of WP554", {
  gpml = getPathway(pathway="WP554", revision=83654)
  expect_length(gpml, 1)
})
