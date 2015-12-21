library(rWikiPathways)
context("Pathway")

test_that("colored pathway", {
  svg = getColoredPathway(pathway="WP1842", graphId=c("dd68a","a2c17"));
  expect_that(nchar(svg), not(equals(0)))
})

test_that("green colored pathway", {
  svg = getColoredPathway(pathway="WP1842", graphId=c("dd68a","a2c17"),
    color="00FF00");
  expect_that(nchar(svg), not(equals(0)))
})

test_that("colored pathway (vector)", {
  svg = getColoredPathway(pathway="WP1842", graphId=c("dd68a","a2c17"),
    color=c("FF0000", "00FF00"));
  expect_that(nchar(svg), not(equals(0)))
})
