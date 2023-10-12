library(rWikiPathways)
context("Lists")

test_that("pathways are found", {
  pathways = listPathways()
  expect_gt(length(pathways), 0)
})

test_that("Anopheles gambiae pathways are found", {
    pathways = listPathways(organism="Anopheles gambiae")
    expect_gt(length(pathways), 0)
})
