library(rWikiPathways)
context("Annotation")

test_that("get by WPID", {
    tags = getCurationStatus('WP554')
    expect_gt(length(tags),0)
})

test_that("get community info", {
    tags = listCommunities()
    expect_gt(length(tags), 0)
})

test_that("find by tag name", {
    pathways = getPathwaysByCommunity('COVID19')
    expect_gt(length(pathways), 0)
})
