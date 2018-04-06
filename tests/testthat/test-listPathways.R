library(rWikiPathways)
context("Lists")

test_that("pathways are found", {
  organisms = listPathways()
  expect_gt(length(organisms), 0)
})

test_that("Anopheles gambiae pathways are found", {
  organisms = listPathways(organism="Anopheles gambiae")
  expect_gt(length(organisms), 0)
})
