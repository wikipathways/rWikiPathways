library(rWikiPathways)
context("Pathway")

test_that("get WP4", {
  info = getPathwayInfo("WP4")
  expect_that(info[1], equals("WP4"))
})

test_that("get WP4 (again)", {
  info = getPathwayInfo(pathway="WP4")
  expect_that(info[1], equals("WP4"))
})
