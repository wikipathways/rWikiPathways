library(rWikiPathways)
context("Annotation")

test_that("get by WPID", {
    tags = getCurationTags('WP554')
    expect_gt(length(tags),0)
})

test_that("get by tag name", {
    tags = getEveryCurationTag('Curation:FeaturedPathway')
    expect_gt(length(tags), 0)
})

test_that("find by tag name", {
    pathways = getPathwaysByCurationTag('Curation:FeaturedPathway')
    expect_gt(length(pathways), 0)
})
