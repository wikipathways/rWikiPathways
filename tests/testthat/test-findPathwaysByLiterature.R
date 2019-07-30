library(rWikiPathways)
context("Search")

test_that("find by keyword", {
    pathways = findPathwaysByLiterature("cancer")
    expect_gt(length(pathways), 0)
})

test_that("find by pmid (again)", {
    pathways = findPathwaysByLiterature(query="10423528")
    expect_gt(length(pathways), 0)
})

test_that("find by author", {
    pathways = findPathwaysByLiterature(query="smith")
    expect_gt(length(pathways), 0)
})
