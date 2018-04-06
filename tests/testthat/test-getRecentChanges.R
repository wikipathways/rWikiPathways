library(rWikiPathways)
context("Pathway")

test_that("get by date", {
    info = getRecentChanges('20180201000000')
    expect_gt(length(info), 0)
})

