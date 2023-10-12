library(rWikiPathways)
context("Pathway")

test_that("get WP554", {
  info = getPathwayInfo("WP554")
  expect_that(info$id, equals("WP554"))
})

test_that("get WP554 (again)", {
  info = getPathwayInfo(pathway="WP554")
  expect_that(info$id, equals("WP554"))
})
