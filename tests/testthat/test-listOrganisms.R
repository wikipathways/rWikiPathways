library(rWikiPathways)
context("Lists")

test_that("organisms are found", {
  organisms = listOrganisms()
  expect_gt(length(organisms), 0)
  expect_true("Anopheles gambiae" %in% organisms)
})
