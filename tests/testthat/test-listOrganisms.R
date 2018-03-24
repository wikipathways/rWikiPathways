library(rWikiPathways)
context("Lists")

test_that("organisms are found", {
  organisms = listOrganisms()
  expect_that(nrow(organisms), not(equals(0)))
  expect_true("Anopheles gambiae" %in% organisms)
})
