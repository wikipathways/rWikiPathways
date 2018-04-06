library(rWikiPathways)
context("Pathway")

test_that("get by pmid and date", {
    info = getPathwayHistory('WP554',20180201)
    expect_gt(length(info), 0)
})

