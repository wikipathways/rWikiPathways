library(rWikiPathways)
context("Annotation")

test_that("get by WPID", {
    terms = getOntologyTerms('WP554')
    expect_gt(length(terms), 0)
})

test_that("find by ontology term", {
    pathways = getPathwaysByOntologyTerm('PW:0000002')
    expect_gt(length(pathways), 0)
})

test_that("find by parent ontology term", {
    pathways = getPathwaysByParentOntologyTerm('signaling pathway')
    expect_gt(length(pathways), 0)
})
