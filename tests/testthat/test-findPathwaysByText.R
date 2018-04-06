library(rWikiPathways)
context("Search")

test_that("find by keyword", {
    pathways = findPathwaysByText("cancer")
    expect_gt(length(pathways),0)
})

test_that("find by datanode label (again)", {
    pathways = findPathwaysByText(query="5-FU")
    expect_gt(length(pathways), 0)
})

test_that("find by multiple keywords", {
    pathways = findPathwaysByText(query=c("cancer", "5-FU"))
    expect_gt(length(pathways), 0)
})
